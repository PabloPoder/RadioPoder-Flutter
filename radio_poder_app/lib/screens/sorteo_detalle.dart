import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/sorteos.dart';

class SorteoDetalle extends StatelessWidget {
  static const route = "/sorteo_detalle";

  const SorteoDetalle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final sorteo = Provider.of<Sorteos>(context, listen: false).fetchById(id);
    var diasRestantes = sorteo.fechaFin.difference(DateTime.now()).inDays;

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
                    : 'Faltan ${diasRestantes} días para que finalice!',
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
            SizedBox(height: 16),
            RaisedButton(
              color: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Participar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              onPressed: () {
                // TODO: Crear participacion con Id del sorteo y Id del usuario
              },
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
