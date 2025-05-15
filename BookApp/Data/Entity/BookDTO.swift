//
//  BookDTO.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation

struct BookDTO: Codable {
    let authors: [String]
    let contents: String
    let price: Int
    let title: String
    let thumbnail: String
    let isbn: String
}
