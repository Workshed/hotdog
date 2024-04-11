//
//  UIImage+stroke.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

extension UIImage {
    func withSymbolConfiguration(pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default, textColor: UIColor, backgroundColor: UIColor = .clear, borderColor: UIColor, borderWidth: CGFloat) -> UIImage? {
            // Configure the symbol with the specified pointSize, weight, and scale.
            let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
            let symbolImage = self.withConfiguration(configuration)

            // Begin image context
            UIGraphicsBeginImageContextWithOptions(symbolImage.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
            context.interpolationQuality = .high

            let rect = CGRect(origin: .zero, size: symbolImage.size)

            // Draw the background color
            context.setFillColor(backgroundColor.cgColor)
            context.fill(rect)

            // Draw the symbol image as a mask
            context.translateBy(x: 0, y: symbolImage.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.clip(to: rect, mask: symbolImage.cgImage!)

            // Set the fill color to the text color and fill the symbol
            context.setFillColor(textColor.cgColor)
            context.fill(rect)

            // Draw the border with the stroke color
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            context.strokePath()

            // Retrieve the finished image
            let finishedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return finishedImage
        }

    func withStroke(width: CGFloat, color: UIColor) -> UIImage? {
        let imageSize = size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Draw the original image as the base
        draw(at: .zero, blendMode: .normal, alpha: 1.0)

        // Set the stroke parameters
        context.setLineWidth(width)
        context.setLineJoin(.round)

        // Translate and scale the context to draw the stroke
        context.translateBy(x: 0, y: imageSize.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Draw the stroke
        context.setStrokeColor(color.cgColor)
        context.setBlendMode(.normal)

        // Stroke path
        context.strokePath()

        // Get the final image
        let strokedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return strokedImage
    }
}
