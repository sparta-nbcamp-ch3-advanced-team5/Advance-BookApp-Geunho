//
//  MetaDataDTO.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation

struct MetaDataDTO: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
}
