import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        NewsItem(
          title: 'La administración pública cobrará este viernes 29 de abril',
          date: '4/29/2022',
          image: 'image',
        ),
        NewsItem(
          title: 'Otra escuela de Juana Koslay ya tiene su Corazón Recolector',
          date: '4/29/2022',
          image: 'image',
        ),
        NewsItem(
          title: 'Otra escuela de Juana Koslay ya tiene su Corazón Recolector',
          date: '4/29/2022',
          image: 'image',
        ),
      ],
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final date;
  final image;

  const NewsItem(
      {Key? key, required this.title, required this.date, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            height: 80,
            width: 80,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        date,
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
    );
  }
}
