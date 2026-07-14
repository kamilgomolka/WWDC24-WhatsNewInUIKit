//
//  MainViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Root screen: a scrollable list of buttons, one per WWDC24 UIKit feature.
/// Tapping a button pushes that feature's dedicated demo view controller
/// onto the surrounding navigation controller (see `SceneDelegate`), which
/// supplies the standard back button.
final class MainViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "What's New in UIKit"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])

        for feature in FeatureCatalog.allFeatures {
            stackView.addArrangedSubview(makeButton(for: feature))
        }
    }

    private func makeButton(for feature: UIKitFeature) -> UIButton {
        var configuration = UIButton.Configuration.gray()
        configuration.title = feature.title
        configuration.subtitle = feature.subtitle
        configuration.image = UIImage(systemName: feature.systemImageName)
        configuration.imagePadding = 14
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .leading
        configuration.baseForegroundColor = .label
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)

        var titleAttributes = AttributeContainer()
        titleAttributes.font = .preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = AttributedString(feature.title, attributes: titleAttributes)

        var subtitleAttributes = AttributeContainer()
        subtitleAttributes.font = .preferredFont(forTextStyle: .footnote)
        subtitleAttributes.foregroundColor = .secondaryLabel
        configuration.attributedSubtitle = AttributedString(feature.subtitle, attributes: subtitleAttributes)

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.addAction(UIAction { [weak self] _ in
            self?.presentDemo(for: feature)
        }, for: .touchUpInside)
        return button
    }

    private func presentDemo(for feature: UIKitFeature) {
        navigationController?.pushViewController(feature.makeDemoViewController(), animated: true)
    }
}
