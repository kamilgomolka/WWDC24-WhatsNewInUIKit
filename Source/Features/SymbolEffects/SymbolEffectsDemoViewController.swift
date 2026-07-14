//
//  SymbolEffectsDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates the three SF Symbols animation presets added in iOS 18 -
/// Wiggle, Rotate, and Breathe - plus Magic Replace, which now animates a
/// symbol's badge/slash independently of its base shape.
final class SymbolEffectsDemoViewController: FeatureDemoViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bell.fill"))
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 96, weight: .regular)
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var isBadged = false

    override func viewDidLoad() {
        super.viewDidLoad()

        demoContainer.addSubview(imageView)

        let effectsRow = UIStackView(arrangedSubviews: [
            UIButton.demoAction(title: "Wiggle", systemImage: "hand.wave.fill") { [weak self] in
                self?.imageView.addSymbolEffect(.wiggle, options: .repeat(.periodic(2, delay: 0.3)))
            },
            UIButton.demoAction(title: "Rotate", systemImage: "arrow.clockwise") { [weak self] in
                self?.imageView.addSymbolEffect(.rotate, options: .repeat(.periodic(2, delay: 0.3)))
            }
        ])
        let effectsRow2 = UIStackView(arrangedSubviews: [
            UIButton.demoAction(title: "Breathe", systemImage: "wind") { [weak self] in
                self?.imageView.addSymbolEffect(.breathe, options: .repeat(.periodic(2, delay: 0.3)))
            },
            UIButton.demoSecondaryAction(title: "Reset", systemImage: "xmark.circle") { [weak self] in self?.reset() }
        ])
        for row in [effectsRow, effectsRow2] {
            row.axis = .horizontal
            row.spacing = 12
            row.distribution = .fillEqually
        }

        let magicReplaceButton = UIButton.demoAction(title: "Magic Replace (toggle badge)", systemImage: "bell.badge") { [weak self] in
            self?.toggleBadge()
        }

        let controls = UIStackView(arrangedSubviews: [effectsRow, effectsRow2, magicReplaceButton])
        controls.axis = .vertical
        controls.spacing = 12
        controls.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(controls)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: demoContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: demoContainer.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            controls.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            controls.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func reset() {
        imageView.removeAllSymbolEffects()
        isBadged = false
        imageView.image = UIImage(systemName: "bell.fill")
    }

    private func toggleBadge() {
        isBadged.toggle()
        let newImage = UIImage(systemName: isBadged ? "bell.badge.fill" : "bell.fill")!
        imageView.setSymbolImage(newImage, contentTransition: .replace)
    }
}
