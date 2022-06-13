import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/noticia.dart';
import '../providers/noticias.dart';
import '../widgets/noticiaItem.dart';

class NoticiasPage extends StatefulWidget {
  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  var _isInit = true;

  @override
  void initState() {
    // Aqui no funciona porque el provider no se ha inicializado aun (no se ha cargado el token)
    //y no se puede acceder a la lista de noticias porque no existe.
    // Provider.of<Noticias>(context).fetchAndSetNoticias();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Noticias>(context).fetchAndSetNoticias();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

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
