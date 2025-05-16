//
//  CartItem.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation

/// BookEntity + CartInfoEntity
struct CartItem {
    let isbn: String
    let title: String
    let authors: [String]
    let contents: String
    let price: Int
    let thumbnailURL: String
    let quantity: Int
    let addedDate: Date
}
