//
//  UILabel+border.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

extension UILabel {
    func applyBorder() {
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .foregroundColor : UIColor.white,
            .strokeWidth : -2.0,
            ]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
}
