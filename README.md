# Navigation Stack Previewer

A Flutter package that provides a visual preview of your app's navigation stack. Simply swipe down from the top edge to see screenshots of your previous screens and navigate back instantly.

## Features

- **Visual History**: See real screenshots of previous screens in your navigation stack.
- **Easy Navigation**: Tap on any screenshot to jump directly back to that screen.
- **Auto-Detection**: Automatically detects `push`, `pushReplacement`, and `pop` operations.
- **Global Integration**: Set it up once and it works across your entire app.
- **Customizable**: Control swipe sensitivity, panel height, and animation durations.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  navigation_stack_previewer: ^0.0.1
```

## Usage

### 1. Initialize the library

Call `init()` in your `main()` function:

```dart
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependencies
  runApp(const MyApp());
}
```

### 2. Configure MaterialApp

Add the `NavigationStackObserver` and wrap your app with `NavigationStackPreviewer`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add the observer
      navigatorObservers: [
        NavigationStackObserver(),
      ],
      // Wrap the navigator
      builder: (context, child) {
        return NavigationStackPreviewer(child: child!);
      },
      home: const MyHomePage(),
    );
  }
}
```

### 3. Swipe and Navigate!

- **Swipe down** from the top edge of your screen to open the preview panel.
- **Tap** a previous screen's screenshot to navigate back to it.
- **Tap the X** on a screenshot to remove that specific screen from the stack.
- **Tap the current screen** or swipe up to close the panel.

## Additional information

This package uses `RepaintBoundary` and `toImage()` to capture screenshots efficiently. It is designed for development and debugging purposes to help visualize complex navigation flows.

Contributions and issue reports are welcome on the GitHub repository!
