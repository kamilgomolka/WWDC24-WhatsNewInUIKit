# WWDC24 – What's New in UIKit

## Summary

A small iOS demo app collecting the UIKit-related additions announced at **WWDC24**, each isolated in its own screen so it can be tapped, played with, and read about individually.

The root screen lists every feature; tapping one pushes a dedicated demo view controller with a short explanation and a live, interactive example.

Inspired by the session [*What's new in UIKit*](https://developer.apple.com/videos/play/wwdc2024/10118/) (WWDC24, session 10118).

## Features

| Feature | Summary |
| --- | --- |
| **Zoom Transition** | Fluid, interruptible push/present transition via `preferredTransition = .zoom { ... }`, reversible mid-flight with the interactive pop gesture. |
| **SwiftUI Animations in UIKit** | `UIView.animate(_:changes:completion:)` now accepts a SwiftUI `Animation` value (springs, custom curves) instead of just duration/curve. |
| **UIUpdateLink** | Replaces `CADisplayLink` for view-driven animation loops; ties itself to a specific view and reports timing via `UIUpdateInfo`. |
| **New Symbol Effects** | Three new indefinite SF Symbols animation presets — `.wiggle`, `.rotate`, `.breathe` — plus Magic Replace for badge/slash animations. |
| **UITab & UITabGroup** | Declarative replacement for assigning `viewControllers` + `tabBarItem` directly; `mode = .tabSidebar` gives an adaptive tab bar/sidebar. |
| **Automatic Trait Tracking** | Reading a trait like `horizontalSizeClass` inside `layoutSubviews()` is now enough — UIKit tracks the dependency and relayouts automatically. |
| **List Environment Trait** | Cells can read `UITraitCollection.listEnvironment` to style themselves for plain/grouped/sidebar lists without being told explicitly. |
| **Text Formatting Panel** | A `UITextView` with `allowsEditingTextAttributes = true` gets a built-in "Format…" Edit menu action, plus `.textHighlightStyle` / `.textHighlightColorScheme` attributes. |
| **UICanvasFeedbackGenerator** | A `UIFeedbackGenerator` subclass for canvas/drawing interactions — call `alignmentOccurred(at:)` when a dragged object snaps to a guide. |

## Screenshots / Recordings

<img width="600" alt="Simulator Screenshot - iPhone 17 (26 5) - 2026-07-15 at 16 16 27" src="https://github.com/user-attachments/assets/1589a920-6fe1-4671-892a-70a27266c92e" />

https://github.com/user-attachments/assets/2607d5ef-bf5c-4f64-a48f-16af4bf0024b

https://github.com/user-attachments/assets/a7d5be58-d7d8-4eba-8b89-33db27550f4b

(Sorry, that's all I uploaded, no videos for other menu items; Please download & run the project if you're interested)

## Requirements

- Xcode 26 or later
- iOS 26 SDK (`IPHONEOS_DEPLOYMENT_TARGET = 26.0`)
- Swift 5

## Getting Started

```bash
git clone https://github.com/kamilgomolka/WWDC24-WhatsNewInUIKit.git
cd WWDC24-WhatsNewInUIKit
open WWDC24-WhatsNewInUIKit.xcodeproj
```

Build and run the `WWDC24-WhatsNewInUIKit` scheme on an iOS 26+ simulator or device.

## Project Structure

```
Source/
├── AppDelegate.swift
├── SceneDelegate.swift
├── MainViewController.swift        # Root list of features
├── Models/
│   └── UIKitFeature.swift          # Storage-only model for a catalog entry
├── Common/
│   ├── FeatureDemoViewController.swift
│   └── UIButton+Demo.swift
└── Features/
    ├── FeatureCatalog.swift        # Single source of truth for all entries
    ├── ZoomTransition/
    ├── SwiftUIAnimation/
    ├── UpdateLink/
    ├── SymbolEffects/
    ├── TabsAndSidebar/
    ├── AutomaticTraitTracking/
    ├── ListEnvironment/
    ├── TextFormatting/
    └── CanvasFeedback/
```

Adding a new WWDC session topic means adding one `UIKitFeature` entry in `FeatureCatalog.swift` plus its demo view controller — the root list and navigation wiring pick it up automatically.

## Architecture

Plain UIKit, no third-party dependencies, no storyboards (aside from the launch screen) — view controllers are built in code and pushed on a single `UINavigationController` set up in `SceneDelegate`. `FeatureCatalog` acts as a static registry decoupling the root list from the individual demo screens.

## License

MIT — see [LICENSE](LICENSE).
