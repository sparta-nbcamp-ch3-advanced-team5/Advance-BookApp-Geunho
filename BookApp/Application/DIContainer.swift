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
    
        let bookResponseUsecase = BookResponseUsecase(bookResponseRepository: bookResponseRepository)
        let recentBookUsecase = RecentBookUsecase(recentBookCoreDataRespository: recentBookCoreDataRepository)
        
        let viewModel = SearchViewModel(
            bookResponseUsecase: bookResponseUsecase,
            recentBookUsecase: recentBookUsecase
        )
        return SearchViewController(viewModel: viewModel, delegate: delegate)
    }
    
    func makeCartViewController(delegate: ViewControllerDelegate?) -> CartViewController {
        
        let cartUsecase = CartUsecase(cartCoreDataRepository: cartCoreDataRepository)
        
        let viewModel = CartViewModel(
            cartUsecase: cartUsecase
        )
        return CartViewController(viewModel: viewModel, delegate: delegate)
    }
    
    func makeInfoViewController(book: Book) -> InfoViewController {
        
        let cartUsecase = CartUsecase(cartCoreDataRepository: cartCoreDataRepository)
        let recentBookUsecase = RecentBookUsecase(recentBookCoreDataRespository: recentBookCoreDataRepository)

        let viewModel = InfoViewModel(
            book: book,
            cartUsecase: cartUsecase,
            recentBookUsecase: recentBookUsecase
        )
        
        return InfoViewController(viewModel: viewModel)
    }
}
