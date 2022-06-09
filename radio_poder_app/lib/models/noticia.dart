import 'package:flutter/foundation.dart';

class Noticia with ChangeNotifier {
  final int id;
  final String titulo;
  final String texto;
  final DateTime fecha;
  final String foto;
  final String autor;
  final int tiempo;

  Noticia({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.fecha,
    required this.foto,
    required this.autor,
    required this.tiempo,
  });
}
