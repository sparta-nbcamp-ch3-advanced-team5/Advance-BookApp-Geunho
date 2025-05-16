//
//  CoreDataProtocol.swift
//  BookApp
//
//  Created by 정근호 on 5/14/25.
//

import Foundation

protocol CartStorageManager {
    func saveOrUpdateBookToCart(book: Book, quantity: Int)
    func fetchCartItems() -> [CartItem]
    func removeAllCartItems()
    func removeItem(item: CartItem)
    func plusQuantity(item: CartItem)
    func minusQuantity(item: CartItem)
    func findCartInfoEntity(forBookISBN isbn: String) -> CartInfoEntity?
}

protocol RecentBookStorageManager {
    func fetchRecentBook() -> [Book]
    func configureRecentBook(book: Book)
}
