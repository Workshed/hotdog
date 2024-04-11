//
//  ImageViewController.swift
//  HotDog
//
//  Created by Daniel Leivers on 08/04/2024.
//

import UIKit

class ImageViewController: UIViewController, StoryboardViewController {
    weak var coordinator: MainCoordinator?

    let image: UIImage

    @IBOutlet private weak var evaluatingLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var loadingContainer: UIStackView!

    @IBOutlet private var hotdogBackgroundViews: [UIView]!
    @IBOutlet private var notHotdogBackgroundViews: [UIView]!

    @IBOutlet private var roundedViews: [UIView]!

    // MARK: - Init

    init?(coder: NSCoder, image: UIImage, coordinator: MainCoordinator) {
        self.image = image
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a UIImage and Coordinator.")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        roundedViews.forEach { rounded in
            rounded.layer.cornerRadius = rounded.bounds.width / 2.0
        }

        imageView.image = image
        hotdogBackgroundViews.forEach { bg in
            bg.isHidden = true
        }

        notHotdogBackgroundViews.forEach { bg in
            bg.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupProcessingImage()
    }

    private func setupProcessingImage() {
        loadingContainer.isHidden = false
        Task.init {
            do {
                let isHotdog = try await isImageHotdog()
                loadingContainer.isHidden = true
                showResult(isHotDog: isHotdog)
            } catch {
                print(error)
            }
        }
    }

    private func isImageHotdog() async throws -> Bool {
        return try await DetectionFactory.isImageHotdog(image: image)
    }

    private func showResult(isHotDog: Bool) {
        if isHotDog {
            hotdogBackgroundViews.forEach { bg in
                bg.isHidden = false
            }
        }
        else {
            notHotdogBackgroundViews.forEach { bg in
                bg.isHidden = false
            }
        }
    }
}
