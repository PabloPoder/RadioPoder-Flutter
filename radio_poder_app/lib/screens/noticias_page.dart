import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/noticias.dart';
import '../widgets/noticia_item.dart';

class NoticiasPage extends StatefulWidget {
  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  // var _isInit = true;

  // @override
  // void initState() {
  //   // Aqui no funciona porque el provider no se ha inicializado aun (no se ha cargado el token)
  //   //y no se puede acceder a la lista de noticias porque no existe.
  //   // Provider.of<Noticias>(context).fetchAndSetNoticias();
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Noticias>(context).fetchAndSetNoticias();
  //     _isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // Usar Consumer para no entrar en bucle infinito (infinito de carga de noticias)
    //y no tener que hacer un initState
    // final noticiasData = Provider.of<Noticias>(context);
    // final noticias = noticiasData.items;

    return FutureBuilder(
        future:
            Provider.of<Noticias>(context, listen: false).fetchAndSetNoticias(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              var noticias =
                  Provider.of<Noticias>(context, listen: false).items;

              return noticias.isEmpty
                  ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Ups! Ha ocurrido un error.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Vuelve a intertarlo más tarde.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ]),
                    )
                  : RefreshIndicator(
                      //TODO: Revisar el consumo para ver si se puede usar.
                      //Si no, retornar solo el ListView.Builder
                      onRefresh: () =>
                          Provider.of<Noticias>(context, listen: false)
                              .fetchAndSetNoticias(),
                      child: Consumer<Noticias>(
                        builder: (ctx, noticias, _) => ListView.builder(
                          itemCount: noticias.items.length,
                          itemBuilder: (ctx, i) => NoticiaItem(
                            noticia: noticias.items[i],
                          ),
                        ),
                      ),
                    );
            } else {
              return RefreshIndicator(
                onRefresh: () => Provider.of<Noticias>(context, listen: false)
                    .fetchAndSetNoticias(),
                child: Consumer<Noticias>(
                  builder: (ctx, noticias, _) => ListView.builder(
                    itemCount: noticias.items.length,
                    itemBuilder: (ctx, i) => NoticiaItem(
                      noticia: noticias.items[i],
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
