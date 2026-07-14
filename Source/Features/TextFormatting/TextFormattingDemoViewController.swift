//
//  TextFormattingDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Demonstrates the iOS 18 text formatting panel and text highlighting.
/// Any `UITextView` with `allowsEditingTextAttributes = true` now gets a
/// "Format..." Edit menu action for free, opening a system formatting panel.
/// Highlighting is just two new attributed-string attributes.
final class TextFormattingDemoViewController: FeatureDemoViewController {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.allowsEditingTextAttributes = true
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .secondarySystemBackground
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributedText = NSAttributedString(
            string: "Select some of this text, then use Edit \u{2192} Format... to try the new formatting panel.",
            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)]
        )

        let highlightButton = UIButton.demoAction(title: "Highlight selection", systemImage: "highlighter") { [weak self] in
            self?.highlightSelection()
        }
        let clearButton = UIButton.demoSecondaryAction(title: "Clear highlights", systemImage: "eraser") { [weak self] in
            self?.clearHighlights()
        }

        let buttonRow = UIStackView(arrangedSubviews: [highlightButton, clearButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = 12
        buttonRow.distribution = .fillEqually
        buttonRow.translatesAutoresizingMaskIntoConstraints = false

        demoContainer.addSubview(textView)
        demoContainer.addSubview(buttonRow)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: buttonRow.topAnchor, constant: -16),

            buttonRow.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            buttonRow.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),
            buttonRow.bottomAnchor.constraint(equalTo: demoContainer.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func highlightSelection() {
        let range = textView.selectedRange
        guard range.length > 0 else { return }

        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        mutable.addAttributes([
            .textHighlightStyle: NSAttributedString.TextHighlightStyle.default,
            .textHighlightColorScheme: NSAttributedString.TextHighlightColorScheme.mint
        ], range: range)
        textView.attributedText = mutable
        textView.selectedRange = range
    }

    private func clearHighlights() {
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        mutable.removeAttribute(.textHighlightStyle, range: NSRange(location: 0, length: mutable.length))
        mutable.removeAttribute(.textHighlightColorScheme, range: NSRange(location: 0, length: mutable.length))
        textView.attributedText = mutable
    }
}
