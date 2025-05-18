//
//  CartCoreDataUsecaseProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation

public protocol CartUsecaseProtocol {
    func saveOrUpdateBookToCart(book: Book)
    func fetchCartItems() -> [CartItem]
    func removeAllCartItems()
    func removeItem(item: CartItem)
    func plusQuantity(item: CartItem)
    func minusQuantity(item: CartItem)
    func findCartItem(isbn: String) -> CartItem?
}
