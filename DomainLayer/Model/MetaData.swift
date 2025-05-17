//
//  MetaData.swift
//  BookApp
//
//  Created by 정근호 on 5/10/25.
//

import Foundation

public struct MetaData: Decodable{
    public let isEnd: Bool
    public let pageableCount: Int
    public let totalCount: Int
    
    public init(isEnd: Bool, pageableCount: Int, totalCount: Int) {
        self.isEnd = isEnd
        self.pageableCount = pageableCount
        self.totalCount = totalCount
    }
}
