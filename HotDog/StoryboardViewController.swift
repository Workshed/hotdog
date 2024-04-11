//
//  StoryboardViewController.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

// Useful for when there's multiple storyboards - saves typos in strings.
// Granted it's not massively useful in this context of a single Storyboard.
enum AppStoryboard: String {
    case main = "Main"
}

protocol StoryboardViewController {
    static func instantiate(from storyboard: AppStoryboard, creator: ((NSCoder) -> UIViewController?)?) -> Self
}

/// Helper function to make loading ViewControllers from a Storyboard  a little bit nicer
extension StoryboardViewController where Self: UIViewController {
    static func instantiate(from storyboard: AppStoryboard, creator: ((NSCoder) -> UIViewController?)? = nil) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: className, creator: creator) as! Self
    }
}
