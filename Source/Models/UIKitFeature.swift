//
//  UIKitFeature.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// Describes a single UIKit addition from WWDC24, plus how to build the
/// screen that demonstrates it. `FeatureCatalog` owns the concrete instances,
/// so this type stays a plain, storage-only model.
struct UIKitFeature {
    let title: String
    let subtitle: String
    let systemImageName: String
    let explanation: String
    let makeDemoViewController: () -> UIViewController
}
