//
//  BookStorageManager.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Create
    /// BookEntity가 있으면 바로 CartItemEntity에 저장
    /// 없으면 새로 생성 후 CartItemEntity에 저장
    func saveOrUpdateBookToCart(book: Book, quantity: Int = 1) {
        
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
                newBook.authors = book.authors as NSArray
                newBook.contents = book.contents
                newBook.price = Int32(book.price)
                newBook.thumbnailURL = book.thumbnail
                bookEntityToAddToCart = newBook
            }
            
        } catch {
            print("addItemToCart 중 BookEntity를 찾는 데 실패: \(error)")
            context.rollback()
        }
        
        // CartItemEntity 로직
        let cartFetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        cartFetchRequest.predicate = NSPredicate(format: "book == %@", bookEntityToAddToCart)
        
        do {
            let results = try context.fetch(cartFetchRequest)
            let cartItemEntity: CartItemEntity
            
            if let existingCartItem = results.first {
                existingCartItem.quantity += Int16(quantity)
                cartItemEntity = existingCartItem
            } else {
                cartItemEntity = CartItemEntity(context: context)
                cartItemEntity.book = bookEntityToAddToCart
                cartItemEntity.quantity = Int16(quantity)
                cartItemEntity.addedDate = Date()
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
    func fetchCartItems() -> [CartItem] {
        
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let cartItemEntities = try context.fetch(fetchRequest)
            
            return cartItemEntities.map { cartItemEntity -> CartItem in
                
                // CartItemEntity에 연결되어있는 BookEntity 가져옴
                guard let bookEntity = cartItemEntity.book else {
                    fatalError("Cart item has no associated book entity!")
                }
                
                return CartItem(
                    isbn: bookEntity.isbn ?? "",
                    title: bookEntity.title ?? "",
                    authors: (bookEntity.authors ?? []) as! [String],
                    contents: bookEntity.contents ?? "",
                    price: Int(bookEntity.price),
                    thumbnailURL: bookEntity.thumbnailURL ?? "",
                    quantity: Int(cartItemEntity.quantity),
                    addedData: cartItemEntity.addedDate ?? Date()
                )
                
            }
        } catch {
            print("장바구니 아이템 가져오기 실패: \(error)")
            return []
        }
    }
    
    // MARK: - Delete
    /// 장바구니 비우기
    func removeAllCartItems() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CartItemEntity.fetchRequest()
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
    func removeItem(item: CartItem) {

        guard let cartItemEntityToDelete = findCartItemEntity(forBookISBN: item.isbn) else {
            print("삭제할 장바구니 아이템을 찾지 못했습니다 (ISBN: \(item.isbn)).")
            return
        }
        
        context.delete(cartItemEntityToDelete) // CartItemEntity 삭제
        
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
    func plusQuantity(item: CartItem) {

        guard let cartItemEntity = findCartItemEntity(forBookISBN: item.isbn) else {
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
    func minusQuantity(item: CartItem) {
        
        guard let cartItemEntity = findCartItemEntity(forBookISBN: item.isbn) else {
            print("수량 증가 대상 장바구니 아이템을 찾지 못했습니다 (ISBN: \(item.isbn)).")
            return
        }
        
        cartItemEntity.quantity -= 1
        
        do {
            try context.save()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 성공. 현재 수량: \(cartItemEntity.quantity)")
        } catch {
            context.rollback()
            print("장바구니 아이템 (ISBN: \(item.isbn)) 수량 감소 실패. 현재 수량: \(cartItemEntity.quantity)")
        }
    }
    
    /// isbn에 맞는 CartItem 찾기
    func findCartItemEntity(forBookISBN isbn: String) -> CartItemEntity? {
        
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
        let cartItemFetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        cartItemFetchRequest.predicate = NSPredicate(format: "book == %@", foundBookEntity)
        
        let cartItems: [CartItemEntity]
        do {
            cartItems = try context.fetch(cartItemFetchRequest)
        } catch {
            print("CartItemEntity 찾기 실패")
            return nil
        }
        
        return cartItems.first
    }
}

// MARK: - RecentBookEntity 관련
extension CoreDataManager {
    
    // MARK: - Read
    /// 최근 본 책 정보들 Book으로 변환하여 불러옴
    func fetchRecentBook() -> [Book] {
        
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
        
        do {
            let recentBookEntities = try context.fetch(fetchRequest)
            
            return recentBookEntities.map { recentBookEntity -> Book in
                
                return Book(
                    authors: recentBookEntity.authors as! [String],
                    contents: recentBookEntity.contents ?? "",
                    price: Int(recentBookEntity.price),
                    title: recentBookEntity.title ?? "",
                    thumbnail: recentBookEntity.thumbnail ?? "",
                    isbn: recentBookEntity.isbn ?? "")
            }
        } catch {
            print("장바구니 아이템 가져오기 실패: \(error)")
            return []
        }
    }
    
    // MARK: - Update
    /// 최근 본 책 설정(추가), 10개 일 시 가장 먼저 추가됐던 책 제거
    func configureRecentBook(book: Book) {
        
        if recentBookSize() < 10 {
            addRecentBook(book: book)
        } else {
            deleteFirstRecentBook()
            addRecentBook(book: book)
        }
        
    }
    
    // 최근 본 책 개수
    private func recentBookSize() -> Int {
        let recentBookSize = fetchRecentBook().count
        return recentBookSize
    }
    
    // MARK: - Create
    // 최근 본 책 추가
    private func addRecentBook(book: Book) {
        guard let recentBookEntity = NSEntityDescription.entity(forEntityName: "RecentBookEntity", in: persistentContainer.viewContext) else {
            return
        }
        
        deleteDuplicatedRecentBook(isbn: book.isbn)
        
        do {

            let managedObject = NSManagedObject(entity: recentBookEntity, insertInto: context)
            managedObject.setValue(book.title, forKey: "title")
            managedObject.setValue(book.thumbnail, forKey: "thumbnail")
            managedObject.setValue(book.price, forKey: "price")
            managedObject.setValue(book.authors, forKey: "authors")
            managedObject.setValue(book.isbn, forKey: "isbn")
            managedObject.setValue(book.contents, forKey: "contents")
        
            try context.save()
        } catch {
            print("최근 책 추가 실패: \(error)")
        }
    }
    
    // MARK: - Delete
    // 가장 먼저 추가됐던 최근 본 책 제거
    private func deleteFirstRecentBook() {
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()

        do {
            let recentBookEntities = try context.fetch(fetchRequest)
            
            let firstRecentBookEntity = recentBookEntities.first!
            
            context.delete(firstRecentBookEntity)
            
            try context.save()
        } catch {
            print("첫번째 삭제 실패: \(error)")
        }
    }
        
    private func deleteDuplicatedRecentBook(isbn: String) {
        let fetchRequest: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                for objectToDelete in results {
                    context.delete(objectToDelete)
                }
            }
        } catch {
            print("중복 삭제 실패: \(error)")
        }
    }
    
}
