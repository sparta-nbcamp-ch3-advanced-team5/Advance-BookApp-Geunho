//
//  String+Extension.swift
//  BookApp
//
//  Created by 정근호 on 5/14/25.
//

import Foundation

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
