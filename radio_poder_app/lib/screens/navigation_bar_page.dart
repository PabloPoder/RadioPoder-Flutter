// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/auth.dart';
import 'package:radio_poder_app/screens/draw_page.dart';
import 'package:radio_poder_app/screens/home_page.dart';
import 'package:radio_poder_app/screens/noticias_page.dart';
import 'package:radio_poder_app/screens/perfil_page.dart';

import 'login_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);
  static const route = "navigation_bar_page";

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  var _isInit = true;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    NoticiasPage(),
    const DrawPage(),
    // const PerfilPage(),
  ];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de cerrar sesión?"),
        actions: <Widget>[
          FlatButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'R A D I O   P O D E R',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _showDialog,
          ),
        ],
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
