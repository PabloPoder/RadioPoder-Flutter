import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sorteos.dart';
import '../widgets/sorteo_item.dart';

class SorteosPage extends StatelessWidget {
  const SorteosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Sorteos>(
      builder: (context, sorteos, _) => GridView.builder(
        itemCount: sorteos.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemBuilder: (context, index) =>
            SorteoItem(sorteo: sorteos.items[index]),
      ),
    );
  }
}
