import 'package:flutter/material.dart';
import 'screens/Resource/Auth/LoginPage.dart';
import 'screens/Resource/Auth/OneTimePasswordPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAUS Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginPage(),
    );
  }
}
