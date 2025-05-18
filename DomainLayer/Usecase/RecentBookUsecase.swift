//
//  RecentBookUsecase.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation

public struct RecentBookUsecase: RecentBookUsecaseProtocol {
    
    private let recentBookCoreDataRespository: RecentBookCoreDataRepositoryProtocol
    
    public init(recentBookCoreDataRespository: RecentBookCoreDataRepositoryProtocol) {
        self.recentBookCoreDataRespository = recentBookCoreDataRespository
    }
    
    public func fetchRecentBook() -> [Book] {
        recentBookCoreDataRespository.fetchRecentBook()
    }
    
    public func configureRecentBook(book: Book) {
        recentBookCoreDataRespository.configureRecentBook(book: book)
    }
}
