// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import '../models/comentario.dart';
import '../providers/auth.dart';
import '../providers/comentarios.dart';

class ComentarioItem extends StatelessWidget {
  final Comentario comentario;

  const ComentarioItem({
    Key? key,
    required this.comentario,
  }) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('¿Borrar comentario?'),
              content: const Text(
                  'Esto no se puede deshacer y se eliminará de esta publicacion.'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Provider.of<Comentarios>(context, listen: false)
                        .deleteComentario(comentario.id);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, Auth auth, _) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors
                .primaries[comentario.usuarioId % Colors.primaries.length],
            child: Text(
              comentario.usuario.nombre.substring(0, 1) +
                  comentario.usuario.apellido.substring(0, 1),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          dense: false,
          title: Row(
            children: [
              Text(
                comentario.usuario.nombre + ' ' + comentario.usuario.apellido,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " · " + timeago.format(comentario.fecha, locale: 'en_short'),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          subtitle: Text(
            comentario.texto,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          trailing: auth.usuario?.id == comentario.usuarioId
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.red,
                  ),
                  onPressed: () => _showDeleteDialog(context),
                )
              : null,
        );
      },
    );
  }
}
