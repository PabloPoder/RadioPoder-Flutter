import 'package:radio_poder_app/models/sorteo.dart';

class Participacion {
  final int id;
  final DateTime fecha;
  final int usuarioId;
  final int sorteoId;
  final Sorteo sorteo;

  Participacion({
    required this.id,
    required this.fecha,
    required this.usuarioId,
    required this.sorteoId,
    required this.sorteo,
  });
}
