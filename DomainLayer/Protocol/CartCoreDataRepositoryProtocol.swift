//
//  CartCoreDataRepositoryProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/16/25.
//

import Foundation

public protocol CartCoreDataRepositoryProtocol {
    func saveOrUpdateBookToCart(book: Book)
    func fetchCartItems() -> [CartItem]
    func removeAllCartItems()
    func removeItem(item: CartItem)
    func plusQuantity(item: CartItem)
    func minusQuantity(item: CartItem)
    func findCartItem(isbn: String) -> CartItem?
}
