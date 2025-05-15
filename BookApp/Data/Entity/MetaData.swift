//
//  MetaData.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation

struct MetaData: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
