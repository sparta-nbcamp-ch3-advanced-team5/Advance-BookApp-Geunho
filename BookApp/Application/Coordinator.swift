//
//  Coordinator.swift
//  BookApp
//
//  Created by 정근호 on 5/18/25.
//

import Foundation
import DataLayer
import PresentationLayer
import DomainLayer
import CoreData
import UIKit

final class Coordinator {
    private let tabBarController: UITabBarController
    private let diContainer: DIContainer
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.tabBarController = UITabBarController()
    }
    
    /// 초기 책 검색, 장바구니 화면 생성, 탭바에 적용
    func start() -> UITabBarController {
        
        let searchVC = diContainer.makeSearchViewController(delegate: self)
        let cartVC = diContainer.makeCartViewController(delegate: self)
        let firstNav = UINavigationController(rootViewController: searchVC)
        let secondNav = UINavigationController(rootViewController: cartVC)
        
        tabBarController.setViewControllers([firstNav, secondNav], animated: true)
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = .label
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "book.fill")
            items[0].image = UIImage(systemName: "book")
            items[0].title = "책 검색"
            
            items[1].selectedImage = UIImage(systemName: "cart.fill")
            items[1].image = UIImage(systemName: "cart")
            items[1].title = "장바구니"
        }
        
        return tabBarController
    }
    
    /// 책 상세 뷰로 이동
    func navigateToBookInfoView(selectedBook book: Book) {
        
        let infoVC = diContainer.makeInfoViewController(book: book)
        
        if let sheet = infoVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        infoVC.modalPresentationStyle = .pageSheet
        
        // 현재 화면에 표시된 VC에서 present 해야 함
        // 위 start()에서 해당 뷰컨트롤러들을 UINavigationController()로 감쌌기에 selectedViewController의 type -> UINavigationController
        // UINavigationController는 UIViewController의 자식이기에 as?로 형변환
        if let nav = tabBarController.selectedViewController as? UINavigationController,
           // SearchView, CartView 둘다 BottomSheetDelegate를 채택하기에 형변환
           let visibleVC = nav.visibleViewController as? BottomSheetDelegate {
            infoVC.bottomSheetDelegate = visibleVC
            nav.present(infoVC, animated: true, completion: nil)
        } else {
            print("❌ delegate 설정 실패: BottomSheetDelegate 채택한 VC를 찾을 수 없음")
        }
    }
}

extension Coordinator: ViewControllerDelegate {
    func didSelectBook(_ book: DomainLayer.Book) {
        navigateToBookInfoView(selectedBook: book)
    }
}
