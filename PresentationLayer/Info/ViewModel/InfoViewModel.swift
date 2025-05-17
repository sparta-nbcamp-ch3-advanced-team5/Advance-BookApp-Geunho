//
//  BookInfoViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/11/25.
//

import Foundation
import DomainLayer

public final class InfoViewModel {
    
    private var book: Book
    private let cartCoreDataRepository: CartCoreDataRepositoryProtocol
    private let recentBookCoreDataRepository: RecentBookCoreDataRepositoryProtocol

    var title: String?
    var author: String?
    var thumbnailURL: String?
    var price: String?
    var contents: String?
    
    public init(
        book: Book,
        cartCoreDataRepository: CartCoreDataRepositoryProtocol,
        recentBookCoreDataRepository: RecentBookCoreDataRepositoryProtocol
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
