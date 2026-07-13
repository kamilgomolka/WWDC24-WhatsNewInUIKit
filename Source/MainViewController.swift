//
//  MainViewController.swift
//  WWDC24-WhatsNewInUIKit
//
//  Created by Kamil Gomolka on 13/07/2026.
//

import UIKit

final class MainViewController: UIViewController {

    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(helloLabel)

        NSLayoutConstraint.activate([
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
