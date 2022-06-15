import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/noticias.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Hero(
                    tag: "HeadphonesLogo",
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 120,
                    ),
                  ),
                ),
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Estás escuchando tu radio favorita!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.pinkAccent),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orangeAccent,
                  Colors.pinkAccent,
                ]),
                borderRadius: BorderRadius.all(Radius.circular(32))),
            child: const Text(
              'Recuerda revisar los sorteos más recientes!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
