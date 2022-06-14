import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/comentario.dart';

class ComentarioItem extends StatelessWidget {
  final Comentario comentario;

  const ComentarioItem({
    Key? key,
    required this.comentario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comentario.usuario.nombre +
                " " +
                comentario.usuario.apellido.toString() +
                "  ·  " +
                DateFormat.yMd().format(comentario.fecha),
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            comentario.texto,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
