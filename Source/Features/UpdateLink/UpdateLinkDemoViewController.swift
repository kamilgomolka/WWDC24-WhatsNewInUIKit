//
//  UpdateLinkDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates `UIUpdateLink`, the iOS 18 replacement for `CADisplayLink`.
/// It ties itself to a specific view (activating/deactivating automatically
/// as that view enters or leaves a window), and reports timing through
/// `UIUpdateInfo` instead of a separate frame-timestamp API.
final class UpdateLinkDemoViewController: FeatureDemoViewController {

    private let dot: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        view.layer.cornerRadius = 22
        view.frame.size = CGSize(width: 44, height: 44)
        return view
    }()

    private var updateLink: UIUpdateLink?
    private var toggleButton: UIButton?
    private var isRunning = false
    private var didPositionDot = false

    override func viewDidLoad() {
        super.viewDidLoad()

        demoContainer.addSubview(dot)

        let button = UIButton.demoAction(title: "Start", systemImage: "play.fill") { [weak self] in
            self?.toggleRunning()
        }
        toggleButton = button

        let caption = UILabel()
        caption.text = "view.center.y = sin(updateInfo.modelTime) * amplitude"
        caption.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        caption.textColor = .secondaryLabel
        caption.textAlignment = .center

        let controls = UIStackView(arrangedSubviews: [button, caption])
        controls.axis = .vertical
        controls.spacing = 12
        controls.alignment = .center
        controls.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(controls)

        NSLayoutConstraint.activate([
            controls.centerXAnchor.constraint(equalTo: demoContainer.centerXAnchor),
            controls.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])

        // Activates automatically once `dot` is part of a visible window,
        // and invalidates itself when the view is removed - no explicit
        // add/remove-from-run-loop bookkeeping like CADisplayLink required.
        let link = UIUpdateLink(view: dot, actionTarget: self, selector: #selector(update(updateLink:updateInfo:)))
        link.requiresContinuousUpdates = false
        link.isEnabled = false
        updateLink = link
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didPositionDot, demoContainer.bounds.width > 0 else { return }
        didPositionDot = true
        dot.center = CGPoint(x: demoContainer.bounds.midX, y: demoContainer.bounds.height * 0.4)
    }

    private func toggleRunning() {
        isRunning.toggle()
        updateLink?.requiresContinuousUpdates = isRunning
        updateLink?.isEnabled = isRunning
        var configuration = UIButton.Configuration.filled()
        configuration.title = isRunning ? "Stop" : "Start"
        configuration.image = UIImage(systemName: isRunning ? "stop.fill" : "play.fill")
        configuration.imagePadding = 6
        configuration.cornerStyle = .medium
        toggleButton?.configuration = configuration
    }

    @objc private func update(updateLink: UIUpdateLink, updateInfo: UIUpdateInfo) {
        let baseline = demoContainer.bounds.height * 0.4
        dot.center = CGPoint(
            x: demoContainer.bounds.midX,
            y: baseline + sin(updateInfo.modelTime * 3) * 90
        )
    }
}
