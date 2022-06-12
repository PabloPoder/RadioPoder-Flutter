import 'package:radio_poder_app/models/usuario.dart';

class Comentario {
  final int id;
  final String texto;
  final DateTime fecha;
  final int usuarioId;
  final Usuario usuario;
  final int noticiaId;

  Comentario({
    required this.id,
    required this.texto,
    required this.usuario,
    required this.usuarioId,
    required this.fecha,
    required this.noticiaId,
  });
}
