import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/random_color.dart';
import 'package:inka_challenge/utils/scroll_web.dart';

class DistanciasLengt extends StatelessWidget {
  DistanciasLengt({Key? key}) : super(key: key);

  final List<List<dynamic>> categorias = [
    ['13k', 50, 35, 25],
    ['30k', 30, 20, 15],
    ['60k', 20, 15, 10],
    ['100k', 10, 8, 5],
    // Agregar más categorías si es necesario
  ];

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Calcular el número de columnas en función del ancho disponible
      int crossAxisCount = (constraints.maxWidth / 250).floor();
      // Puedes ajustar el valor 100 según tus necesidades
      return ScrollWeb(
        child: GridView.builder(
          // physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            // childAspectRatio: size.width > 500 ? 1.6 :2,
            childAspectRatio: constraints.maxWidth > 500 ? 1.6 : 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: categorias.length,
          itemBuilder: (BuildContext context, int index) {
            final categoria = categorias[index];
            final distancia = categoria[0] as String;
            final inscritos = categoria[1] as int;
            final controlesAprobados = categoria[2] as int;
            final puntosControlCompletados = categoria[3] as int;
            return _buildCategoriaTile(
              distancia,
              inscritos,
              controlesAprobados,
              puntosControlCompletados,
            );
          },
        ),
      );
    });
  }

  Widget _buildCategoriaTile(
    String distancia,
    int inscritos,
    int starthed,
    int finished,
  ) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Andes Race 2024',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    distancia,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: getRandomColor()),
                  ),
                  Column(
                    children: [
                      Text(
                        '$inscritos'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Inscritos'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$starthed'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Starthed'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: starthed / inscritos,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getRandomColor(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$finished'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Finished'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: finished / inscritos,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getRandomColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
