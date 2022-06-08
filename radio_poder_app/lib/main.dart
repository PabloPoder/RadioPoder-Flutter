import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_poder_app/screens/login_page.dart';

import 'screens/navigation_bar_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const LoginPage(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
      ),
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        NavigationBarPage.route: (context) => const NavigationBarPage(),
      },
    );
  }
}
