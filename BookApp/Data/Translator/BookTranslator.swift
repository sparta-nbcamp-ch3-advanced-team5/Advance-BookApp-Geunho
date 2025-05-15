//
//  BookTranslator.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation

struct BookTranslator {
    static func translate(from dto: BookDTO) -> Book {
        return Book(
            authors: dto.authors,
            contents: dto.contents,
            price: dto.price,
            title: dto.title,
            thumbnail: dto.thumbnail,
            isbn: dto.isbn
        )
    }
    
    static func translateList(from dto: [BookDTO]) -> [Book] {
        return dto.map(translate)
    }
}
