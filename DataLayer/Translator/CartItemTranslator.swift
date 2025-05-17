//
//  CartItemTranslator.swift
//  BookApp
//
//  Created by 정근호 on 5/16/25.
//

import Foundation
import DomainLayer

struct CartItemTranslator {
    static func toDomain(dto: CartItemDTO) -> CartItem {
        return CartItem(
            isbn: dto.isbn,
            title: dto.title,
            authors: dto.authors.components(separatedBy: ", "),
            contents: dto.contents,
            price: dto.price,
            thumbnailURL: dto.thumbnailURL,
            quantity: dto.quantity,
            addedDate: dto.addedDate
        )
    }
    
    static func toDTO(model: CartItem) -> CartItemDTO {
        return CartItemDTO(
            isbn: model.isbn,
            title: model.title,
            authors: model.authors.joined(separator: ", "),
            contents: model.contents,
            price: model.price,
            thumbnailURL: model.thumbnailURL,
            quantity: model.quantity,
            addedDate: model.addedDate
        )
    }
}
