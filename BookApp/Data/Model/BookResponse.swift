//
//  Book.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation

struct BookResponse: Codable{
    let meta: MetaData
    let documents: [Book]
}
