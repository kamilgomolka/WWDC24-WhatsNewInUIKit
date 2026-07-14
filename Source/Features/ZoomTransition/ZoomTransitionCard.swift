//
//  ZoomTransitionCard.swift
//  WWDC24-WhatsNewInUIKit
//

import UIKit

/// A stable, identifiable model for the zoom transition demo. The zoom
/// transition's `sourceViewProvider` closure runs again on dismissal, so it
/// must look up a thumbnail view by a stable identifier rather than close
/// over the view directly (the view instance can change or scroll offscreen
/// in the meantime).
struct ZoomTransitionCard {
    let id: String
    let title: String
    let color: UIColor
    let systemImageName: String
}

extension ZoomTransitionCard {
    static let all: [ZoomTransitionCard] = [
        ZoomTransitionCard(id: "sunrise", title: "Sunrise", color: .systemOrange, systemImageName: "sunrise.fill"),
        ZoomTransitionCard(id: "forest", title: "Forest", color: .systemGreen, systemImageName: "tree.fill"),
        ZoomTransitionCard(id: "ocean", title: "Ocean", color: .systemBlue, systemImageName: "water.waves"),
        ZoomTransitionCard(id: "dusk", title: "Dusk", color: .systemPurple, systemImageName: "moon.stars.fill")
    ]
}
