import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';
import '../utilities/constantes.dart';

class Noticias with ChangeNotifier {
  String? _token;

  Noticias(this._token, this._items);

  set token(String value) {
    _token = value;
  }

  List<Noticia> _items = [];

  Future<void> fetchAndSetNoticias() async {
    const url = apiUrl + "Noticias/GetAll";
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token!,
      });
      final extractedData = json.decode(response.body) as List<dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }

      final List<Noticia> noticiasCargadas = [];
      for (var noticia in extractedData) {
        noticiasCargadas.add(Noticia(
            id: noticia["id"],
            titulo: noticia["titulo"],
            texto: noticia["texto"],
            fecha: DateTime.parse(noticia["fecha"]),
            foto: fotoUrlConst + noticia["foto"],
            autor: noticia["autor"],
            tiempo: noticia["tiempo"]));
      }

      _items = noticiasCargadas.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<Noticia> get items {
    return [..._items];
  }

  Noticia fetchById(int id) {
    return _items.firstWhere((noticia) => noticia.id == id);
  }
}
