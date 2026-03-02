# CHANGELOG

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
