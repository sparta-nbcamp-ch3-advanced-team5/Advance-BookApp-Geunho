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
    private let cartUsecase: CartUsecaseProtocol
    private let recentBookUsecase: RecentBookUsecaseProtocol

    var title: String?
    var author: String?
    var thumbnailURL: String?
    var price: String?
    var contents: String?
    
    public init(
        book: Book,
        cartUsecase: CartUsecaseProtocol,
        recentBookUsecase: RecentBookUsecaseProtocol
    ) {
        self.cartUsecase = cartUsecase
        self.recentBookUsecase = recentBookUsecase
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
        self.cartUsecase.saveOrUpdateBookToCart(book: book)
    }
    
    func manageRecentBook() {
        recentBookUsecase.configureRecentBook(book: book)
    }
}
