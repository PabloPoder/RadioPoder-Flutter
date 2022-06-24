import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      color: Colors.pinkAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
                "https://assets6.lottiefiles.com/packages/lf20_yetxuujw.json",
                height: 250),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Mantenete informado sobre todo lo que esta pasando ahora!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
