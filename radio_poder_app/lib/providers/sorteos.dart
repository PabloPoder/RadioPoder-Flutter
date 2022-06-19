import 'package:flutter/foundation.dart';
import 'package:radio_poder_app/models/sorteo.dart';

class Sorteos with ChangeNotifier {
  String? _token;

  Sorteos(this._token);

  set token(String value) {
    _token = value;
  }

  List<Sorteo> _items = [
    Sorteo(
      id: 1,
      titulo: "Asado completo + Vinos",
      texto:
          "En el dia de hoy estaremos sorteando un asado completo + vinos de primera calidad. Si queres ganarlo, no te lo pierdas y participa hoy mismo.",
      fechaInicio: DateTime.parse("2022-06-19"),
      fechaFin: DateTime.parse("2022-07-01"),
      foto: "https://picsum.photos/id/1/200/300",
      estado: true,
    ),
    Sorteo(
      id: 2,
      titulo: "Sorteo 2",
      texto: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      fechaInicio: DateTime.parse("2020-01-10"),
      fechaFin: DateTime.parse("2020-01-20"),
      foto: "https://picsum.photos/id/1/200/300",
      estado: true,
    ),
  ];

  List<Sorteo> get items {
    return [..._items];
  }

  Sorteo fetchById(int id) {
    return _items.firstWhere((noticia) => noticia.id == id);
  }
}
