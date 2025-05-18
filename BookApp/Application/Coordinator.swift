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
    
    private var searchVC: SearchViewController!
    private var cartVC: CartViewController!
    private var infoVC: InfoViewController!
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        self.tabBarController = UITabBarController()
    }
    
    func start() -> UITabBarController {
        
        self.searchVC = diContainer.makeSearchViewController(delegate: self)
        self.cartVC = diContainer.makeCartViewController(delegate: self)
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
    
    func navigateToBookInfoView(selectedBook book: Book) {
        
        self.infoVC = diContainer.makeInfoViewController(book: book)
        
        if let sheet = infoVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        infoVC.modalPresentationStyle = .pageSheet
        
        // ✅ 현재 화면에 표시된 VC에서 present 해야 함
        if let topVC = tabBarController.selectedViewController {
            topVC.present(infoVC, animated: true, completion: nil)
        } else {
            print("❌ 현재 표시 중인 ViewController 없음")
        }
    }
}

extension Coordinator: ViewControllerDelegate {
    func didSelectBook(_ book: DomainLayer.Book) {
        navigateToBookInfoView(selectedBook: book)
    }
}
