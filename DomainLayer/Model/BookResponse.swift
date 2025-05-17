//
//  BookResponse.swift
//  DomainLayer
//
//  Created by 정근호 on 5/17/25.
//

import Foundation

public struct BookResponse: Decodable {
    public let meta: MetaData
    public let documents: [Book]
    
    public init(meta: MetaData, documents: [Book]) {
        self.meta = meta
        self.documents = documents
    }
}
