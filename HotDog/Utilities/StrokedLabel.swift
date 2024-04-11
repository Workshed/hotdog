//
//  StrokedLabel.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

class StrokedLabel: UILabel {

    var strokeColor: UIColor = .black
    var strokeWidth: CGFloat = 6 // Negative for stroke outside, positive for inside

    override func drawText(in rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let originalTextColor = textColor

            context.setLineWidth(strokeWidth)
            context.setLineJoin(.round)
            context.setTextDrawingMode(.stroke)
            self.textColor = strokeColor
            super.drawText(in: rect)

            context.setTextDrawingMode(.fill)
            self.textColor = originalTextColor
            super.drawText(in: rect)
        }
    }
}
