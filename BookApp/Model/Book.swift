//
//  Book.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation

struct Book: Codable {
    let authors: [String]
    let contents: String
    let price: Int
    let title: String
    let thumbnail: String
}
