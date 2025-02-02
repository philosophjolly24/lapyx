import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarus/home_view.dart';
// import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
  //   setWindowTitle('Admin Dashboard');
  //   setWindowMinSize(const Size(1300, 800));
  //   setWindowMaxSize(Size.infinite);
  // }
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.teal,
            error: Colors.red,
            surface: Colors.grey[900]!,
          ),
          dividerColor: Colors.transparent,
          useMaterial3: true,
          expansionTileTheme: const ExpansionTileThemeData()),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
