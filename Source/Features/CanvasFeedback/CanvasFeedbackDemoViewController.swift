//
//  CanvasFeedbackDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates `UICanvasFeedbackGenerator`, new in iOS 18 for drawing/canvas
/// apps. Drag the square; when it snaps to the center gridline, the
/// generator fires alignment feedback at the touch location. Most useful
/// with Apple Pencil Pro or a trackpad-connected iPad, but it also drives
/// the Taptic Engine on iPhone.
final class CanvasFeedbackDemoViewController: FeatureDemoViewController {

    private let square: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 12
        view.frame.size = CGSize(width: 64, height: 64)
        return view
    }()

    private let verticalGuide: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "Drag the square across the guide."
        return label
    }()

    private var feedbackGenerator: UICanvasFeedbackGenerator?
    private var wasAligned = false
    private var didPositionSquare = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // `square` is positioned by frame/center from the pan gesture below,
        // so it deliberately keeps `translatesAutoresizingMaskIntoConstraints`
        // at its default `true` and opts out of Auto Layout.
        demoContainer.addSubview(square)

        [verticalGuide, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            demoContainer.addSubview($0)
        }

        square.isUserInteractionEnabled = true
        square.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))

        NSLayoutConstraint.activate([
            verticalGuide.centerXAnchor.constraint(equalTo: demoContainer.centerXAnchor),
            verticalGuide.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            verticalGuide.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -16),
            verticalGuide.widthAnchor.constraint(equalToConstant: 1),

            statusLabel.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])

        feedbackGenerator = UICanvasFeedbackGenerator(view: demoContainer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didPositionSquare, demoContainer.bounds.width > 0 else { return }
        didPositionSquare = true
        square.center = CGPoint(x: demoContainer.bounds.midX - 80, y: 100)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let dragged = gesture.view else { return }

        switch gesture.state {
        case .began:
            feedbackGenerator?.prepare()
        case .changed:
            let translation = gesture.translation(in: demoContainer)
            dragged.center.x += translation.x
            dragged.center.y += translation.y
            gesture.setTranslation(.zero, in: demoContainer)

            let isAligned = abs(dragged.center.x - demoContainer.bounds.midX) < 8
            if isAligned, !wasAligned {
                feedbackGenerator?.alignmentOccurred(at: gesture.location(in: demoContainer))
                statusLabel.text = "Aligned! Feedback fired at the touch location."
            } else if !isAligned {
                statusLabel.text = "Drag the square across the guide."
            }
            wasAligned = isAligned
        default:
            break
        }
    }
}
