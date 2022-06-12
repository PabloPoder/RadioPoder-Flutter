import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/comentario.dart';
import '../providers/comentarios.dart';
import '../providers/noticias.dart';
import '../widgets/comentarioItem.dart';

class NoticiaDetalle extends StatelessWidget {
  static const route = "/noticia_detalle";

  const NoticiaDetalle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;

    final noticia = Provider.of<Noticias>(context, listen: false).fetchById(id);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'R A D I O   P O D E R',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      noticia.foto,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      noticia.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "por " +
                          noticia.autor +
                          " · " +
                          DateFormat.yMd().format(noticia.fecha) +
                          " · " +
                          noticia.tiempo.toString() +
                          " minutos de lectura",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      noticia.texto,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      noticia.autor +
                          "  ·  " +
                          DateFormat.yMd().format(noticia.fecha),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Deja un comentario",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Escribe tu comentario",
                        suffixIcon: Icon(Icons.send),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Comentarios",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  //Comentarios
                  Consumer<Comentarios>(
                    builder: (ctx, comentarios, _) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: comentarios.fetchById(id).length,
                      itemBuilder: (ctx, i) => ComentarioItem(
                        comentario: comentarios.fetchById(id)[i],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
