import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/models/sorteo.dart';

import '../providers/participaciones.dart';
import '../providers/sorteos.dart';
import '../widgets/participacion_item.dart';

class ParticipacionesPage extends StatefulWidget {
  const ParticipacionesPage({Key? key}) : super(key: key);

  @override
  State<ParticipacionesPage> createState() => _ParticipacionesPageState();
}

class _ParticipacionesPageState extends State<ParticipacionesPage> {
  Future? _participacionesFuture;

  Future _obtenerParticipacionesFuture() {
    Provider.of<Sorteos>(context, listen: false).fetchAndSetSorteos();
    return Provider.of<Participaciones>(context, listen: false)
        .fetchAndSetParticipaciones();
  }

  @override
  void initState() {
    _participacionesFuture = _obtenerParticipacionesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final participacionesData = Provider.of<Participaciones>(context);
    final participaciones = participacionesData.items;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            'M I S   P A R T I C I P A C I O N E S',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
        ),
        body: FutureBuilder(
          future: _participacionesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(
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
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _obtenerParticipacionesFuture,
                  child: Consumer<Participaciones>(
                      builder: (context, participacionesData, _) {
                    return participaciones.length <= 0
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'No tienes participaciones.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Visita los sorteos y participa!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ]),
                          )
                        : ListView.builder(
                            itemCount: participaciones.length,
                            itemBuilder: (ctx, i) => ParticipacionItem(
                              participacion: participaciones[i],
                            ),
                          );
                  }),
                );
              }
            }
          },
        ));
  }
}
