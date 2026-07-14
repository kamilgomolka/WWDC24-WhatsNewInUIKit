//
//  TabsAndSidebarDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates the iOS 18 `UITab` / `UITabGroup` API, which replaces
/// assigning `viewControllers` + `tabBarItem` directly on `UITabBarController`.
/// Grouping tabs with `UITabGroup` and setting `mode = .tabSidebar` gives a
/// combined tab bar/sidebar experience that adapts per platform - on iPad
/// and Mac Catalyst it becomes a real sidebar; here on a pushed screen it
/// stays a tab bar, but the same declarative setup drives both.
final class TabsAndSidebarDemoViewController: FeatureDemoViewController {

    private let embeddedTabBarController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(embeddedTabBarController)
        let embeddedView: UIView = embeddedTabBarController.view
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        embeddedView.layer.cornerRadius = 16
        embeddedView.layer.borderWidth = 1
        embeddedView.layer.borderColor = UIColor.separator.cgColor
        embeddedView.clipsToBounds = true
        demoContainer.addSubview(embeddedView)
        embeddedTabBarController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            embeddedView.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            embeddedView.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            embeddedView.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            embeddedView.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        embeddedTabBarController.mode = .tabSidebar
        embeddedTabBarController.tabs = [
            UITab(title: "Watch Now", image: UIImage(systemName: "play.circle.fill"), identifier: "watch") { _ in
                Self.makePlaceholder(title: "Watch Now", color: .systemRed)
            },
            UITab(title: "Library", image: UIImage(systemName: "books.vertical.fill"), identifier: "library") { _ in
                Self.makePlaceholder(title: "Library", color: .systemIndigo)
            },
            UITabGroup(
                title: "Collections",
                image: UIImage(systemName: "folder.fill"),
                identifier: "collections",
                children: [
                    UITab(title: "Favorites", image: UIImage(systemName: "star.fill"), identifier: "favorites") { _ in
                        Self.makePlaceholder(title: "Favorites", color: .systemYellow)
                    },
                    UITab(title: "Downloads", image: UIImage(systemName: "arrow.down.circle.fill"), identifier: "downloads") { _ in
                        Self.makePlaceholder(title: "Downloads", color: .systemGreen)
                    }
                ]
            ) { _ in
                Self.makePlaceholder(title: "Collections", color: .systemTeal)
            }
        ]
    }

    private static func makePlaceholder(title: String, color: UIColor) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = color.withAlphaComponent(0.15)

        let label = UILabel()
        label.text = title
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        return viewController
    }
}
