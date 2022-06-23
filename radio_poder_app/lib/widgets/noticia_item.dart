import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/noticia.dart';
import '../screens/noticia_detalle.dart';

class NoticiaItem extends StatelessWidget {
  final Noticia noticia;

  const NoticiaItem({
    Key? key,
    required this.noticia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(NoticiaDetalle.route, arguments: noticia.id);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              height: 80,
              width: 80,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Hero(
                  tag: noticia.id,
                  child: Image.network(
                    noticia.foto,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                          child: Icon(
                        Icons.image,
                        color: Colors.white,
                      ));
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticia.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          // DateFormat.yMMMEd().format(noticia.fecha),
                          DateFormat.yMd().format(noticia.fecha) +
                              " · " +
                              noticia.autor +
                              " · " +
                              noticia.tiempo.toString() +
                              " min",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
