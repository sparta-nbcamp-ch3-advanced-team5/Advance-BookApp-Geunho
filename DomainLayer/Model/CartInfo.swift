//
//  CartInfo.swift
//  DomainLayer
//
//  Created by 정근호 on 5/16/25.
//

import Foundation

public struct CartInfo {
    public let addedDate: Date
    public let quantity: Int16
    
    public init(addedDate: Date, quantity: Int16) {
        self.addedDate = addedDate
        self.quantity = quantity
    }
}
