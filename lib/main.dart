import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/Resource/Auth/LoginPage.dart';
import 'screens/Resource/Auth/OneTimePasswordPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAUS Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginPage(),
    );
  }
}
