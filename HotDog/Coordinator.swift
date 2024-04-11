//
//  Coordinator.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

protocol Coordinator: NSObject {
    func start()
}

class MainCoordinator: NSObject, Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate(from: .main)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func chosenImage(_ image: UIImage) {
        let vc = ImageViewController.instantiate(from: .main) { coder in
            return ImageViewController(coder: coder, image: image, coordinator: self)
        }
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
