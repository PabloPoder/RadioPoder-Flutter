import 'package:flutter/material.dart';
import 'package:radio_poder_app/models/comentario.dart';
import '../models/noticia.dart';
import '../models/usuario.dart';

class Comentarios with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Comentario> _items = [
    Comentario(
      id: 1,
      texto: 'Exelente noticia, me gusto mucho. Muy bien escrito',
      fecha: DateTime(2020 - 01 - 02),
      usuarioId: 1,
      usuario: Usuario(
        id: 1,
        nombre: 'Juan',
        apellido: 'Perez',
        email: 'Juanperez@gmail.com',
        password: '12345',
      ),
      noticiaId: 1,
    ),
    Comentario(
      id: 2,
      texto: 'Cuando haran el nuevo podcast?',
      fecha: DateTime(2020 - 01 - 02),
      usuarioId: 1,
      usuario: Usuario(
        id: 1,
        nombre: 'Juan',
        apellido: 'Perez',
        email: 'Juanperez@gmail.com',
        password: '12345',
      ),
      noticiaId: 1,
    ),
    Comentario(
      id: 3,
      texto: 'Hay pero que triste noticia',
      fecha: DateTime(2020 - 01 - 02),
      usuarioId: 1,
      usuario: Usuario(
        id: 1,
        nombre: 'Juan',
        apellido: 'Perez',
        email: 'Juanperez@gmail.com',
        password: '12345',
      ),
      noticiaId: 1,
    )
  ];

  List<Comentario> get items {
    return [..._items];
  }

  List<Comentario> fetchById(int id) {
    return _items.where((comentario) => comentario.noticiaId == id).toList();
  }
}
