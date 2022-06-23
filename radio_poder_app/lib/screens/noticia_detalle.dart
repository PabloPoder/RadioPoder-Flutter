import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/comentarios.dart';
import '../providers/noticias.dart';
import '../widgets/comentario_item.dart';

class NoticiaDetalle extends StatefulWidget {
  static const route = "/noticia_detalle";

  const NoticiaDetalle({Key? key}) : super(key: key);

  @override
  State<NoticiaDetalle> createState() => _NoticiaDetalleState();
}

class _NoticiaDetalleState extends State<NoticiaDetalle> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;

    final noticia = Provider.of<Noticias>(context, listen: false).fetchById(id);
    // Provider.of<Comentarios>(context, listen: false).fetchAndSetComentarios(id);

    TextEditingController _controller = TextEditingController();

    Future<void> _submit() async {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_controller.text.isNotEmpty || _controller.text.length >= 5) {
        try {
          await Provider.of<Comentarios>(context, listen: false)
              .addComentario(_controller.text, noticia.id);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Error al enviar comentario')),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
        _controller.clear();
      }
    }

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
            child: RefreshIndicator(
              onRefresh: () => Provider.of<Comentarios>(context, listen: false)
                  .fetchAndSetComentarios(id),
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escribí tu comentario",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _submit,
                          ),
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
                    FutureBuilder(
                      future: Provider.of<Comentarios>(context, listen: false)
                          .fetchAndSetComentarios(id),
                      builder: (ctx, dataSnapshot) {
                        if (dataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (dataSnapshot.error != null) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Error al cargar los comentarios"),
                            ),
                          );
                        } else {
                          return Consumer<Comentarios>(
                            builder: (ctx, comentarios, _) =>
                                comentarios.items.isNotEmpty
                                    ? ListView.builder(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: comentarios.items.length,
                                        itemBuilder: (ctx, i) => ComentarioItem(
                                          comentario: comentarios.items[i],
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          "Aún no hay comentarios",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                          );
                        }
                      },
                    )
                    //Comentarios
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
