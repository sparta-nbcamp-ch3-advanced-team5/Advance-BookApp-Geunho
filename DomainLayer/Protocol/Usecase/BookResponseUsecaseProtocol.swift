//
//  BookResponseUsecaseProtocol.swift
//  DomainLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation
import RxSwift

public protocol BookResponseUsecaseProtocol {
    func fetchBookResponse<T: Decodable>(url: URL) -> Single<T>
}
