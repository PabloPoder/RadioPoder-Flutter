import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: Colors.orangeAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
                "https://assets2.lottiefiles.com/packages/lf20_TCS2Gw.json",
                height: 250),
            const Text(
              "Bienvenido a Radio Poder",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 26,
              ),
            ),
            Text(
              "Disfruta de tu musica favorita en cualquier momento!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[850],
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
