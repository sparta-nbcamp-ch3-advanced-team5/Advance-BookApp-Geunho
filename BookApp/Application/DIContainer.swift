//
//  DIContainer.swift
//  BookApp
//
//  Created by 정근호 on 5/17/25.
//

import Foundation
import DataLayer
import DomainLayer
import PresentationLayer
import CoreData
import UIKit

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

    func makeSearchViewController() -> SearchViewController {
    
        let viewModel = SearchViewModel(
            bookReponseRepository: bookResponseRepository,
            recentBookCoreDataRepository: recentBookCoreDataRepository
        )
        return SearchViewController(viewModel: viewModel)
    }
    
    func makecartViewController() -> CartViewController {
        
        let viewModel = CartViewModel(
            cartCoreDataRepository: cartCoreDataRepository
        )
        
        return CartViewController(viewModel: viewModel)
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
