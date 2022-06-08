import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/noticia.dart';
import '../providers/noticias.dart';
import '../widgets/noticiaItem.dart';

class NoticiasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noticiasData = Provider.of<Noticias>(context);
    final noticias = noticiasData.items;
    return ListView.builder(
      itemCount: noticias.length,
      itemBuilder: (ctx, i) => NoticiaItem(
        noticia: noticias[i],
      ),
    );
  }
}
