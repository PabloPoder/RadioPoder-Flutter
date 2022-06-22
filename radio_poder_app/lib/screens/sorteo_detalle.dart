import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/models/participacion.dart';

import '../providers/participaciones.dart';
import '../providers/sorteos.dart';

class SorteoDetalle extends StatefulWidget {
  static const route = "/sorteo_detalle";

  const SorteoDetalle({Key? key}) : super(key: key);

  @override
  State<SorteoDetalle> createState() => _SorteoDetalleState();
}

class _SorteoDetalleState extends State<SorteoDetalle> {
  Future? _participacionFuture;

  Future _obtenerParticipacionFuture() {
    return Provider.of<Participaciones>(context, listen: false)
        .fetchAndSetParticipaciones();
  }

  @override
  void initState() {
    _participacionFuture = _obtenerParticipacionFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final sorteo = Provider.of<Sorteos>(context, listen: false).fetchById(id);
    var diasRestantes = sorteo.fechaFin.difference(DateTime.now()).inDays;

    Future<void> _participar() async {
      try {
        await Provider.of<Participaciones>(context, listen: false)
            .addParticipacion(id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    // TODO: ERROR AL REDIBUJAR EL WIDGET

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                sorteo.foto,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                sorteo.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Fecha de creación: ${DateFormat.yMd().format(sorteo.fechaInicio)}',
              style: const TextStyle(color: Colors.grey),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                diasRestantes == 0
                    ? '¡Ya terminó!'
                    : 'Faltan $diasRestantes días para que finalice!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                sorteo.texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: _participacionFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.error != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Error al cargar participacion"),
                    ),
                  );
                }

                return Consumer<Participaciones>(
                  builder: (ctx, participaciones, _) =>
                      participaciones.fetchBySorteoId(id) == false
                          ? RaisedButton(
                              onPressed: _participar,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Participar!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.orangeAccent,
                            )
                          : Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.pinkAccent,
                              ),
                              child: const Text(
                                'Ya estas participando!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
