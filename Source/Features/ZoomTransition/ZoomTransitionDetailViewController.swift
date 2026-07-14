//
//  ZoomTransitionDetailViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Destination of the zoom transition. Exposes `cardID` so the presenting
/// screen's `sourceViewProvider` closure can look up the correct thumbnail
/// again on both zoom-in and zoom-out, as recommended by Apple's "Enhancing
/// your app with fluid transitions" guide.
final class ZoomTransitionDetailViewController: UIViewController {

    let cardID: String
    private let card: ZoomTransitionCard

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(card: ZoomTransitionCard) {
        self.card = card
        self.cardID = card.id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = card.color
        imageView.image = UIImage(systemName: card.systemImageName)
        titleLabel.text = card.title

        view.addSubview(imageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
