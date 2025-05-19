//
//  Protocol.swift
//  PresentationLayer
//
//  Created by 정근호 on 5/19/25.
//

import Foundation
import DomainLayer

public protocol BottomSheetDelegate: AnyObject {
    /// 장바구니에 책 추가 시
    func didAddToCart()
    /// 책 상세 바텀시트가 닫힐 시
    func bottomSheetDidDismiss()
}

public protocol ViewControllerDelegate: AnyObject {
    func didSelectBook(_ book: Book)
}
