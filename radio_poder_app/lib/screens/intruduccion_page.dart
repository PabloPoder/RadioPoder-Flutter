import 'package:flutter/material.dart';
import 'package:radio_poder_app/screens/intro_pages/intro_page_1.dart';
import 'package:radio_poder_app/screens/intro_pages/intro_page_2.dart';
import 'package:radio_poder_app/screens/intro_pages/intro_page_3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntruduccionPage extends StatefulWidget {
  static const route = '/introduccion_page';
  const IntruduccionPage({Key? key}) : super(key: key);

  @override
  State<IntruduccionPage> createState() => _IntruduccionPageState();
}

class _IntruduccionPageState extends State<IntruduccionPage> {
  final PageController _pageController = PageController();

  bool _ultimaPagina = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                _ultimaPagina = (index == 2);
              });
            },
            controller: _pageController,
            children: const [IntroPage1(), IntroPage2(), IntroPage3()],
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    "Saltar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[850]),
                  ),
                ),
                SmoothPageIndicator(controller: _pageController, count: 3),
                _ultimaPagina
                    ? GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showIntro', true);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        },
                        child: Text(
                          "Finalizar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850]),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "Sig. >",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850]),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
