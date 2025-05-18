//
//  BookResponse.swift
//  DomainLayer
//
//  Created by 정근호 on 5/18/25.
//

import Foundation

public struct BookResponse: Decodable {
    public let meta: MetaData
    public let documents: [Book]
}
