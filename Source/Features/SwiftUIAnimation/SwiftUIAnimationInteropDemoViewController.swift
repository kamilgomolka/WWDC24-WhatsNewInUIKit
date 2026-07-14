//
//  SwiftUIAnimationInteropDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

// `import SwiftUI` here is only for the `Animation` value type passed into
// `UIView.animate(_:changes:completion:)` below - no SwiftUI view is built
// or presented anywhere in this project.
import SwiftUI
import UIKit

/// Demonstrates the iOS 18 UIKit/SwiftUI animation interop: SwiftUI
/// `Animation` values (including its spring curves) can now drive plain
/// `UIView` property animations via the new `UIView.animate(_:changes:completion:)`
/// overload - no `UIViewPropertyAnimator` or `CAAnimation` juggling required.
final class SwiftUIAnimationInteropDemoViewController: FeatureDemoViewController {

    private let bead: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 28
        view.frame.size = CGSize(width: 56, height: 56)
        return view
    }()

    private var homeCenter: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        demoContainer.addSubview(bead)
        bead.isUserInteractionEnabled = true
        bead.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))

        let jumpButton = UIButton.demoAction(title: "Animate with SwiftUI spring", systemImage: "wand.and.stars") { [weak self] in
            self?.jumpToRandomSpot()
        }
        let hintLabel = UILabel()
        hintLabel.text = "Or drag the dot - it tracks your finger with .interactiveSpring, then settles with .spring."
        hintLabel.font = .preferredFont(forTextStyle: .footnote)
        hintLabel.textColor = .secondaryLabel
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center

        let controls = UIStackView(arrangedSubviews: [jumpButton, hintLabel])
        controls.axis = .vertical
        controls.spacing = 12
        controls.alignment = .center
        controls.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(controls)

        NSLayoutConstraint.activate([
            controls.leadingAnchor.constraint(greaterThanOrEqualTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            controls.trailingAnchor.constraint(lessThanOrEqualTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            controls.centerXAnchor.constraint(equalTo: demoContainer.centerXAnchor),
            controls.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard homeCenter == nil, demoContainer.bounds.width > 0 else { return }
        let center = CGPoint(x: demoContainer.bounds.midX, y: demoContainer.bounds.height * 0.4)
        homeCenter = center
        bead.center = center
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let homeCenter else { return }
        let translation = gesture.translation(in: demoContainer)

        switch gesture.state {
        case .changed:
            UIView.animate(.interactiveSpring) {
                self.bead.center = CGPoint(x: homeCenter.x + translation.x, y: homeCenter.y + translation.y)
            }
        case .ended, .cancelled:
            UIView.animate(.spring(duration: 0.5, bounce: 0.45)) {
                self.bead.center = homeCenter
            }
        default:
            break
        }
    }

    private func jumpToRandomSpot() {
        let insetBounds = demoContainer.bounds.insetBy(dx: 60, dy: 60)
        guard insetBounds.width > 0, insetBounds.height > 0 else { return }
        let randomPoint = CGPoint(
            x: CGFloat.random(in: insetBounds.minX...insetBounds.maxX),
            y: CGFloat.random(in: insetBounds.minY...insetBounds.maxY)
        )
        UIView.animate(.spring(duration: 0.6, bounce: 0.55)) {
            self.bead.center = randomPoint
        }
    }
}
