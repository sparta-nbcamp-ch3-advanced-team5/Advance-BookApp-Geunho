//
//  CartItemDTO.swift
//  BookApp
//
//  Created by 정근호 on 5/16/25.
//

import Foundation

struct CartItemDTO {
    let isbn: String
    let title: String
    let authors: String
    let contents: String
    let price: Int
    let thumbnailURL: String
    let quantity: Int
    let addedDate: Date
}
