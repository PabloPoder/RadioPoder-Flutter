import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/auth.dart';
import 'package:radio_poder_app/providers/comentarios.dart';
import 'package:radio_poder_app/providers/noticias.dart';
import 'package:radio_poder_app/providers/participaciones.dart';
import 'package:radio_poder_app/screens/editar_perfil_page.dart';
import 'package:radio_poder_app/screens/sorteo_detalle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/sorteos.dart';
import 'screens/intruduccion_page.dart';
import 'screens/login_page.dart';
import 'screens/splash_screen.dart';
import 'screens/navigation_bar_page.dart';
import 'screens/noticia_detalle.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Permitir uso de api no certificada?
  HttpOverrides.global = MyHttpOverrides();

  // Inicializar preferencias para mostrar introduccion
  final prefs = await SharedPreferences.getInstance();
  final showIntro = prefs.getBool('showIntro') ?? false;

  runApp(MyApp(showIntro: showIntro));
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  const MyApp({Key? key, required this.showIntro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Noticias>(
          create: (_) => Noticias("", []),
          update: (_, auth, previousNoticias) => Noticias(auth.token,
              previousNoticias == null ? [] : previousNoticias.items),
        ),
        ChangeNotifierProxyProvider<Auth, Comentarios>(
          create: (_) => Comentarios("", []),
          update: (_, auth, previousComentarios) => Comentarios(auth.token,
              previousComentarios == null ? [] : previousComentarios.items),
        ),
        ChangeNotifierProxyProvider<Auth, Sorteos>(
          create: (_) => Sorteos("", []),
          update: (_, auth, previousSorteos) => Sorteos(
              auth.token, previousSorteos == null ? [] : previousSorteos.items),
        ),
        ChangeNotifierProxyProvider<Auth, Participaciones>(
          create: (_) => Participaciones("", []),
          update: (_, auth, previousParticipaciones) => Participaciones(
              auth.token,
              previousParticipaciones == null
                  ? []
                  : previousParticipaciones.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Radio Poder',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
          ),
          initialRoute: showIntro ? null : IntruduccionPage.route,
          home: auth.isAuthenticated
              ? const NavigationBarPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const LoginPage(),
                ),
          routes: {
            IntruduccionPage.route: (ctx) => const IntruduccionPage(),
            LoginPage.route: (context) => const LoginPage(),
            NavigationBarPage.route: (context) => const NavigationBarPage(),
            NoticiaDetalle.route: (context) => const NoticiaDetalle(),
            SorteoDetalle.route: (context) => const SorteoDetalle(),
            EditarPerfilPage.route: (context) => const EditarPerfilPage(),
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
