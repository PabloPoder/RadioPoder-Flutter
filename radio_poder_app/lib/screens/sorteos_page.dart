import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sorteos.dart';
import '../widgets/sorteo_item.dart';

class SorteosPage extends StatefulWidget {
  const SorteosPage({Key? key}) : super(key: key);

  @override
  State<SorteosPage> createState() => _SorteosPageState();
}

class _SorteosPageState extends State<SorteosPage> {
  Future? _sorteosFuture;
  bool _ordenDeLista = false;

  _cambiarOrdenDeLista() {
    setState(() {
      _ordenDeLista = !_ordenDeLista;
    });
  }

  Future _obtenerSorteosFuture() {
    return Provider.of<Sorteos>(context, listen: false).fetchAndSetSorteos();
  }

  @override
  void initState() {
    _sorteosFuture = _obtenerSorteosFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'S O R T E O S',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: FutureBuilder(
        future: _sorteosFuture,
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
                onRefresh: _obtenerSorteosFuture,
                child: Consumer<Sorteos>(
                  builder: (context, sorteos, _) => Column(children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Más antiguos:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
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
                      child: GridView.builder(
                        itemCount: sorteos.items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2),
                        ),
                        itemBuilder: (context, index) => SorteoItem(
                            sorteo: _ordenDeLista == false
                                ? sorteos.items[index]
                                : sorteos.items.reversed.toList()[index]),
                      ),
                    ),
                  ]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
