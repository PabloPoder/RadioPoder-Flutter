import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/auth.dart';
import 'package:radio_poder_app/providers/comentarios.dart';
import 'package:radio_poder_app/providers/noticias.dart';
import 'package:radio_poder_app/screens/login_page.dart';

import 'screens/login_page.dart';
import 'screens/navigation_bar_page.dart';
import 'screens/noticia_detalle.dart';

void main() {
  // Permitir uso de api no certificada?
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Noticias>(
          create: (_) => Noticias("", []),
          update: (_, auth, previousNoticias) => Noticias(auth.token!,
              previousNoticias == null ? [] : previousNoticias.items),
        ),
        ChangeNotifierProvider.value(
          value: Comentarios(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Radio Poder',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
          ),
          home: auth.isAuthenticated
              ? const NavigationBarPage()
              : const LoginPage(),
          routes: {
            LoginPage.route: (context) => const LoginPage(),
            NavigationBarPage.route: (context) => const NavigationBarPage(),
            NoticiaDetalle.route: (context) => const NoticiaDetalle(),
          },
        ),
      ),
    );
  }
}

// Permitir uso de api no certificada?
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
