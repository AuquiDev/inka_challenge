import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/model/provider_config_carrera.dart';
import 'package:inka_challenge/page/widget_dashoard_char_checkPoint.dart';
import 'package:inka_challenge/page/widget_dashoard_checkpoints.dart';
import 'package:inka_challenge/page/widget_dashoard_distancias.dart';
import 'package:inka_challenge/page/widget_dashoard_evento.dart';
import 'package:inka_challenge/page/widget_dashoard_inscritos.dart';
import 'package:inka_challenge/utils/random_color.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:provider/provider.dart';

class TablaParticipacion extends StatefulWidget {
  const TablaParticipacion({
    super.key,
  });

  @override
  State<TablaParticipacion> createState() => _TablaParticipacionState();
}

class _TablaParticipacionState extends State<TablaParticipacion> {
  @override
  void initState() {
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, // Solo retrato
       DeviceOrientation.portraitUp, // Solo retrato
    ]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final idEvento = Provider.of<EventIdProvider>(context).eventoPref;
    return  Scaffold(
      backgroundColor: const Color(0xFFF2F1F1),
      appBar:size.width > 900 ? AppBar(
        title:  Text("Tabla de Participación $idEvento"),
      ): null,
      body:  const Row(
        children: [
          Flexible(flex: 1, child: Clientes()),
          Flexible(flex: 2, child: CateforiasDistancias()),
          Flexible(flex: 1, child: Corredores()),
        ],
      ),
    );
  }
}

class Clientes extends StatelessWidget {
  const Clientes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollWeb(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SelectEvento(),
              DistanciasEvento(),
              GraficaPoitnsElevacion(),
            ],
          ),
        ),
      ),
    );
  }
}

class CateforiasDistancias extends StatelessWidget {
  const CateforiasDistancias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DiagramaCategorias(),
        Expanded(child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: DistanciasLengt())),
      ],
    );
  }
}

class Corredores extends StatelessWidget {
  const Corredores({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ScrollWeb(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ControlAgregado(),
               ControlAgregado(),
                ControlAgregado(),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlAgregado extends StatelessWidget {
  final List<int> datos = [8, 20, 12, 30];

  ControlAgregado({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0.2,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        painter: DatosCirculoPainter(datos: datos),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.black12),
                        children: [
                          TableRow(
                            children: [
                              //GRAFICA POR GENERO EDAD ETC
                              _tablecellcustom('usuarios', datos[0]),
                              _tablecellcustom('Articulos', datos[1]),
                              _tablecellcustom('Transport', datos[2]),
                              _tablecellcustom('Personal', datos[3]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]))),
    );
  }

  TableCell _tablecellcustom(String title, int datos) {
    return  TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FittedBox(
              child: H2Text(
                text: title,
                fontSize: 11,
                color: Colors.black87,
              ),
            ),
            FittedBox(
              child: H2Text(
                text: datos.toString(),
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ),
    );
  }
}

class DatosCirculoPainter extends CustomPainter {
  final List<int> datos;

  DatosCirculoPainter({required this.datos});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Color del círculo
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final double center = size.width / 2;
    final double radius = center - paint.strokeWidth / 2;

    const double startAngle = -pi / 2;

    // Calcula el ángulo para cada dato en base al total
    double total = datos.reduce((value, element) => value + element).toDouble();
    double previousAngle = startAngle;
    for (int i = 0; i < datos.length; i++) {
      double sweepAngle = (2 * pi * datos[i]) / total;
      paint.color = getRandomColor();
      canvas.drawArc(
        Rect.fromCircle(center: Offset(center, center), radius: radius),
        previousAngle,
        sweepAngle,
        false,
        paint,
      );
      previousAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
