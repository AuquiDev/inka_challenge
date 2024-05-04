
import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficaPoitnsElevacion extends StatelessWidget {
  final List<LocationData> data = [
    LocationData(
        'Ollantaytambo', 2792), // Altura en metros sobre el nivel del mar
    LocationData('Lares', 3300),
    LocationData('Chupani', 3600),
    LocationData('Huaran', 3100),
    LocationData('Patacancha', 3800),
    LocationData('Willoc', 3300),
    LocationData('Pumamarca', 3000),
    LocationData('Huilloq', 3600),
    LocationData('Incahuasi', 3400),
    LocationData('Piscacucho', 2700),
    LocationData('Aguas Calientes', 2000),
    LocationData('Machu Picchu Pueblo', 2000),
    LocationData('Yucay', 2800),
  ];

   GraficaPoitnsElevacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        elevation: 0.2,
        surfaceTintColor: Colors.white,
        child: SfCartesianChart(
          title:  const ChartTitle(
            alignment: ChartAlignment.near,
            text: 'Grafico De Altitud',
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
              text: 'Ubicaciones',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            // labelStyle: TextStyle(color: Colors.black),
          ),
          primaryYAxis: const NumericAxis(
            // isVisible:  false,
            title: AxisTitle(
              text: 'Altitud (msnm)',
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            // labelStyle: TextStyle(color: Colors.black),
          ),
          series: <LineSeries>[
            LineSeries<LocationData, String>(
              dataSource: data,
              xValueMapper: (LocationData location, _) => location.name,
              yValueMapper: (LocationData location, _) => location.altitude,
              name: 'Altitud',
              markerSettings: const MarkerSettings(isVisible: true),
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
            ),
          ],
          tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              LocationData location = data;
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
                        text: 'Check-Point'.toUpperCase(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                    H2Text(
                      text: '${location.name}: ${location.altitude} msnm',
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

class LocationData {
  final String name;
  final int altitude;

  LocationData(this.name, this.altitude);
}
