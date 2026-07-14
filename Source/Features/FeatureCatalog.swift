//
//  FeatureCatalog.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Single source of truth for every feature shown in the app. Each static
/// property captures the copy shown on the main list *and* the demo screen
/// header, plus the factory for that screen - so adding a new WWDC session
/// topic only means adding one entry here plus its view controller.
enum FeatureCatalog {

    static let zoomTransition = UIKitFeature(
        title: "Zoom Transition",
        subtitle: "Fluid, interruptible push/present transition",
        systemImageName: "arrow.up.left.and.arrow.down.right",
        explanation: "Set preferredTransition = .zoom { ... } on the pushed view controller and return the source thumbnail. The transition is reversible mid-flight via the interactive pop gesture.",
        makeDemoViewController: {
            ZoomTransitionDemoViewController(
                title: "Zoom Transition",
                explanation: "Set preferredTransition = .zoom { ... } on the pushed view controller and return the source thumbnail. The transition is reversible mid-flight via the interactive pop gesture."
            )
        }
    )

    static let swiftUIAnimationInterop = UIKitFeature(
        title: "SwiftUI Animations in UIKit",
        subtitle: "UIView.animate(_:changes:completion:) takes a SwiftUI Animation",
        systemImageName: "wand.and.stars",
        explanation: "UIView.animate now accepts a SwiftUI Animation value (springs, custom animations, ...) instead of just duration/curve. Pairs .interactiveSpring during a gesture with .spring on release for continuous velocity.",
        makeDemoViewController: {
            SwiftUIAnimationInteropDemoViewController(
                title: "SwiftUI Animations in UIKit",
                explanation: "UIView.animate now accepts a SwiftUI Animation value (springs, custom animations, ...) instead of just duration/curve. Pairs .interactiveSpring during a gesture with .spring on release for continuous velocity."
            )
        }
    )

    static let updateLink = UIKitFeature(
        title: "UIUpdateLink",
        subtitle: "Replaces CADisplayLink for view-driven animation loops",
        systemImageName: "waveform.path.ecg",
        explanation: "UIUpdateLink ties itself to a specific view, activating/deactivating with that view's window automatically, and reports timing via UIUpdateInfo instead of a separate frame timestamp.",
        makeDemoViewController: {
            UpdateLinkDemoViewController(
                title: "UIUpdateLink",
                explanation: "UIUpdateLink ties itself to a specific view, activating/deactivating with that view's window automatically, and reports timing via UIUpdateInfo instead of a separate frame timestamp."
            )
        }
    )

    static let symbolEffects = UIKitFeature(
        title: "New Symbol Effects",
        subtitle: "Wiggle, Rotate, Breathe + Magic Replace",
        systemImageName: "bell.badge.fill",
        explanation: "Three new indefinite SF Symbols animation presets - .wiggle, .rotate, .breathe - plus Magic Replace, which animates a symbol's badge/slash independently from its base shape.",
        makeDemoViewController: {
            SymbolEffectsDemoViewController(
                title: "New Symbol Effects",
                explanation: "Three new indefinite SF Symbols animation presets - .wiggle, .rotate, .breathe - plus Magic Replace, which animates a symbol's badge/slash independently from its base shape."
            )
        }
    )

    static let tabsAndSidebar = UIKitFeature(
        title: "UITab & UITabGroup",
        subtitle: "Declarative tab bar / sidebar hierarchy",
        systemImageName: "sidebar.left",
        explanation: "UITab and UITabGroup replace assigning viewControllers + tabBarItem directly. Setting mode = .tabSidebar and including a UITabGroup gives a combined tab bar/sidebar that adapts per platform.",
        makeDemoViewController: {
            TabsAndSidebarDemoViewController(
                title: "UITab & UITabGroup",
                explanation: "UITab and UITabGroup replace assigning viewControllers + tabBarItem directly. Setting mode = .tabSidebar and including a UITabGroup gives a combined tab bar/sidebar that adapts per platform."
            )
        }
    )

    static let automaticTraitTracking = UIKitFeature(
        title: "Automatic Trait Tracking",
        subtitle: "No more manual registerForTraitChanges for layout",
        systemImageName: "rectangle.on.rectangle.angled",
        explanation: "Reading a trait like horizontalSizeClass inside layoutSubviews() (and other supported update methods) is now enough - UIKit records the dependency and calls setNeedsLayout automatically when it changes.",
        makeDemoViewController: {
            AutomaticTraitTrackingDemoViewController(
                title: "Automatic Trait Tracking",
                explanation: "Reading a trait like horizontalSizeClass inside layoutSubviews() (and other supported update methods) is now enough - UIKit records the dependency and calls setNeedsLayout automatically when it changes."
            )
        }
    )

    static let listEnvironment = UIKitFeature(
        title: "List Environment Trait",
        subtitle: "Cells can style themselves for plain/grouped/sidebar",
        systemImageName: "list.bullet.rectangle",
        explanation: "Every view inside a UICollectionView/UITableView list now carries UITraitCollection.listEnvironment, so a cell can adapt its styling to the containing list's appearance without being told explicitly.",
        makeDemoViewController: {
            ListEnvironmentDemoViewController(
                title: "List Environment Trait",
                explanation: "Every view inside a UICollectionView/UITableView list now carries UITraitCollection.listEnvironment, so a cell can adapt its styling to the containing list's appearance without being told explicitly."
            )
        }
    )

    static let textFormatting = UIKitFeature(
        title: "Text Formatting Panel",
        subtitle: "Built-in rich text panel + highlight attributes",
        systemImageName: "textformat",
        explanation: "A UITextView with allowsEditingTextAttributes = true now gets a Format... Edit menu action for free. Highlighting is just two attributed-string keys: .textHighlightStyle and .textHighlightColorScheme.",
        makeDemoViewController: {
            TextFormattingDemoViewController(
                title: "Text Formatting Panel",
                explanation: "A UITextView with allowsEditingTextAttributes = true now gets a Format... Edit menu action for free. Highlighting is just two attributed-string keys: .textHighlightStyle and .textHighlightColorScheme."
            )
        }
    )

    static let canvasFeedback = UIKitFeature(
        title: "UICanvasFeedbackGenerator",
        subtitle: "Sensory feedback for drawing/canvas interactions",
        systemImageName: "hand.draw.fill",
        explanation: "A UIFeedbackGenerator subclass purpose-built for canvases: call alignmentOccurred(at:) with the touch location whenever a dragged object snaps to a guide, ideal alongside Apple Pencil Pro.",
        makeDemoViewController: {
            CanvasFeedbackDemoViewController(
                title: "UICanvasFeedbackGenerator",
                explanation: "A UIFeedbackGenerator subclass purpose-built for canvases: call alignmentOccurred(at:) with the touch location whenever a dragged object snaps to a guide, ideal alongside Apple Pencil Pro."
            )
        }
    )

    static let allFeatures: [UIKitFeature] = [
        zoomTransition,
        swiftUIAnimationInterop,
        updateLink,
        symbolEffects,
        tabsAndSidebar,
        automaticTraitTracking,
        listEnvironment,
        textFormatting,
        canvasFeedback
    ]
}
