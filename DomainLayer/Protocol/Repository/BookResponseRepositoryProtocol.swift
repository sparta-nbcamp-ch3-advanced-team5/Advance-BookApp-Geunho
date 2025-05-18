//
//  BookResponseRepositoryProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/17/25.
//

import Foundation
import RxSwift

public protocol BookResponseRepositoryProtocol {
    func fetchBookResponse<T: Decodable>(url: URL) -> Single<T>
}
