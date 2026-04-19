# Navigation Stack Previewer

[![pub package](https://img.shields.io/pub/v/navigation_stack_previewer.svg)](https://pub.dev/packages/navigation_stack_previewer)
[![likes](https://img.shields.io/pub/likes/navigation_stack_previewer)](https://pub.dev/packages/navigation_stack_previewer/score)
[![license](https://img.shields.io/github/license/kunal311997/navigation_stack_previewer)](https://github.com/kunal311997/navigation_stack_previewer/blob/master/LICENSE)

A powerful visual debugging and navigation tool for Flutter developers. **Navigation Stack Previewer** allows you to see a real-time visual history of your app's navigation stack with screenshots, enabling instant "time-travel" back to any previous screen.

## Why Navigation Stack Previewer?

Debugging complex navigation flows can be tedious. This package solves that by providing:
- **Visual Context**: Don't just guess which screen is where in the stack—see it.
- **Fast Testing**: Instantly jump back 5 screens without multiple back-button taps.
- **Improved UX Design**: Review your navigation flow visually during development.

---

## 🎬 Demo

<p align="center">
  <img width="300" alt="Navigation Stack Previewer Demo" src="https://raw.githubusercontent.com/kunal311997/navigation_stack_previewer/master/Screen_recording_20260419_103343.gif" />
</p>

---

## 📸 Screenshots

<p align="center">
  <img width="250" alt="Carousel Layout" src="https://raw.githubusercontent.com/kunal311997/navigation_stack_previewer/master/Screenshot_20260419_103316.png" />
  <img width="250" alt="Enlarged Preview" src="https://raw.githubusercontent.com/kunal311997/navigation_stack_previewer/master/Screenshot_20260419_103325.png" />
  <img width="250" alt="List Layout" src="https://raw.githubusercontent.com/kunal311997/navigation_stack_previewer/master/Screenshot_20260419_180223.png" />
</p>

---

## ✨ Features

- 🖼️ **Visual History**: High-quality screenshots of every route in your stack.
- 🚀 **Instant Navigation**: Tap any thumbnail to `popUntil` that specific route instantly.
- 📱 **Flexible Layouts**: Switch between a sleek **Carousel** or a detailed **List** view.
- ↕️ **Smart Positioning**: Pull from the **Top** or **Bottom** based on your app's UI.
- 🤖 **Auto-Tracking**: Automatically detects `push`, `replace`, and `pop` events via `NavigatorObserver`.
- 🔍 **Enlarged Mode**: Long-press or tap the zoom icon to inspect a screen in detail.
- 🛡️ **Navigator 2.0 / Router API Support**: Track stacks managed by the declarative Router API.
- 🔗 **Deep Linking Support**: Automatic detection and visualization of deep-linked routes.
- 🛠️ **Fully Customizable**: Control colors, animations, blur effects, and history depth.
- 🛡️ **Privacy Control**: Easily exclude sensitive screens (like login or payment) from history.

---

## 🚀 Getting Started

### 1. Add dependency
Add this to your `pubspec.yaml`:
```yaml
dependencies:
  navigation_stack_previewer: ^0.0.5
```

### 2. Initialize
Call `initNavHistory()` in your `main()` before `runApp()`:
```dart
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNavHistory();
  runApp(const MyApp());
}
```

### 3. Wrap your App
Integrate the `NavigationStackObserver` and wrap your app with `NavigationStackPreviewer`:

```dart
MaterialApp(
  navigatorObservers: [
    NavigationStackObserver(), // Required to track navigation
  ],
  builder: (context, child) {
    return NavigationStackPreviewer(
      config: const StackPreviewConfig(
        title: "App History",
        primaryColor: Colors.deepPurple,
        layout: StackPreviewLayout.carousel,
      ),
      child: child!,
    );
  },
  home: const HomePage(),
)
```

---

## ⚙️ Configuration Options

| Property | Default | Description |
|----------|---------|-------------|
| `layout` | `carousel` | Choose between `carousel` or `list`. |
| `position` | `top` | Slide panel from `top` or `bottom`. |
| `maxRoutes` | `10` | Maximum number of screenshots to store. |
| `primaryColor` | `#c03463` | Accent color for the UI components. |
| `backgroundColor` | `white` | Background color of the preview panel. |
| `animationDuration` | `300ms` | Speed of the slide animation. |
| `pixelRatio` | `0.5` | Resolution of screenshots (lower saves memory). |

---

## 🔒 Excluding Sensitive Screens

To prevent a screen from being captured in the history (e.g., for security or privacy), pass `preview: false` in `RouteSettings`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    settings: const RouteSettings(arguments: {'preview': false}),
    builder: (_) => const SensitiveDataPage(),
  ),
);
```

---

## 💡 Pro Tips
- **Memory Management**: Use a `pixelRatio` of `0.5` or lower for production debugging to keep memory usage low.
- **Blur Effect**: You can customize the background blur intensity in `StackPreviewConfig`.

---

## 🤝 Contributing
Issues and pull requests are welcome! Feel free to report bugs or suggest new features on the [GitHub repository](https://github.com/kunal311997/navigation_stack_previewer).

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/kunal311997/navigation_stack_previewer/blob/master/LICENSE) file for details.
