//
//  UIButton+Demo.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

extension UIButton {

    /// A filled, icon + title action button used across demo screens for
    /// triggering the behavior being showcased.
    static func demoAction(title: String, systemImage: String? = nil, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        if let systemImage {
            configuration.image = UIImage(systemName: systemImage)
            configuration.imagePadding = 6
        }
        configuration.cornerStyle = .medium
        let button = UIButton(configuration: configuration)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }

    /// A lower-emphasis variant for secondary/reset actions.
    static func demoSecondaryAction(title: String, systemImage: String? = nil, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = title
        if let systemImage {
            configuration.image = UIImage(systemName: systemImage)
            configuration.imagePadding = 6
        }
        configuration.cornerStyle = .medium
        let button = UIButton(configuration: configuration)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }
}
