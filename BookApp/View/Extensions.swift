//
//  NavigateToBookInfoView.swift
//  BookApp
//
//  Created by 정근호 on 5/9/25.
//

import UIKit
extension UIViewController {
    
    /// 영화 상세 뷰 모달 띄우기
    func navigateToBookInfoView(selectedBook book: Book) {
        let bottomSheetVC = BookInfoViewController(viewModel: BookInfoViewModel(book: book))
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        bottomSheetVC.modalPresentationStyle = .pageSheet
        present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension String {
    
    func formatToWon() -> String {
        if let self = Int(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return (numberFormatter.string(from: NSNumber(value: self))!) + "원"
        } else {
            return self
        }
    }
}
