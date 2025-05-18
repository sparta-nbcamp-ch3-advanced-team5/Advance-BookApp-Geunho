//
//  RecentBookCoreDataRepositoryProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/16/25.
//

import Foundation
import DomainLayer

public protocol RecentBookCoreDataRepositoryProtocol {
    func fetchRecentBook() -> [Book]
    func configureRecentBook(book: Book)
}
