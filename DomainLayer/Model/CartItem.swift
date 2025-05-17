//
//  CartItem.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation

/// BookEntity + CartInfoEntity
public struct CartItem {
    public let isbn: String
    public let title: String
    public let authors: [String]
    public let contents: String
    public let price: Int
    public let thumbnailURL: String
    public let quantity: Int
    public let addedDate: Date
    
    public init(isbn: String, title: String, authors: [String], contents: String, price: Int, thumbnailURL: String, quantity: Int, addedDate: Date) {
        self.isbn = isbn
        self.title = title
        self.authors = authors
        self.contents = contents
        self.price = price
        self.thumbnailURL = thumbnailURL
        self.quantity = quantity
        self.addedDate = addedDate
    }
}
