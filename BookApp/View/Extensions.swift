//
//  NavigateToBookInfoView.swift
//  BookApp
//
//  Created by 정근호 on 5/9/25.
//

import UIKit
extension UIViewController {
    
    /// 영화 상세 뷰 모달 띄우기
    func navigateToBookInfoView() {
        let bottomSheetVC = BookInfoViewController()
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.9 })]
            sheet.preferredCornerRadius = 20
        }
        bottomSheetVC.modalPresentationStyle = .pageSheet
        present(bottomSheetVC, animated: true, completion: nil)
    }
}
