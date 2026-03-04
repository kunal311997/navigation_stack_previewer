import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the navigation stack previewer dependencies
  await initNavHistory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Stack Previewer Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 1. Add the NavigationStackObserver to track routes
      navigatorObservers: [
        NavigationStackObserver(),
      ],
      // 2. Wrap the app with NavigationStackPreviewer to enable the swipe gesture
      builder: (context, child) {
        return NavigationStackPreviewer(
          panelHeight: 400,
          config: const StackPreviewConfig(
            layout: StackPreviewLayout.carousel,
            position: StackPreviewPosition.top,
            primaryColor: Colors.deepPurple,
            backgroundColor: Colors.white,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 500),
            maxRoutes: 10,
            pixelRatio: 0.5,
            title: 'App Navigation Stack',
          ),
          child: child!,
        );
      },
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Swipe up from the bottom edge to see history'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SecondPage(),
                    settings: const RouteSettings(name: '/second_page'),
                  ),
                );
              },
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the second page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ThirdPage(),
                    settings: const RouteSettings(name: '/third_page'),
                  ),
                );
              },
              child: const Text('Replace with Third Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SecretPage(),
                    settings: const RouteSettings(
                      name: '/secret_page',
                      arguments: {'preview': false},
                    ),
                  ),
                );
              },
              child: const Text('Go to Secret Page (Not in history)'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Page')),
      body: const Center(
        child: Text('Third Page - Swipe up to see history panel'),
      ),
    );
  }
}

class SecretPage extends StatelessWidget {
  const SecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secret Page')),
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'This page is not tracked in history',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
