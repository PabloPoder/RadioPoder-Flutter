import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
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
  late ConfettiController controller;

  Future _obtenerParticipacionFuture() {
    return Provider.of<Participaciones>(context, listen: false)
        .fetchAndSetParticipaciones();
  }

  @override
  void initState() {
    _participacionFuture = _obtenerParticipacionFuture();

    controller = ConfettiController(duration: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final sorteo = Provider.of<Sorteos>(context, listen: false).fetchById(id);
    var diasRestantes = sorteo.fechaFin.difference(DateTime.now()).inDays;
    final usuarioId = Provider.of<Auth>(context, listen: false).usuario!.id;

    if (sorteo.ganadorId == usuarioId) {
      controller.play();
    }

    Future<void> _participar() async {
      try {
        await Provider.of<Participaciones>(context, listen: false)
            .addParticipacion(id);

        setState(() {
          _participacionFuture = _obtenerParticipacionFuture();
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ha ocurrido un error!'),
            content: const Text(
                "Ha ocurrido un error al participar en el sorteo. Por favor, inténtelo mas tarde."),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
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
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Hero(
                  tag: sorteo.id,
                  child: Image.network(
                    sorteo.foto,
                    fit: BoxFit.cover,
                  ),
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
                  diasRestantes == 0 || sorteo.ganadorId != null
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
                        participaciones.fetchBySorteoId(id) == false &&
                                sorteo.ganadorId == null &&
                                diasRestantes > 0
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
                                  color: sorteo.ganadorId == usuarioId
                                      ? Colors.orangeAccent
                                      : Colors.pinkAccent,
                                ),
                                child: Text(
                                  sorteo.ganadorId == null
                                      ? 'Ya estas participando!'
                                      : sorteo.ganadorId == usuarioId
                                          ? 'Felicidades, ganaste!'
                                          : 'Sorteo finalizado!',
                                  style: const TextStyle(
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
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller,
            shouldLoop: true,
            colors: const [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue
            ],
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 4,
          ),
        ),
      ]),
    );
  }
}
