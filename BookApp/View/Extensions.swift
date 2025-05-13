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
        bottomSheetVC.delegate = self as? BookInfoViewControllerDelegate
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        bottomSheetVC.modalPresentationStyle = .pageSheet
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    /// 알림 창 띄우기 (취소/삭제)
    func showDeletingAlert(title: String,
                   message: String,
                   cancelAction: ((UIAlertAction) -> Void)? = nil,
                   deleteAction: ((UIAlertAction) -> Void)? = nil,
                   completion: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteAction)
        alertViewController.addAction(deleteAction)
        
        self.present(alertViewController, animated: true, completion: completion)
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
