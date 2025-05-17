//
//  BookResponseRepositoryProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/17/25.
//

import Foundation

public protocol BookResponseRepositoryProtocol {
    func fetchBookResponse<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}
