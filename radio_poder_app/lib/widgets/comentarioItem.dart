import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/comentario.dart';
import '../providers/auth.dart';

class ComentarioItem extends StatelessWidget {
  final Comentario comentario;

  const ComentarioItem({
    Key? key,
    required this.comentario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, Auth auth, _) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            child: Text(
              comentario.usuario.nombre.substring(0, 1) +
                  comentario.usuario.apellido.substring(0, 1),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          dense: false,
          title: Text(
            comentario.usuario.nombre + ' ' + comentario.usuario.apellido,
          ),
          subtitle: Text(
            comentario.texto,
          ),
          trailing: auth.usuario?.id == comentario.usuarioId
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Provider.of<Comentarios>(context, listen: false)
                    //     .deleteComentario(comentario.id);
                  },
                )
              : Text(
                  DateFormat('dd/MM/yyyy').format(comentario.fecha),
                ),
        );
      },
    );
  }
}

// Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             comentario.usuario.nombre +
//                 " " +
//                 comentario.usuario.apellido.toString() +
//                 "  ·  " +
//                 DateFormat.yMd().format(comentario.fecha),
//             textAlign: TextAlign.start,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//           Text(
//             comentario.texto,
//             textAlign: TextAlign.start,
//             style: const TextStyle(
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );