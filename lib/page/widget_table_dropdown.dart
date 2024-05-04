// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:inka_challenge/model/provider_t_checklist.dart';
import 'package:inka_challenge/model/provider_t_checkpoitns.dart';
import 'package:inka_challenge/page/widget_table_data_runner.dart';
import 'package:inka_challenge/utils/format_fecha.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler_table/time_scheduler_table.dart';

class DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> e;
  const DropDownContainer({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(text: 'Check List'), // Pestaña 1
            Tab(text: 'Check Points'), // Pestaña 2
            Tab(text: 'Time Acumulado'), // Pestaña 2
          ]),
          SizedBox(
            height: 500,
            child: TabBarView(children: [
              CheckList(e: e),
              TablaCheckPointsRunners(e: e),
              ScroreRunner(e: e)
            ]),
          ),
        ],
      ),
    );
  }
}

class ScroreRunner extends StatelessWidget {
  const ScroreRunner({
    super.key,
    required this.e,
  });

  final Map<String, dynamic> e;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(e['intervalos'].length, (index) {
                  TimeAcumulado data = e['intervalos'][index];
                  String obtenerPoitnsName(String idCheckPoints) {
                    final lista = Provider.of<TCheckpointsProvider>(context)
                        .listUbicacion;
                    for (var i in lista) {
                      if (i.id == idCheckPoints) {
                        return i.nombre;
                      }
                    }
                    return 'Punto $index';
                  }

                  //Color intercalado
                  Color color = index % 2 == 0
                      ? const Color(0xB8C0BDBD)
                      : const Color(0xFFE0DEDC);
                  Color colortext = const Color(0xFF1E4E75);
                  String punto1 =
                      obtenerPoitnsName(data.checkPoints1).toUpperCase();
                  String acumulado = data.acumulado;
                  String punto2 =
                      obtenerPoitnsName(data.checkPoints2).toUpperCase();
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      if (index == 0)
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B0000),
                          ),
                          children: [
                            _tableCell('CHECK POINT'),
                            _tableCell('Acumulado\nHH:MM:SS'),
                            _tableCell('CHECK POINT'),
                          ],
                        ),
                      _tableRowdata(color, colortext, punto1, acumulado, punto2), 
                       if (index == e['intervalos'].length-1)
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B0000),
                          ),
                          children: [
                            _tableCell('total'),
                            _tableCell(e['tiempo_acumulado']),
                            _tableCell(''),
                          ],
                        ),
                    ],
                  );
                }),
              ],
            ),
          )),
    );
  }

  Center _tableCell(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: H2Text(
          text: text.toUpperCase(),
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }

  TableRow _tableRowdata(Color color, Color colortext, String punto1,
      String acumulado, String punto2) {
    return TableRow(decoration: BoxDecoration(color: color), children: [
      Center(
        child: H2Text(
          text: punto1,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colortext,
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: H2Text(
            text: acumulado,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colortext,
          ),
        ),
      ),
      Center(
        child: H2Text(
          text: punto2,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colortext,
        ),
      ),
    ]);
  }
}

class CheckList extends StatefulWidget {
  const CheckList({
    super.key,
    required this.e,
  });

  final Map<String, dynamic> e;

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: ScrollWeb(
        child: TimeSchedulerTable(
          title: widget.e['nombre'],
          isBack: false,
          currentColumnTitleIndex: widget.e['checklist'].length,
          titleStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          eventTitleStyle: const TextStyle(fontSize: 16),
          cellHeight: 40,
          cellWidth: 80,
          rowTitles: List.generate(widget.e['checklist'].length, (index) {
            TimeRunner data = widget.e['checklist'][index];
            String obtenerPoitnsName(String idCheckPoints) {
              final lista =
                  Provider.of<TCheckListProvider>(context).listUbicacion;
              for (var i in lista) {
                if (i.id == idCheckPoints) {
                  return i.nombre;
                }
              }
              return 'Punto $index';
            }

            return obtenerPoitnsName(data.checkpoint);
          }),
          // currentColumnTitleIndex: DateTime.now().weekday - 1,
          columnTitles: List.generate(widget.e['checklist'].length, (index) {
            TimeRunner data = widget.e['checklist'][index];
            return data.fecha.year == 1998
                ? ' time $index'
                : formatFechaAndesRace(data.fecha);
          }),
          eventList: List.generate(widget.e['checklist'].length, (index) {
            TimeRunner data = widget.e['checklist'][index];
            return EventModel(
                title:
                    (data.fecha.hour != 1998) ? (data.estatus ? '✅' : '') : ' ',
                time: data.fecha.toString(),
                columnIndex: index,
                rowIndex: index,
                color: Colors.black12);
          }),
          eventAlert: EventAlert(
            alertTextController: textController,
          ),
        ),
      ),
    );
  }
}

class TablaCheckPointsRunners extends StatefulWidget {
  const TablaCheckPointsRunners({
    super.key,
    required this.e,
  });

  final Map<String, dynamic> e;

  @override
  State<TablaCheckPointsRunners> createState() =>
      _TablaCheckPointsRunnersState();
}

class _TablaCheckPointsRunnersState extends State<TablaCheckPointsRunners> {
  TextEditingController textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: ScrollWeb(
        child: TimeSchedulerTable(
          title: widget.e['nombre'],
          titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, decorationColor: Colors.black),
          isBack: false,
          eventTitleStyle: const TextStyle(fontSize: 15),
          cellHeight: 40,
          cellWidth: 90,
          currentColumnTitleIndex: widget.e['time'].length,
          rowTitles: List.generate(widget.e['time'].length, (index) {
            TimeRunner data = widget.e['time'][index];
            String obtenerPoitnsName(String idCheckPoints) {
              final lista =
                  Provider.of<TCheckpointsProvider>(context).listUbicacion;
              for (var i in lista) {
                if (i.id == idCheckPoints) {
                  return i.nombre;
                }
              }
              return 'Punto $index';
            }

            return obtenerPoitnsName(data.checkpoint);
          }),
          // currentColumnTitleIndex: DateTime.now().weekday - 1,
          columnTitles: List.generate(widget.e['time'].length, (index) {
            TimeRunner data = widget.e['time'][index];
            return data.fecha.year == 1998
                ? ' Time $index'
                : formatFechaAndesRace(data.fecha);
          }),
          eventList: List.generate(widget.e['time'].length, (index) {
            TimeRunner data = widget.e['time'][index];
            return EventModel(
                title:
                    (data.fecha.hour != 1998) ? (data.estatus ? '✅' : '') : ' ',
                time: data.fecha.toString(),
                columnIndex: index,
                rowIndex: index,
                color: Colors.black12);
          }),
          eventAlert: EventAlert(
            alertTextController: textController,
          ),
        ),
      ),
    );
  }
}
