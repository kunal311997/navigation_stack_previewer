# CHANGELOG

## 0.0.5
- **Navigator 2.0 Support**: Improved tracking for declarative routing stacks.
- **Deep Linking Support**: Added automatic detection and visualization of deep-linked routes.
- **Enhanced Visuals**: Added "Link" badge to deep-link items in the carousel.
- **Optimized UI**: Refined zoom-in animation with fixed header for smoother transitions.
- **Improved Performance**: Efficiently handles `didRemove` events in the Router API.
- **Better SEO**: Updated package metadata, topics, and documentation for pub.dev.
- **Consolidated Constants**: Optimized default values for spacing, sizing, and animations.

## 0.0.4
- Added In-Panel Enlarged Preview mode.
- Added support for dynamic panel height resizing via `enlargedPanelHeight`.
- Improved route label cleaning to show friendly page names (e.g., "/user_profile" -> "User Profile").
- Added diverse layout options: Carousel and List.
- Added support for multiple panel positions: Top and Bottom.
- Consolidated all settings into a unified `StackPreviewConfig` object for advanced customization.
- Improved memory management by cleaning up history when routes are removed.
- Enhanced null-safety and defensive coding.
- Added support for `animationDuration` and `animationCurve` for handling layout transitions.
- Added configurable maximum stack size via `maxRoutes` (default: 5).
- Added thumbnail resolution control via `pixelRatio`
- Added primary and background colors for styling.

## 0.0.3
- Simplified filtering logic by using `RouteSettings` instead of a global filter callback.
- Updated `pubspec.yaml` with valid `repository` and `issue_tracker` links for pub.dev.
- Updated dependencies to the latest versions.

## 0.0.2
- Improved pub.dev score by adding comprehensive Dartdoc comments.
- Added a full integration example in the `example/` directory.
- Refined the `NavigationStackObserver` API for easier use.
- Updated documentation with customization and filtering guides.
- Added colors and panel dimensions to match your app's theme. 

## 0.0.1
- Initial release.
- Added visual navigation stack preview via a swipe-down panel.
- Added screenshot capture for navigation history.
- Added automatic detection of `push`, `pushReplacement`, and `pop` via `NavigationStackObserver`.
- Added global wrapper `NavigationStackPreviewer` for easy integration.
- Added ability to jump to a previous screen by tapping its screenshot.
- Added ability to remove specific screens from the stack with a close icon.
- Added current screen labeling and highlighting.
