//
//  AppDelegate.swift
//  BookApp
//
//  Created by 정근호 on 5/8/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstVC = UINavigationController(rootViewController: BookSearchViewController())
        let secondVC = UINavigationController(rootViewController: BookCartViewController())
        
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([firstVC, secondVC], animated: true)
        tabBarVC.tabBar.backgroundColor = .systemBackground
        tabBarVC.tabBar.tintColor = .label
        
        if let items = tabBarVC.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "book.fill")
            items[0].image = UIImage(systemName: "book")
            items[0].title = "책 검색"
            
            items[1].selectedImage = UIImage(systemName: "cart.fill")
            items[1].image = UIImage(systemName: "cart")
            items[1].title = "장바구니"
        }
        
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}
