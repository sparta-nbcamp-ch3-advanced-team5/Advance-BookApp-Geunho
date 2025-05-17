//
//  Book.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation

// init을 public으로 일일이 수정해ㅇ 함
public struct Book {
    public let authors: [String]
    public let contents: String
    public let price: Int
    public let title: String
    public let thumbnail: String
    public let isbn: String
    
    public init(authors: [String], contents: String, price: Int, title: String, thumbnail: String, isbn: String) {
        self.authors = authors
        self.contents = contents
        self.price = price
        self.title = title
        self.thumbnail = thumbnail
        self.isbn = isbn
    }
}
