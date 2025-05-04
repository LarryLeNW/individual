import 'package:larryle/data/repository/song.repository.dart';
import 'package:flutter/material.dart';
import 'ui/navigation/app_navigation.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Larry Le',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
    );
  }
}
