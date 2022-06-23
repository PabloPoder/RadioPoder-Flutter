import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_poder_app/models/sorteo.dart';

import '../screens/sorteo_detalle.dart';

class SorteoItem extends StatelessWidget {
  final Sorteo sorteo;

  const SorteoItem({Key? key, required this.sorteo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SorteoDetalle.route, arguments: sorteo.id);
      },
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Hero(
                        tag: sorteo.id,
                        child: Image.network(
                          sorteo.foto,
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
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                sorteo.titulo,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                sorteo.ganadorId != null
                    ? "Finalizado"
                    : "Finaliza: " + DateFormat.yMd().format(sorteo.fechaFin),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: sorteo.ganadorId != null
                        ? Colors.orangeAccent
                        : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
