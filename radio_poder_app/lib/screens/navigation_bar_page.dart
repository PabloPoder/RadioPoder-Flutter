// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// Pages
import 'package:radio_poder_app/screens/sorteos_page.dart';
import 'package:radio_poder_app/screens/home_page.dart';
import 'package:radio_poder_app/screens/noticias_page.dart';
import 'package:radio_poder_app/screens/perfil_page.dart';
import 'package:radio_poder_app/screens/participaciones_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);
  static const route = "/navigation_bar_page";

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Bottom Navigation Bar
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const NoticiasPage(),
    const SorteosPage(),
    const ParticipacionesPage(),
    const PerfilPage(),
  ];

  // Reproductor de audio
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    // Controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    setAudio();

    // Escuchar eventos del reproductor de audio
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    super.initState();
  }

  Future<void> setAudio() async {
    // Loop
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    // Cargar audio
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load('deadmans-wonderland.wav');
    await audioPlayer.setUrl(url.path, isLocal: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

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
            icon: Icon(Icons.local_activity),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _controller,
          color: Colors.white,
        ),
        onPressed: () async {
          if (isPlaying) {
            _controller.reverse();
            audioPlayer.pause();
          } else {
            _controller.forward();
            await audioPlayer.resume();
          }
        },
      ),
    );
  }
}
