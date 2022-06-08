import 'package:flutter/material.dart';
import 'package:radio_poder_app/screens/draw_page.dart';
import 'package:radio_poder_app/screens/home_page.dart';
import 'package:radio_poder_app/screens/news_page.dart';
import 'package:radio_poder_app/screens/profile_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);
  static const route = "navigation_bar_page_route";

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    NewsPage(),
    DrawPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'R A D I O   P O D E R',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      // IndexedStack(index: _currentIndex, children: _screens),
      // To keep all the pages alive in the widget tree
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        iconSize: 30,
        elevation: 6,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attractions_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      floatingActionButton: _currentIndex != 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.pinkAccent,
              child: const Icon(Icons.play_arrow_rounded),
            )
          : null,
    );
  }
}
