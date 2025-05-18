//
//  BookResponseUsecase.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation
import RxSwift

public struct BookResponseUsecase: BookResponseUsecaseProtocol {
    
    private let bookResponseRepository: BookResponseRepositoryProtocol
    
    public init(bookResponseRepository: BookResponseRepositoryProtocol) {
        self.bookResponseRepository = bookResponseRepository
    }
    
    public func fetchBookResponse<T>(url: URL) -> RxSwift.Single<T> where T: Decodable {
        bookResponseRepository.fetchBookResponse(url: url)
    }
}
