//
//  RecentBookCoreDataRepositoryProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/16/25.
//

import Foundation

public protocol RecentBookCoreDataRepositoryProtocol {
    func fetchRecentBook() -> [Book]
    func configureRecentBook(book: Book)
}
