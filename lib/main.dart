import 'package:flutter/material.dart';
import 'package:hw/core/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.initial,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
