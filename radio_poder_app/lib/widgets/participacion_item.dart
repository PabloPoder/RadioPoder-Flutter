import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_poder_app/models/participacion.dart';
import 'package:radio_poder_app/screens/sorteo_detalle.dart';

class ParticipacionItem extends StatelessWidget {
  final Participacion participacion;
  const ParticipacionItem({
    Key? key,
    required this.participacion,
  }) : super(key: key);

  // final bool isActive = true;

  @override
  Widget build(BuildContext context) {
    var diasRestantes =
        participacion.sorteo.fechaFin.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SorteoDetalle.route, arguments: participacion.sorteoId);
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
                child: Image.network(
                  participacion.sorteo.foto,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participacion.sorteo.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      diasRestantes == 0
                          ? '¡Ya terminó!'
                          : 'Finaliza en $diasRestantes días!',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.orangeAccent),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          "Participaste el " +
                              DateFormat.yMd().format(participacion.fecha),
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
