

import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/random_color.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DiagramaCategorias extends StatelessWidget {
   DiagramaCategorias({
    super.key,
  });
  final List<Categoria> categorias = [
    Categoria('13k', 50),
    Categoria('30k', 30),
    Categoria('60k', 20),
    Categoria('100k', 10),
  ];

  // final List<Categoria> categorias;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( vertical:10),
      child: Card(
        color: Colors.white,
        elevation: 0.2,
        surfaceTintColor: Colors.white,
        child: SfCartesianChart(
          title:  const ChartTitle(
            alignment: ChartAlignment.near,
            text: 'Grafico De Inscritos',
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          legend: const Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.top,
            textStyle: TextStyle(color: Colors.black),
          ),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(
              text: 'Distancais',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            // labelStyle: TextStyle(color: Colors.black),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(
              text: 'Incritos',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            // labelStyle: TextStyle(color: Colors.black),
          ),
          series: <ColumnSeries>[
            ColumnSeries<Categoria, String>(
              
              dataSource: categorias,
              xValueMapper: (Categoria categoria, _) => categoria.distancia,
              yValueMapper: (Categoria categoria, _) => categoria.inscritos,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true, // Mostrar etiquetas de datos
              ),
               enableTooltip: true,
               pointColorMapper: (Categoria data, _) => getRandomColor(),
            ),
            
          ],
          tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              Categoria location = data;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H2Text(
                        text: '${'Distancia'.toUpperCase()} :${location.distancia}',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                    H2Text(
                      text: '${location.inscritos} Incritos',
                      color: Colors.white,
                      fontSize: 12,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class Categoria {
  final String distancia;
  final int inscritos;

  Categoria(this.distancia, this.inscritos);
}