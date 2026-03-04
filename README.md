# Navigation Stack Previewer

A Flutter package that provides a visual preview of your app's navigation stack. Simply swipe from the screen edge to see screenshots of your previous screens and navigate back instantly.

# Screenshot 
<img width="300" height="700" alt="Screenshot_20260302_225023" src="https://raw.githubusercontent.com/kunal311997/navigation_stack_previewer/master/Screenshot_20260302_225023.png" />

# Video 
https://github.com/user-attachments/assets/33ed6b5d-d293-417c-a920-eeb8267d0092

## Features

- **Visual History**: See real screenshots of previous screens in your navigation stack.
- **Easy Navigation**: Tap on any screenshot or the "Preview" button to jump directly back to that screen.
- **Multiple Layouts**: Choose between **Carousel**, **Grid**, and **Deck** layouts.
- **Flexible Positioning**: Open the panel from the **Top** or **Bottom** of the screen.
- **Auto-Detection**: Automatically detects `push`, `pushReplacement`, and `pop` operations.
- **Global Integration**: Set it up once and it works across your entire app.
- **Customizable Appearance**: Change colors, titles, and animations via a unified config object.
- **Filtering**: Hide specific screens from the previewer using `RouteSettings`.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  navigation_stack_previewer: ^0.0.4
```

## Usage

### 1. Initialize the library

Call `initNavHistory()` in your `main()` function:

```dart
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNavHistory();
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
      navigatorObservers: [
        NavigationStackObserver(),
      ],
      builder: (context, child) {
        return NavigationStackPreviewer(
          config: const StackPreviewConfig(
            layout: StackPreviewLayout.carousel,
            position: StackPreviewPosition.top,
            animationDuration: Duration(milliseconds: 500),
            animationCurve: Curves.fastOutSlowIn,
            primaryColor: Colors.red,
            backgroundColor: Colors.white,
            maxRoutes: 15,
            pixelRatio: 0.5,
          ),
          child: child!,
        );
      },
      home: const MyHomePage(),
    );
  }
}
```

### 3. Swipe and Navigate!

- **Swipe** from the configured edge (Top or Bottom) to open the panel.
- **Tap** a screenshot to navigate back to it.
- **Tap the X** to remove a specific screen from the stack.

## Advanced Customization

### Hiding Screens

Exclude specific screens by passing `preview: false` in `RouteSettings`:

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const SecretPage(),
    settings: const RouteSettings(
      arguments: {'preview': false},
    ),
  ),
);
```

### Configuration Options (`StackPreviewConfig`)

| Parameter | Type | Default | Description                           |
|-----------|------|---------|---------------------------------------|
| `layout` | `StackPreviewLayout` | `carousel` | `carousel` or `list`.                 |
| `position` | `StackPreviewPosition` | `top` | `top` or `bottom`.                    |
| `primaryColor` | `Color` | `Color(0xFFc03463)` | Accent color for borders and buttons. |
| `backgroundColor` | `Color` | `Colors.white` | Panel background color.               |
| `maxRoutes` | `int` | `5` | Max screens to store in history.      |
| `pixelRatio` | `double` | `0.5` | Resolution of captured screenshots.   |
| `title` | `String` | `'Navigation Stack'` | Header text of the panel.             |

## Additional information

This package uses `RepaintBoundary` to capture screenshots efficiently. It is designed for development and debugging purposes.

Contributions are welcome on the GitHub repository!
