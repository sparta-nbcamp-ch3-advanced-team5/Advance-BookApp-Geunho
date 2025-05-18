//
//  RecentBookUsecaseProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation

public protocol RecentBookUsecaseProtocol {
    func fetchRecentBook() -> [Book]
    func configureRecentBook(book: Book)
}
