import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sorteo.dart';
import '../utilities/constantes.dart';

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

  List<Sorteo> sorteosGanados(int id) {
    return _items.where((element) => element.ganadorId == id).toList();
  }

  Future<void> fetchAndSetSorteos() async {
    const url = apiUrl + "Sorteos/GetAll";

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
            foto: fotoUrlConst + sorteo["foto"],
            ganadorId: sorteo["ganadorId"]));
      }

      _items = sorteosCargados.reversed.toList();

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
