//
//  AutomaticTraitTrackingDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// A view whose `layoutSubviews()` reads `horizontalSizeClass` to pick a
/// layout. In iOS 18, simply reading a trait inside a supported update
/// method (like this one) is enough - UIKit records the dependency and
/// calls `setNeedsLayout` automatically when the trait changes. Before this,
/// you'd register for the trait change manually and call `setNeedsLayout`
/// yourself. No such registration exists here.
private final class SizeClassAwareView: UIView {

    private let compactBadge = UILabel()
    private let regularBadge = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        for badge in [compactBadge, regularBadge] {
            badge.textAlignment = .center
            badge.font = .preferredFont(forTextStyle: .headline)
            badge.layer.cornerRadius = 12
            badge.layer.masksToBounds = true
            addSubview(badge)
        }
        compactBadge.text = "Compact layout: stacked"
        compactBadge.backgroundColor = .systemOrange.withAlphaComponent(0.2)
        regularBadge.text = "Regular layout: side by side"
        regularBadge.backgroundColor = .systemBlue.withAlphaComponent(0.2)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func layoutSubviews() {
        super.layoutSubviews()

        if traitCollection.horizontalSizeClass == .compact {
            compactBadge.frame = bounds
            regularBadge.frame = .zero
        } else {
            let halfWidth = bounds.width / 2
            compactBadge.frame = CGRect(x: 0, y: 0, width: halfWidth - 4, height: bounds.height)
            regularBadge.frame = CGRect(x: halfWidth + 4, y: 0, width: halfWidth - 4, height: bounds.height)
        }
    }
}

final class AutomaticTraitTrackingDemoViewController: FeatureDemoViewController {

    private let demoView = SizeClassAwareView()

    override func viewDidLoad() {
        super.viewDidLoad()

        demoView.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(demoView)

        let segmentedControl = UISegmentedControl(items: ["System", "Compact", "Regular"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addAction(UIAction { [weak self] action in
            guard let control = action.sender as? UISegmentedControl else { return }
            self?.applyOverride(forSegment: control.selectedSegmentIndex)
        }, for: .valueChanged)

        let hintLabel = UILabel()
        hintLabel.text = "Forcing horizontalSizeClass below uses UIView.traitOverrides (iOS 17). Watch the layout above update - no manual setNeedsLayout call anywhere in this file."
        hintLabel.font = .preferredFont(forTextStyle: .footnote)
        hintLabel.textColor = .secondaryLabel
        hintLabel.numberOfLines = 0

        let controls = UIStackView(arrangedSubviews: [segmentedControl, hintLabel])
        controls.axis = .vertical
        controls.spacing = 12
        controls.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(controls)

        NSLayoutConstraint.activate([
            demoView.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            demoView.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            demoView.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            demoView.heightAnchor.constraint(equalToConstant: 100),

            controls.topAnchor.constraint(equalTo: demoView.bottomAnchor, constant: 24),
            controls.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func applyOverride(forSegment index: Int) {
        switch index {
        case 1:
            demoView.traitOverrides.horizontalSizeClass = .compact
        case 2:
            demoView.traitOverrides.horizontalSizeClass = .regular
        default:
            demoView.traitOverrides.remove(UITraitHorizontalSizeClass.self)
        }
    }
}
