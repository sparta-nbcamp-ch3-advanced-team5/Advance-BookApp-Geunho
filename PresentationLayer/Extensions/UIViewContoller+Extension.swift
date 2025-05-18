//
//  NavigateToBookInfoView.swift
//  BookApp
//
//  Created by 정근호 on 5/9/25.
//

import UIKit
import DomainLayer

extension UIViewController {

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
    
    /// 책 담기 완료 시 토스트 알림 창
    func showAlert() {
        
        if view.viewWithTag(999) != nil {
            self.view.viewWithTag(999)?.removeFromSuperview()
        }
        
        let toast = UILabel()
        toast.text = "책 담기 완료!"
        toast.tag = 999
        toast.textColor = .systemBackground
        toast.backgroundColor = UIColor.separator.withAlphaComponent(0.7)
        toast.textAlignment = .center
        toast.font = .systemFont(ofSize: 14, weight: .bold)
        toast.alpha = 0
        toast.clipsToBounds = true
        toast.numberOfLines = 0
        
        let padding: CGFloat = 20
        let maxWidth = (view.frame.width - padding * 2) / 2
        let size = toast.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        toast.frame = CGRect(x: view.frame.width/2 - (maxWidth/2),
                             y: view.frame.maxY - size.height - 130,
                             width: maxWidth,
                             height: size.height + 16)
        
        toast.layer.cornerRadius = toast.frame.height / 2
        
        view.addSubview(toast)
        
        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
        
    }
}
