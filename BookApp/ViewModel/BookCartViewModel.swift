//
//  BookCartViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//

import Foundation

class BookCartViewModel {
    
    private var cartItem: [CartItem]?
    private let bookStorageManager: BookStorageManager
    
    init(bookStorageManger: BookStorageManager) {
        self.bookStorageManager = bookStorageManger
        self.cartItem = bookStorageManger.fetchCartItems()
    }
}
