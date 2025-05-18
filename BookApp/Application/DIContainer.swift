//
//  DIContainer.swift
//  BookApp
//
//  Created by 정근호 on 5/17/25.
//

import Foundation
import DataLayer
import PresentationLayer
import DomainLayer
import CoreData
import UIKit

// BookApp → PresentationLayer → DomainLayer
// 동시에 BookApp → DomainLayer 직접 import
// -> DomainLayer 두 번 import 될 수 있음.

struct DIContainer {
    
    // API
    let bookResponseRepository: DomainLayer.BookResponseRepositoryProtocol
    // CoreData
    let cartCoreDataRepository: DomainLayer.CartCoreDataRepositoryProtocol
    let recentBookCoreDataRepository: DomainLayer.RecentBookCoreDataRepositoryProtocol
    
    init(context: NSManagedObjectContext) {
        self.bookResponseRepository = BookResponseRepository()
        self.cartCoreDataRepository = CartCoreDataRepository(context: context)
        self.recentBookCoreDataRepository = RecentBookCoreDataRepository(context: context)
    }
    
    func makeSearchViewController(delegate: ViewControllerDelegate?) -> SearchViewController {
        
        let viewModel = SearchViewModel(
            bookResponseRepository: bookResponseRepository,
            recentBookCoreDataRepository: recentBookCoreDataRepository
        )
        let vc = SearchViewController(viewModel: viewModel)
        vc.delegate = delegate
        return vc
    }
    
    func makecartViewController(delegate: ViewControllerDelegate?) -> CartViewController {
        
        let viewModel = CartViewModel(
            cartCoreDataRepository: cartCoreDataRepository
        )
        let vc = CartViewController(viewModel: viewModel)
        vc.delegate = delegate
        return vc
    }
    
    func makeInfoViewController(book: Book) -> InfoViewController {
        let viewModel = InfoViewModel(
            book: book,
            cartCoreDataRepository: cartCoreDataRepository,
            recentBookCoreDataRepository: recentBookCoreDataRepository
        )
        
        return InfoViewController(viewModel: viewModel)
    }
}
