import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/noticias.dart';
import 'package:radio_poder_app/screens/login_page.dart';

import 'screens/login_page.dart';
import 'screens/navigation_bar_page.dart';
import 'screens/noticia_detalle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Noticias(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Radio Poder',
        home: const LoginPage(),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
        ),
        routes: {
          LoginPage.route: (context) => const LoginPage(),
          NavigationBarPage.route: (context) => const NavigationBarPage(),
          NoticiaDetalle.route: (context) => const NoticiaDetalle(),
        },
      ),
    );
  }
}
