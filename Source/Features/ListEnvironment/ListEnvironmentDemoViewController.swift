//
//  ListEnvironmentDemoViewController.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// This project defaults every type to `@MainActor` isolation (see
/// `SWIFT_DEFAULT_ACTOR_ISOLATION` in the build settings), which would give
/// this struct's synthesized `Hashable` conformance a main-actor-isolated
/// conformance - and that can't satisfy the `Sendable` item identifier
/// requirement of `UICollectionViewDiffableDataSource`. `nonisolated` opts
/// this plain value type back out.
nonisolated private struct ListEnvironmentCellState: Hashable, Sendable {
    let text: String
}

/// Demonstrates `UITraitCollection.listEnvironment`, new in iOS 18. Every
/// view inside a `UICollectionView`/`UITableView` list now carries this
/// trait, so a cell can style itself for plain vs. grouped vs. sidebar lists
/// without the list needing to tell it explicitly at configuration time.
final class ListEnvironmentDemoViewController: FeatureDemoViewController {

    private enum Style: Int, CaseIterable {
        case plain, grouped, sidebar

        var title: String {
            switch self {
            case .plain: return "Plain"
            case .grouped: return "Grouped"
            case .sidebar: return "Sidebar"
            }
        }

        var layoutConfiguration: UICollectionLayoutListConfiguration {
            switch self {
            case .plain: return UICollectionLayoutListConfiguration(appearance: .plain)
            case .grouped: return UICollectionLayoutListConfiguration(appearance: .grouped)
            case .sidebar: return UICollectionLayoutListConfiguration(appearance: .sidebar)
            }
        }
    }

    private final class EnvironmentAwareCell: UICollectionViewListCell {
        var itemText: String = "" {
            didSet { setNeedsUpdateConfiguration() }
        }

        override func updateConfiguration(using state: UICellConfigurationState) {
            var content = UIListContentConfiguration.cell()
            content.text = itemText

            // Reading `listEnvironment` here needs no extra plumbing from
            // the list - it is set automatically on every subview inside a
            // UICollectionView/UITableView list section.
            switch traitCollection.listEnvironment {
            case .sidebar, .sidebarPlain:
                content.image = UIImage(systemName: "sidebar.left")
                content.imageProperties.tintColor = .systemPurple
                content.textProperties.color = .systemPurple
            case .grouped, .insetGrouped:
                content.image = UIImage(systemName: "square.grid.2x2")
                content.imageProperties.tintColor = .systemBlue
                content.textProperties.color = .label
            default:
                content.image = UIImage(systemName: "list.bullet")
                content.imageProperties.tintColor = .systemGray
                content.textProperties.color = .label
            }
            contentConfiguration = content
        }
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, ListEnvironmentCellState>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let segmentedControl = UISegmentedControl(items: Style.allCases.map(\.title))
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addAction(UIAction { [weak self] action in
            guard let control = action.sender as? UISegmentedControl,
                  let style = Style(rawValue: control.selectedSegmentIndex) else { return }
            self?.apply(style: style)
        }, for: .valueChanged)
        demoContainer.addSubview(segmentedControl)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout(for: .plain))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        demoContainer.addSubview(collectionView)
        self.collectionView = collectionView

        let cellRegistration = UICollectionView.CellRegistration<EnvironmentAwareCell, ListEnvironmentCellState> { cell, _, item in
            // Setting this stored property triggers `setNeedsUpdateConfiguration()`,
            // which calls `updateConfiguration(using:)` - the same method that
            // reads `listEnvironment` below, so both the item text and the
            // trait-driven styling are applied together.
            cell.itemText = item.text
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: demoContainer.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: demoContainer.layoutMarginsGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: demoContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: demoContainer.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: demoContainer.bottomAnchor)
        ])

        apply(style: .plain)
    }

    private func makeLayout(for style: Style) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout.list(using: style.layoutConfiguration)
    }

    private func apply(style: Style) {
        collectionView.setCollectionViewLayout(makeLayout(for: style), animated: true)

        var snapshot = NSDiffableDataSourceSnapshot<Int, ListEnvironmentCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems((1...6).map { ListEnvironmentCellState(text: "\(style.title) row \($0)") })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
