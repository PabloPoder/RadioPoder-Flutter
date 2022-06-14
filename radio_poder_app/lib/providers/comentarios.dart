import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:radio_poder_app/models/comentario.dart';
import '../models/noticia.dart';
import '../models/usuario.dart';

import 'package:http/http.dart' as http;

class Comentarios with ChangeNotifier {
  String _token;

  Comentarios(this._token, this._items);

  set token(String value) {
    _token = value;
  }

  List<Comentario> _items = [];

  List<Comentario> get items {
    return [..._items];
  }

  List<Comentario> fetchById(int id) {
    return _items.where((comentario) => comentario.id == id).toList();
  }

  Future<void> fetchAndSetComentarios(int id) async {
    final url = "https://192.168.1.106:45455/api/Comentarios/$id";
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token,
      });

      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Comentario> comentariosCargados = [];
      extractedData.forEach((comentario) {
        comentariosCargados.add(Comentario(
          id: comentario["id"],
          texto: comentario["texto"],
          fecha: DateTime.parse(comentario["fecha"]),
          usuarioId: comentario["usuarioId"],
          usuario: Usuario(
            id: comentario["usuario"]["id"],
            nombre: comentario["usuario"]["nombre"],
            apellido: comentario["usuario"]["apellido"],
            email: comentario["usuario"]["email"],
            password: comentario["usuario"]["password"],
          ),
          noticiaId: comentario["noticiaId"],
        ));
      });

      _items = comentariosCargados;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addComentario(String texto, int noticiaId) async {
    const url = "https://192.168.1.106:45455/api/Comentarios/";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer " + _token,
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: json.encode({
            "texto": texto,
            "noticiaId": noticiaId,
          }));

      _items.add(Comentario(
        id: json.decode(response.body)["id"],
        texto: texto,
        fecha: DateTime.parse(json.decode(response.body)["fecha"]),
        usuarioId: json.decode(response.body)["usuarioId"],
        noticiaId: noticiaId,
        usuario: Usuario(
          id: json.decode(response.body)["usuario"]["id"],
          nombre: json.decode(response.body)["usuario"]["nombre"],
          apellido: json.decode(response.body)["usuario"]["apellido"],
          email: json.decode(response.body)["usuario"]["email"],
          password: json.decode(response.body)["usuario"]["password"],
        ),
      ));
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
