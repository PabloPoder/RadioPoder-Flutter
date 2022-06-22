import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sorteo.dart';

class Sorteos with ChangeNotifier {
  String? _token;

  Sorteos(this._token, this._items);

  set token(String value) {
    _token = value;
  }

  List<Sorteo> _items = [];

  List<Sorteo> get items {
    return [..._items];
  }

  Sorteo fetchById(int id) {
    return _items.firstWhere((sorteo) => sorteo.id == id);
  }

  Future<void> fetchAndSetSorteos() async {
    const url = 'https://192.168.1.106:45455/api/Sorteos/GetAll';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token!,
      });
      final extractedData = json.decode(response.body) as List<dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }

      final List<Sorteo> sorteosCargados = [];
      for (var sorteo in extractedData) {
        sorteosCargados.add(Sorteo(
            id: sorteo["id"],
            titulo: sorteo["titulo"],
            texto: sorteo["texto"],
            fechaInicio: DateTime.parse(sorteo["fechaInicio"]),
            fechaFin: DateTime.parse(sorteo["fechaFin"]),
            foto: "https://192.168.1.106:45455/" + sorteo["foto"],
            estado: sorteo["estado"],
            ganadorId: sorteo["ganadorId"]));
      }

      _items = sorteosCargados.reversed.toList();

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
