//
//  ZoomTransitionDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates the iOS 18 zoom transition: tap a card and it morphs into
/// the detail screen, staying interactive (draggable) throughout - both on
/// push and on the interactive-pop back gesture.
final class ZoomTransitionDemoViewController: FeatureDemoViewController {

    private var thumbnailViews: [String: UIView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(scrollView)

        let rows = UIStackView()
        rows.axis = .vertical
        rows.spacing = 16
        rows.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(rows)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: demoContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: demoContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: demoContainer.bottomAnchor),

            rows.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            rows.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            rows.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            rows.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            rows.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])

        for pair in ZoomTransitionCard.all.chunked(into: 2) {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 16
            row.distribution = .fillEqually
            for card in pair {
                row.addArrangedSubview(makeThumbnail(for: card))
            }
            rows.addArrangedSubview(row)
        }
    }

    private func makeThumbnail(for card: ZoomTransitionCard) -> UIView {
        let container = UIView()
        container.backgroundColor = card.color
        container.layer.cornerRadius = 20
        container.heightAnchor.constraint(equalToConstant: 160).isActive = true
        container.accessibilityIdentifier = card.id
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped(_:))))

        let imageView = UIImageView(image: UIImage(systemName: card.systemImageName))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = card.title
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)
        container.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 44),

            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        thumbnailViews[card.id] = container
        return container
    }

    @objc private func thumbnailTapped(_ gesture: UITapGestureRecognizer) {
        guard let id = gesture.view?.accessibilityIdentifier,
              let card = ZoomTransitionCard.all.first(where: { $0.id == id }) else { return }
        showDetail(for: card)
    }

    private func showDetail(for card: ZoomTransitionCard) {
        let detailViewController = ZoomTransitionDetailViewController(card: card)

        // The system calls this closure again on dismissal, so it looks up
        // the thumbnail by the stable card ID rather than capturing a view.
        detailViewController.preferredTransition = .zoom { [weak self] context in
            guard let detail = context.zoomedViewController as? ZoomTransitionDetailViewController else {
                return nil
            }
            return self?.thumbnailViews[detail.cardID]
        }

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
