//
//  UIImageView+stroke.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

extension UIImageView {
    func applyStrokeToImage(width: CGFloat, color: UIColor) {
        guard let currentImage = image else { return }
        image = currentImage.withStroke(width: width, color: color)
    }
}

