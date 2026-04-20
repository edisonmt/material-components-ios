// swift-tools-version:5.7
//
// Package.swift — MaterialComponents fork (SimpleSafety subset)
//
// Scope: the 5 subspecs SimpleSafety actually consumes
//   • Buttons
//   • Buttons+Theming
//   • TextFields
//   • TextFields+Theming
//   • Snackbar
//
// Layout assumption: upstream google/material-components-ios repo structure,
// i.e. components/<Name>/src/ for public headers + implementations, and
// components/<Name>/src/private/ for internal helpers. This file goes at the
// ROOT of your fork, next to the existing MaterialComponents.podspec.
//
// Angle-bracket imports: the SimpleSafety code uses
//   #import <MaterialComponents/MaterialButtons.h>
// To keep those working, every target's publicHeadersPath is set so that the
// umbrella header surfaces under `MaterialComponents/*`. We achieve that by
// pointing publicHeadersPath at `.` (the target's own `src/` directory) and
// letting each component's `Material<Foo>.h` umbrella be included from the
// `MaterialComponents` module namespace via `modulemap`-free export. If your
// code uses quoted imports (`#import "MaterialButtons.h"`) instead, the same
// setup works.
//
// STATUS: Starter skeleton, not a finished product.
//   - Source lists use directory paths (SPM globs .m/.mm/.c/.cpp automatically
//     beneath each target's `path`). You will hit duplicates if the same file
//     is reachable from two targets; fix with `exclude`.
//   - Internal/private headers are exposed via `cSettings.headerSearchPath`.
//   - Any missing transitive dep will surface as a C "file not found" error
//     at build time. Add the target + dependency and rebuild.
//   - MDFInternationalization and MDFTextAccessibility are declared as external
//     SPM deps; both repos publish Package.swift upstream.
//
// To iterate:
//   1. `swift package dump-package` to validate the manifest
//   2. Open this Package.swift in Xcode (File → Open…), let it resolve
//   3. `xcodebuild -scheme MaterialComponents_Buttons -destination 'generic/platform=iOS'`
//   4. Fix missing headers by adding search paths or new targets
//

import PackageDescription

let package = Package(
    name: "MaterialComponents",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "MaterialComponents_Buttons",           targets: ["MaterialComponents_Buttons"]),
        .library(name: "MaterialComponents_ButtonsTheming",    targets: ["MaterialComponents_ButtonsTheming"]),
        .library(name: "MaterialComponents_TextFields",        targets: ["MaterialComponents_TextFields"]),
        .library(name: "MaterialComponents_TextFieldsTheming", targets: ["MaterialComponents_TextFieldsTheming"]),
        .library(name: "MaterialComponents_Snackbar",          targets: ["MaterialComponents_Snackbar"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/material-foundation/material-internationalization-ios.git",
            from: "3.0.0"
        ),
        .package(
            url: "https://github.com/material-foundation/material-text-accessibility-ios.git",
            from: "2.0.0"
        )
    ],
    targets: [

        // ────────────────────────────────────────────────────────────────
        // MARK: private helpers (leaf-level, no MaterialComponents deps)
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponentsPrivate_Math",
            path: "components/private/Math/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponentsPrivate_Application",
            path: "components/private/Application/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponentsPrivate_UIMetrics",
            path: "components/private/UIMetrics/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_AnimationTiming",
            path: "components/AnimationTiming/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Availability",
            path: "components/Availability/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: low-level primitives (elevation, shadows, shapes, color, typography)
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponents_Color",
            path: "components/schemes/Color/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Typography",
            path: "components/Typography/src",
            dependencies: [
                "MaterialComponents_Availability",
                "MaterialComponentsPrivate_Application"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_TypographyScheme",
            path: "components/schemes/Typography/src",
            dependencies: [
                "MaterialComponents_Typography"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_ShadowElevations",
            path: "components/ShadowElevations/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_ShadowLayer",
            path: "components/ShadowLayer/src",
            dependencies: [
                "MaterialComponents_ShadowElevations"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Elevation",
            path: "components/Elevation/src",
            dependencies: [
                "MaterialComponents_Availability",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Shapes",
            path: "components/Shapes/src",
            dependencies: [
                "MaterialComponents_ShadowElevations",
                "MaterialComponents_ShadowLayer",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_ShapeScheme",
            path: "components/schemes/Shape/src",
            dependencies: [
                "MaterialComponents_Shapes"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_ShapeLibrary",
            path: "components/ShapeLibrary/src",
            dependencies: [
                "MaterialComponents_Shapes",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Palettes",
            path: "components/Palettes/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: ink & ripple
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponents_Ink",
            path: "components/Ink/src",
            dependencies: [
                "MaterialComponents_Availability",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Ripple",
            path: "components/Ripple/src",
            dependencies: [
                "MaterialComponents_AnimationTiming",
                "MaterialComponents_Availability",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: scheme umbrellas (color + typography schemes used by theming)
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponents_ContainerScheme",
            path: "components/schemes/Container/src",
            dependencies: [
                "MaterialComponents_Color",
                "MaterialComponents_TypographyScheme",
                "MaterialComponents_ShapeScheme"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: Buttons (+ Theming)
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponents_Buttons",
            path: "components/Buttons/src",
            dependencies: [
                "MaterialComponents_Elevation",
                "MaterialComponents_Ink",
                "MaterialComponents_Ripple",
                "MaterialComponents_ShadowElevations",
                "MaterialComponents_ShadowLayer",
                "MaterialComponents_Shapes",
                "MaterialComponents_Typography",
                "MaterialComponentsPrivate_Math"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_ButtonsTheming",
            path: "components/Buttons+Theming/src",
            dependencies: [
                "MaterialComponents_Buttons",
                "MaterialComponents_ContainerScheme",
                "MaterialComponents_ShadowElevations"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: TextFields (+ Theming)
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponents_TextFields",
            path: "components/TextFields/src",
            dependencies: [
                "MaterialComponents_AnimationTiming",
                "MaterialComponents_Elevation",
                "MaterialComponents_Palettes",
                "MaterialComponents_Typography",
                "MaterialComponentsPrivate_Math",
                .product(
                    name: "MDFInternationalization",
                    package: "material-internationalization-ios"
                )
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_TextFieldsTheming",
            path: "components/TextFields+Theming/src",
            dependencies: [
                "MaterialComponents_TextFields",
                "MaterialComponents_ContainerScheme",
                "MaterialComponents_Palettes",
                .product(
                    name: "MDFTextAccessibility",
                    package: "material-text-accessibility-ios"
                )
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        // ────────────────────────────────────────────────────────────────
        // MARK: Snackbar
        // ────────────────────────────────────────────────────────────────

        .target(
            name: "MaterialComponentsPrivate_Overlay",
            path: "components/private/Overlay/src",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponentsPrivate_OverlayWindow",
            path: "components/private/OverlayWindow/src",
            dependencies: [
                "MaterialComponentsPrivate_Overlay"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponentsPrivate_KeyboardWatcher",
            path: "components/private/KeyboardWatcher/src",
            dependencies: [
                "MaterialComponentsPrivate_Application"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),

        .target(
            name: "MaterialComponents_Snackbar",
            path: "components/Snackbar/src",
            dependencies: [
                "MaterialComponents_AnimationTiming",
                "MaterialComponents_Availability",
                "MaterialComponents_Buttons",
                "MaterialComponents_Elevation",
                "MaterialComponents_ShadowElevations",
                "MaterialComponents_ShadowLayer",
                "MaterialComponents_Typography",
                "MaterialComponentsPrivate_Application",
                "MaterialComponentsPrivate_KeyboardWatcher",
                "MaterialComponentsPrivate_Math",
                "MaterialComponentsPrivate_Overlay",
                "MaterialComponentsPrivate_OverlayWindow"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        )
    ]
)
