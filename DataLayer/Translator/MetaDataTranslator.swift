//
//  MetaDataTranslator.swift
//  BookApp
//
//  Created by 정근호 on 5/15/25.
//

import Foundation
import DomainLayer

struct MetaDataTranslator {
    static func toDomain(from dto: MetaDataDTO) -> MetaData {
        return MetaData(
            isEnd: dto.isEnd,
            pageableCount: dto.pageableCount,
            totalCount: dto.totalCount
        )
    }
}
