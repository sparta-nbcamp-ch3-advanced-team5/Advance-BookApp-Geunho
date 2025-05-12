//
//  BookCartViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//

import Foundation
import RxSwift

class BookCartViewModel {

    /// 장바구니 아이템 목록 스트림
    let cartItems: BehaviorSubject<[CartItem]>
    /// 장바구니가 비었는지 여부를 나타내는 스트림
    let isCartEmpty: Observable<Bool>
    
    private let bookStorageManager: BookStorageManager
    private let disposeBag = DisposeBag()
    init(bookStorageManager: BookStorageManager) {
        self.bookStorageManager = bookStorageManager
        
        // 초기 장바구니 아이템 로드
        let initialItems = self.bookStorageManager.fetchCartItems()
        self.cartItems = BehaviorSubject(value: initialItems)
        
        // isCartEmpty는 cartDisplayItems 스트림을 변환하여 생성
        self.isCartEmpty = self.cartItems
            .map { $0.isEmpty }          // 아이템 배열이 비었는지 여부로 변환
            .distinctUntilChanged()      // 이전 값과 동일하면 방출하지 않음
            .share(replay: 1, scope: .whileConnected) // 구독자가 생길 때 최신값 공유
    }
    
    // MARK: - Actions
    func refreshCartItems() {
        let updatedItems = bookStorageManager.fetchCartItems()
        cartItems.onNext(updatedItems)
    }
}
