//
//  BookInfoViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/11/25.
//

import Foundation

final class InfoViewModel {
    
    private var book: Book
    private let cartCoreDataRepository: CartCoreDataRepository
    private let recentBookCoreDataRepository: RecentBookCoreDataRepository

    var title: String?
    var author: String?
    var thumbnailURL: String?
    var price: String?
    var contents: String?
    
    init(
        book: Book,
        cartCoreDataRepository: CartCoreDataRepository,
        recentBookCoreDataRepository: RecentBookCoreDataRepository
    ) {
        self.cartCoreDataRepository = cartCoreDataRepository
        self.recentBookCoreDataRepository = recentBookCoreDataRepository
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
    
    func addBookToCart() {
        self.cartCoreDataRepository.saveOrUpdateBookToCart(book: book)
    }
    
    func manageRecentBook() {
        recentBookCoreDataRepository.configureRecentBook(book: book)
    }
}
