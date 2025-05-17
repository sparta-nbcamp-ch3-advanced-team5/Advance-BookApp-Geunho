//
//  CartCoreDataRepository.swift
//  BookApp
//
//  Created by 정근호 on 5/16/25.
//

import Foundation
import CoreData
import DomainLayer

public final class CartCoreDataRepository: CartCoreDataRepositoryProtocol {
   
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Create
    /// BookEntity가 있으면 바로 CartInfoEntity에 저장
    /// 없으면 새로 생성 후 CartInfoEntity에 저장
    public func saveOrUpdateBookToCart(book: Book) {
        
        // BookEntity를 찾기
        let bookFetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        bookFetchRequest.predicate = NSPredicate(format: "isbn == %@", book.isbn)
        
        var bookEntityToAddToCart = BookEntity()
        
        do {
            
            let results = try context.fetch(bookFetchRequest)
            if let existingBook = results.first {
                bookEntityToAddToCart = existingBook
            } else {
                // BookEntity가 없으면 새로 생성
                let newBook = BookEntity(context: context)
                newBook.isbn = book.isbn
                newBook.title = book.title
                newBook.authors = book.authors.joined(separator: ", ")
                newBook.contents = book.contents
                newBook.price = Int32(book.price)
                newBook.thumbnailURL = book.thumbnail
                bookEntityToAddToCart = newBook
            }
            
        } catch {
            print("addItemToCart 중 BookEntity를 찾는 데 실패: \(error)")
            context.rollback()
        }
        
        // CartInfoEntity 로직
        let cartFetchRequest: NSFetchRequest<CartInfoEntity> = CartInfoEntity.fetchRequest()
        cartFetchRequest.predicate = NSPredicate(format: "book == %@", bookEntityToAddToCart)
        
        do {
            let results = try context.fetch(cartFetchRequest)
            let cartInfoEntity: CartInfoEntity
            
            if let existingCartItem = results.first {
                existingCartItem.quantity += 1
                cartInfoEntity = existingCartItem
            } else {
                cartInfoEntity = CartInfoEntity(context: context)
                cartInfoEntity.book = bookEntityToAddToCart
                cartInfoEntity.quantity = 1
                cartInfoEntity.addedDate = Date()
            }
            
            try context.save()
            print("CartItem for \(bookEntityToAddToCart.title ?? "") saved/updated successfully.")
            
        } catch let error as NSError {
            print("CartItemEntity 저장 또는 업데이트 실패: \(error), \(error.userInfo)")
            context.rollback()
        }
    }
    
    // MARK: - Read
    /// CartItem 가져옴
    public func fetchCartItems() -> [CartItem] {
        
        let fetchRequest: NSFetchRequest<CartInfoEntity> = CartInfoEntity.fetchRequest()
        
        do {
            let cartInfoEntities = try context.fetch(fetchRequest)
            
            return cartInfoEntities.map { cartItemEntity -> CartItem in
                
                // CartItemEntity에 연결되어있는 BookEntity 가져옴
                guard let bookEntity = cartItemEntity.book else {
                    fatalError("Cart item has no associated book entity!")
                }
                
                let cartItemDTO = CartItemDTO(
                    isbn: bookEntity.isbn ?? "",
                    title: bookEntity.title ?? "",
                    authors: bookEntity.authors ?? "",
                    contents: bookEntity.contents ?? "",
                    price: Int(bookEntity.price),
                    thumbnailURL: bookEntity.thumbnailURL ?? "",
                    quantity: Int(cartItemEntity.quantity),
                    addedDate: cartItemEntity.addedDate ?? Date()
                )
                
                let cartItem = CartItemTranslator.toDomain(dto: cartItemDTO)
                
                return cartItem
            }
        } catch {
            print("장바구니 아이템 가져오기 실패: \(error)")
            return []
        }
    }
    
    // MARK: - Delete
    /// 장바구니 비우기
    public func removeAllCartItems() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartInfoEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount // 삭제된 객체의 수를 결과로 받도록 설정 (선택 사항)
        
        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let numDeleted = result?.result as? Int ?? 0
            print("\(numDeleted)개의 장바구니 아이템이 batch delete로 삭제되었습니다.")
            
            // NSBatchDeleteRequest는 Persistent Store에서 직접 작동하므로,
            // 현재 NSManagedObjectContext의 메모리 내 객체들은 이 변경사항을 자동으로 알지 못함
            // UI가 이 변경사항을 반영하려면 컨텍스트 리셋 필요
            context.reset()
            // context.reset()을 호출하면, 다음에 fetch를 할 때 데이터베이스에서 최신 상태를 가져옴
            // 전체 삭제 시 ViewModel에서 refreshCartItems() 호출 필요
            
        } catch let error as NSError {
            print("NSBatchDeleteRequest를 사용한 전체 삭제 실패: \(error), \(error.userInfo)")
        }
    }
    
    /// 해당 CartItem 장바구니에서 제거
    public func removeItem(item: CartItem) {
        
        guard let cartItemEntityToDelete = findCartInfoEntity(forBookISBN: item.isbn) else {
            print("삭제할 장바구니 아이템을 찾지 못했습니다 (ISBN: \(item.isbn)).")
            return
        }
        
        context.delete(cartItemEntityToDelete) // CartInfoEntity 삭제
        
        do {
            try context.save()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 삭제 성공.")
        } catch {
            context.rollback() // 저장 실패 시 롤백
            print("장바구니 아이템 (ISBN: \(item.isbn)) 삭제 실패.")
        }
    }
    
    // MARK: - Update
    /// 해당 CartItem 수량 +1
    public func plusQuantity(item: CartItem) {
        
        guard let cartItemEntity = findCartInfoEntity(forBookISBN: item.isbn) else {
            print("수량 증가 대상 장바구니 아이템을 찾지 못했습니다 (ISBN: \(item.isbn)).")
            return
        }
        
        cartItemEntity.quantity += 1
        
        do {
            try context.save()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 성공. 현재 수량: \(cartItemEntity.quantity)")
        } catch {
            context.rollback()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 성공. 현재 수량: \(cartItemEntity.quantity)")
        }
    }
    
    /// 해당 CartItem 수량 -1(CartViewController에서 수량 1일 경우 삭제시 removeItem)
    public func minusQuantity(item: CartItem) {
        
        guard let cartInfoEntity = findCartInfoEntity(forBookISBN: item.isbn) else {
            print("수량 증가 대상 장바구니 아이템을 찾지 못했습니다 (ISBN: \(item.isbn)).")
            return
        }
        
        cartInfoEntity.quantity -= 1
        
        do {
            try context.save()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 성공. 현재 수량: \(cartInfoEntity.quantity)")
        } catch {
            context.rollback()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 실패. 현재 수량: \(cartInfoEntity.quantity)")
        }
    }
    
    /// isbn으로 CartItem을 찾음
    /// 안에서 findCartInfoEntity를 사용
    public func findCartItem(isbn: String) -> CartItem? {
        guard let cartEntity = findCartInfoEntity(forBookISBN: isbn),
              let bookEntity = cartEntity.book else {
            return nil
        }
        
        let cartItemDTO = CartItemDTO(
            isbn: bookEntity.isbn ?? "",
            title: bookEntity.title ?? "",
            authors: bookEntity.authors ?? "",
            contents: bookEntity.contents ?? "",
            price: Int(bookEntity.price),
            thumbnailURL: bookEntity.thumbnailURL ?? "",
            quantity: Int(cartEntity.quantity),
            addedDate: cartEntity.addedDate ?? Date()
        )
        
        return CartItemTranslator.toDomain(dto: cartItemDTO)
    }
    
    /// isbn에 맞는 CartInfoEntity 찾기
    private func findCartInfoEntity(forBookISBN isbn: String) -> CartInfoEntity? {
        
        // 1. ISBN으로 BookEntity 찾기
        let bookFetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        bookFetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        let bookEntities: [BookEntity]
        do {
            bookEntities = try context.fetch(bookFetchRequest)
        } catch {
            print("BookEntity 찾기 실패")
            return nil
        }
        
        guard let foundBookEntity = bookEntities.first else {
            // 책이 데이터베이스에 없음 -> 이 책에 대한 장바구니 항목도 없음
            print("BookStorageManager: ISBN \(isbn)에 해당하는 책을 찾을 수 없습니다.")
            return nil
        }
        
        // 2. 찾은 BookEntity로 CartItemEntity 찾기
        let cartInfoFetchRequest: NSFetchRequest<CartInfoEntity> = CartInfoEntity.fetchRequest()
        cartInfoFetchRequest.predicate = NSPredicate(format: "book == %@", foundBookEntity)
        
        let cartInfoList: [CartInfoEntity]
        do {
            cartInfoList = try context.fetch(cartInfoFetchRequest)
        } catch {
            print("CartItemEntity 찾기 실패")
            return nil
        }
        
        return cartInfoList.first
    }
}
