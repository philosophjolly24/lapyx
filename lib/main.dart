import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/home_view.dart';
import 'package:icarus/widgets/global_shortcuts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    title: "Icarus: Valorant Strategies & Line ups",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalShortcuts(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Icarus',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.teal,
            error: Colors.red,
            surface: Color(0xFF1B1B1B),
          ),
          dividerColor: Colors.transparent,
          useMaterial3: true,
          expansionTileTheme: const ExpansionTileThemeData(),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
