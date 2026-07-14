//
//  FeatureDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Common chrome shared by every feature demo screen: a title (set on the
/// navigation item, giving the standard back button for free), a short
/// explanation of the WWDC24 API being shown, and a `demoContainer` for the
/// feature-specific interactive content.
///
/// Subclasses should avoid declaring their own initializers - give any
/// stored properties default values so the inherited `init(title:explanation:)`
/// stays usable and `FeatureCatalog` can build every screen the same way.
class FeatureDemoViewController: UIViewController {

    private let explanation: String

    let demoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// - Parameters are passed as plain strings, rather than a whole
    ///   `UIKitFeature`, so `FeatureCatalog`'s static properties can build
    ///   their own demo view controller in the same expression that defines
    ///   them without the compiler flagging a circular reference.
    init(title: String, explanation: String) {
        self.explanation = explanation
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        explanationLabel.text = explanation

        view.addSubview(explanationLabel)
        view.addSubview(divider)
        view.addSubview(demoContainer)

        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            explanationLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            divider.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1.0 / traitCollection.displayScale),

            demoContainer.topAnchor.constraint(equalTo: divider.bottomAnchor),
            demoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            demoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            demoContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
