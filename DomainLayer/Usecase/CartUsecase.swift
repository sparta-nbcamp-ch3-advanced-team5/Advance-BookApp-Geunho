//
//  CartUsecaseProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation

public struct CartUsecase: CartUsecaseProtocol {
    
    private let cartCoreDataRepository: CartCoreDataRepositoryProtocol
    
    public init(cartCoreDataRepository: CartCoreDataRepositoryProtocol) {
        self.cartCoreDataRepository = cartCoreDataRepository
    }
    
    public func saveOrUpdateBookToCart(book: Book) {
        cartCoreDataRepository.saveOrUpdateBookToCart(book: book)
    }
    
    public func fetchCartItems() -> [CartItem] {
        cartCoreDataRepository.fetchCartItems()
    }
    
    public func removeAllCartItems() {
        cartCoreDataRepository.removeAllCartItems()
    }
    
    public func removeItem(item: CartItem) {
        cartCoreDataRepository.removeItem(item: item)
    }
    
    public func plusQuantity(item: CartItem) {
        cartCoreDataRepository.plusQuantity(item: item)
    }
    
    public func minusQuantity(item: CartItem) {
        cartCoreDataRepository.minusQuantity(item: item)
    }
    
    public func findCartItem(isbn: String) -> CartItem? {
        cartCoreDataRepository.findCartItem(isbn: isbn)
    }    
}
