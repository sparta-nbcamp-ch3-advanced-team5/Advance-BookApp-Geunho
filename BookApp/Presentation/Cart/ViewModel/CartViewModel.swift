//
//  BookCartViewModel.swift
//  BookApp
//
//  Created by 정근호 on 5/12/25.
//

import Foundation
import RxSwift

final class CartViewModel {

    /// 장바구니 아이템 목록 스트림
    let cartItems: BehaviorSubject<[CartItem]>
    /// 장바구니가 비었는지 여부를 나타내는 스트림
    let isCartEmpty: Observable<Bool>
    
    private let cartCoreDataRepository: CartCoreDataRepository
    private let disposeBag = DisposeBag()
    
    init(cartCoreDataRepository: CartCoreDataRepository) {
        
        self.cartCoreDataRepository = cartCoreDataRepository
        // 초기 장바구니 아이템 로드
        let initialItems = self.cartCoreDataRepository.fetchCartItems()
        self.cartItems = BehaviorSubject(value: initialItems)
        
        // isCartEmpty는 cartDisplayItems 스트림을 변환하여 생성
        self.isCartEmpty = self.cartItems
            .map { $0.isEmpty }          // 아이템 배열이 비었는지 여부로 변환
            .distinctUntilChanged()      // 이전 값과 동일하면 방출하지 않음
            .share(replay: 1, scope: .whileConnected) // 구독자가 생길 때 최신값 공유
    }
    
    func findBookByCartItem(isbn: String) -> Book {
        let cartItem = cartCoreDataRepository.findCartInfoEntity(forBookISBN: isbn)
        
        return Book(
            authors: cartItem?.book?.authors?.components(separatedBy: ", ") ?? [],
            contents: cartItem?.book?.contents ?? "",
            price: Int(cartItem?.book?.price ?? 0),
            title: cartItem?.book?.title ?? "",
            thumbnail: cartItem?.book?.thumbnailURL ?? "",
            isbn: cartItem?.book?.isbn ?? ""
        )
    }
    
    // MARK: - Actions
    func refreshCartItems() {
        let updatedItems = cartCoreDataRepository.fetchCartItems()
        cartItems.onNext(updatedItems)
    }
    
    func removeAllCartItems() {
        cartCoreDataRepository.removeAllCartItems()
        self.refreshCartItems()
    }
    
    func plusQuantity(cartItem: CartItem) {
        cartCoreDataRepository.plusQuantity(item: cartItem)
        self.refreshCartItems()
    }
    
    func minusQuantity(cartItem: CartItem) {
        cartCoreDataRepository.minusQuantity(item: cartItem)
        self.refreshCartItems()
    }
    
    func removeItem(cartItem: CartItem) {
        cartCoreDataRepository.removeItem(item: cartItem)
        self.refreshCartItems()
    }
}
