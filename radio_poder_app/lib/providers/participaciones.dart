import 'package:flutter/material.dart';
import 'package:radio_poder_app/models/sorteo.dart';

import '../models/participacion.dart';

class Participaciones with ChangeNotifier {
  String? _token;

  Participaciones(this._token);

  set token(String value) {
    _token = value;
  }

  List<Participacion> _items = [
    Participacion(
      id: 1,
      fecha: DateTime.parse("2022-06-21"),
      usuarioId: 1,
      sorteoId: 1,
      sorteo: Sorteo(
        id: 1,
        titulo: "Asado completo + Vinos",
        texto:
            "En el dia de hoy estaremos sorteando un asado completo + vinos de primera calidad. Si queres ganarlo, no te lo pierdas y participa hoy mismo.",
        fechaInicio: DateTime.parse("2022-06-19"),
        fechaFin: DateTime.parse("2022-07-01"),
        foto: "https://picsum.photos/id/1/200/300",
        estado: true,
      ),
    ),
  ];

  List<Participacion> get items {
    return [..._items];
  }
}
