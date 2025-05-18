//
//  BookTranslator.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation
import DomainLayer

struct BookTranslator {
    static func toDomain(from dto: BookDTO) -> Book {
        return Book(
            authors: dto.authors,
            contents: dto.contents,
            price: dto.price,
            title: dto.title,
            thumbnail: dto.thumbnail,
            isbn: dto.isbn
        )
    }
    
    static func toDomainInList(from dto: [BookDTO]) -> [Book] {
        return dto.map(toDomain)
    }
}
