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
    
    func start() -> UITabBarController {
        
        let firstVC = UINavigationController(rootViewController: diContainer.makeSearchViewController(delegate: self))
        let secondVC = UINavigationController(rootViewController: diContainer.makecartViewController(delegate: self))
        
        tabBarController.setViewControllers([firstVC, secondVC], animated: true)
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
        
        let bottomSheetVC = InfoViewController(
            viewModel: InfoViewModel(
                book: book,
                cartCoreDataRepository: diContainer.cartCoreDataRepository,
                recentBookCoreDataRepository: diContainer.recentBookCoreDataRepository
            )
        )
//        // Delegate 설정
//        // self: SearchViewController 또는 CartViewController
//        bottomSheetVC.bottomSheetDelegate = self as? BottomSheetDelegate
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        bottomSheetVC.modalPresentationStyle = .pageSheet
        navigationController.present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension Coordinator: PresentationLayer.ViewControllerDelegate {
    func didSelectBook(_ book: DomainLayer.Book) {
        navigateToBookInfoView(selectedBook: book)
    }
}


