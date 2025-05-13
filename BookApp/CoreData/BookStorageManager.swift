//
//  BookStorageManager.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//

import CoreData
import UIKit

final class BookStorageManager {
    static let shared = BookStorageManager()
    private init() {}
    
    private let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다.")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func saveBookToCart(book: Book, quantity: Int = 1) {
        guard let context = context else { return }
        
        // BookEntity를 찾기
        let bookFetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        bookFetchRequest.predicate = NSPredicate(format: "isbn == %@", book.isbn)
        
        var bookEntityToAddToCart = BookEntity()
        
        do {
            
            let results = try context.fetch(bookFetchRequest)
            if let existingBook = results.first {
                bookEntityToAddToCart = existingBook
            } else {
                // BookEntity가 없으면 새로 생성 (실제로는 saveOrUpdateBook 호출이 더 적절할 수 있음)
                let newBook = BookEntity(context: context)
                newBook.isbn = book.isbn
                newBook.title = book.title
                newBook.authors = book.authors
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
    
    func fetchCartItems() -> [CartItem] {
        guard let context = context else { return [] }
        
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
                    authors: bookEntity.authors ?? [],
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
}
