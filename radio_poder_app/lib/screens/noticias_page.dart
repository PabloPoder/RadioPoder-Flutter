import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/noticias.dart';
import '../widgets/noticia_item.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({Key? key}) : super(key: key);

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

  Future? _noticiasFuture;
  bool _ordenDeLista = false;

  _cambiarOrdenDeLista() {
    setState(() {
      _ordenDeLista = !_ordenDeLista;
    });
  }

  Future _obtenerNoticiasFuture() {
    return Provider.of<Noticias>(context, listen: false).fetchAndSetNoticias();
  }

  @override
  void initState() {
    _noticiasFuture = _obtenerNoticiasFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Usar Consumer para no entrar en bucle infinito (infinito de carga de noticias)
    //y no tener que hacer un initState
    // final noticiasData = Provider.of<Noticias>(context);
    // final noticias = noticiasData.items;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'N O T I C I A S',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: FutureBuilder(
          future: _noticiasFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '¡Ups! Ha ocurrido un error.',
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
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _obtenerNoticiasFuture,
                  child: Consumer<Noticias>(
                    builder: (ctx, noticias, _) => Column(children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Más antiguas:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Switch(
                                    activeColor: Colors.orangeAccent,
                                    value: _ordenDeLista,
                                    onChanged: (_) {
                                      setState(() {
                                        _cambiarOrdenDeLista();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: noticias.items.length,
                          itemBuilder: (ctx, i) => NoticiaItem(
                            noticia: _ordenDeLista == false
                                ? noticias.items[i]
                                : noticias.items.reversed.toList()[i],
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }
            }
          }),
    );
  }
}
