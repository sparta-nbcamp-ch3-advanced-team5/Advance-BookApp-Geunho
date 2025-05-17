//
//  CartInfoTranslator.swift
//  DataLayer
//
//  Created by 정근호 on 5/17/25.
//

import Foundation
import DomainLayer

struct CartInfoTranslator {
    static func toDomain(dto: CartInfoDTO) -> CartInfo {
        return CartInfo(
            addedDate: dto.addedDate,
            quantity: dto.quantity
        )
    }
    
    static func toDTO(model: CartInfo) -> CartInfoDTO {
        return CartInfoDTO(
            addedDate: model.addedDate,
            quantity: model.quantity
        )
    }
}
