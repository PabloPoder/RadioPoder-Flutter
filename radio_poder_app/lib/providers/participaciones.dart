import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:radio_poder_app/models/sorteo.dart';
import '../models/participacion.dart';
import 'package:http/http.dart' as http;

import '../utilities/constantes.dart';

class Participaciones with ChangeNotifier {
  String? _token;

  Participaciones(this._token, this._items);

  set token(String value) {
    _token = value;
  }

  List<Participacion> _items = [];

  List<Participacion> get items {
    return [..._items];
  }

  Participacion findById(int id) {
    return _items.firstWhere((item) => item.id == id);
  }

  bool fetchBySorteoId(int id) {
    try {
      _items.firstWhere((item) => item.sorteoId == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addParticipacion(int id) async {
    const url = apiUrl + 'Participaciones/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer " + _token!,
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: json.encode({
          "sorteoId": id,
        }),
      );

      if (response.statusCode == 400) {
        throw "Se produjo un error al intentar participar";
      }

      _items.add(Participacion(
        id: json.decode(response.body)["id"],
        fecha: DateTime.parse(json.decode(response.body)["fecha"]),
        usuarioId: json.decode(response.body)["usuarioId"],
        sorteoId: json.decode(response.body)["sorteoId"],
        sorteo: Sorteo(
          id: json.decode(response.body)["sorteo"]["id"],
          titulo: json.decode(response.body)["sorteo"]["titulo"],
          texto: json.decode(response.body)["sorteo"]["texto"],
          fechaInicio: DateTime.parse(
              json.decode(response.body)["sorteo"]["fechaInicio"]),
          fechaFin:
              DateTime.parse(json.decode(response.body)["sorteo"]["fechaFin"]),
          foto: fotoUrlConst + json.decode(response.body)["sorteo"]["foto"],
        ),
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetParticipaciones() async {
    const url = apiUrl + 'Participaciones/GetAll/';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token!,
      });
      final extractedData = json.decode(response.body) as List<dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }

      final List<Participacion> participacionesCargadas = [];
      for (var participacion in extractedData) {
        participacionesCargadas.add(Participacion(
            id: participacion["id"],
            sorteoId: participacion["sorteoId"],
            usuarioId: participacion["usuarioId"],
            fecha: DateTime.parse(participacion["fecha"]),
            sorteo: Sorteo(
              id: participacion["sorteo"]["id"],
              titulo: participacion["sorteo"]["titulo"],
              texto: participacion["sorteo"]["texto"],
              fechaInicio:
                  DateTime.parse(participacion["sorteo"]["fechaInicio"]),
              fechaFin: DateTime.parse(participacion["sorteo"]["fechaFin"]),
              foto: fotoUrlConst + participacion["sorteo"]["foto"],
              ganadorId: participacion["sorteo"]["ganadorId"],
            )));
      }
      _items = participacionesCargadas;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
