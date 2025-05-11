import 'package:flutter/material.dart';
import 'package:bread_place/config/routing/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BreadPlace',
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
