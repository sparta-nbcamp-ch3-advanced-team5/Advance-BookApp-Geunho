//
//  BookInfoViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/11/25.
//

import Foundation

class BookInfoViewModel {
    
    private var book: Book
        
    var title: String?
    var author: String?
    var thumbnailURL: String?
    var price: String?
    var contents: String?
    
    init(book: Book) {
        self.book = book
        self.updateBookData()
    }
    
    func updateBookData() {
        title = book.title
        author = book.authors.joined(separator: ", ")
        thumbnailURL = book.thumbnail
        price = String(book.price).formatToWon()
        contents = book.contents
    }
}
