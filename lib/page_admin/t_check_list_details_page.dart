// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:delayed_display/delayed_display.dart';
import 'package:inka_challenge/model/model_t_checklist.dart';
import 'package:inka_challenge/model/provider_t_checklist.dart';
import 'package:inka_challenge/provider/provider_t_empleado.dart';
import 'package:inka_challenge/provider/provider_t_productoapp.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/format_fecha.dart';
import 'package:provider/provider.dart';

class DetailsCheckListWidget extends StatelessWidget {
  const DetailsCheckListWidget({
    super.key,
    required this.e,
  });

  final TCheckListModel e;

  @override
  Widget build(BuildContext context) {
    final listaEmpleados =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados
          ..sort(
            (a, b) => a.nombre.compareTo(b.nombre),
          );
     final listaInsumos =
        Provider.of<TProductosAppProvider>(context).listProductos
          ..sort(
            (a, b) => a.nombreProducto.compareTo(b.nombreProducto),
          );
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 400),
                child: _checkPoitnsDetails(),
              ),
            ),
            const VerticalDivider(),
            Flexible(
              flex: 1,
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 800),
                child: _personalSubList(context),
              ),
            ),
            const VerticalDivider(),
            Flexible(
              flex: 1,
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 1000),
                child: _insumosSubLIst(context),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                const H2Text(text: 'PERSONAL', fontSize: 13,), 
                ...List.generate(listaEmpleados.length, (index) {
                  final a = listaEmpleados[index];
                  return ListTile(
                    title: H2Text(
                      text: a.nombre,
                      fontSize: 12,
                    ),
                    leading: IconButton(
                        onPressed: () {
                          e.personal!.add(a);
                          editarDatos(context);
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        )),
                  );
                })
              ],
            )),
            Expanded(
                child: Column(
              children: [
                 const H2Text(text: 'INSUMOS', fontSize: 13,), 
                ...List.generate(listaInsumos.length, (index) {
                  final a = listaInsumos[index];
                  return ListTile(
                    title: H2Text(
                      text: a.nombreProducto,
                      fontSize: 12,
                    ),
                    leading: IconButton(
                        onPressed: () {
                          e.itemsList!.add(a);
                          editarDatos(context);
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        )),
                  );
                })
              ],
            ))
          ],
        )
      ],
    );
  }

  DataTable _insumosSubLIst(BuildContext context) {
    return DataTable(columns: [
      DataColumn(
          label: H2Text(
        text: 'INSUMO'.toUpperCase(),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )),
       const DataColumn(
          label: H2Text(
        text: 'CANTIDAD',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )),
      const DataColumn(
          label: H2Text(
        text: '',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )),
    ], rows: [
      ...List.generate(
        e.itemsList!.length,
        (index) {
          final p = e.itemsList![index];
           return DataRow(
            cells: [
              DataCell(H3Text(
                text: p.nombreProducto,
                // fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              )),
              DataCell(H3Text(
                text: '${p.stock}',
                // fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              )),
              DataCell(
                IconButton(
                    onPressed: () {
                      e.personal!.remove(p);
                      editarDatos(context);
                    },
                    icon: const Icon(Icons.remove_circle, color: Colors.red)),
              ),
            ],
          );
        },
      ),
    ]);
  }

  DataTable _personalSubList(BuildContext context) {
    return DataTable(columns: [
      DataColumn(
          label: H2Text(
        text: 'Personal'.toUpperCase(),
        fontWeight: FontWeight.bold,
        fontSize: 18,
        textAlign: TextAlign.center,
      )),
      DataColumn(
          label: H2Text(
        text: ''.toUpperCase(),
        fontWeight: FontWeight.bold,
        fontSize: 18,
        textAlign: TextAlign.center,
      )),
    ], rows: [
      ...List.generate(
        e.personal!.length,
        (index) {
          final p = e.personal![index];

          return DataRow(
            cells: [
              DataCell(H3Text(
                text: '${p.nombre} ${p.apellidoPaterno} ${p.apellidoMaterno}',
                // fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              )),
              DataCell(
                IconButton(
                    onPressed: () {
                      e.personal!.remove(p);
                      editarDatos(context);
                    },
                    icon: const Icon(Icons.remove_circle, color: Colors.red)),
              ),
            ],
          );
        },
      ),
    ]);
  }

  DataTable _checkPoitnsDetails() {
    return DataTable(columns: [
      DataColumn(
          label: H2Text(
        text: 'Campo'.toUpperCase(),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )),
      DataColumn(
          label: H2Text(
        text: 'Descripción'.toUpperCase(),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      )),
    ], rows: [
      _dataRow('ORDEN', e.orden.toString()),
      _dataRow('NOMBRE', e.nombre),
      _dataRow('DESCRIPCIÓN', e.descripcion),
      _dataRow('UBICACIÓN', e.ubicacion),

      _dataRow('APERTURA', formatFechaAndesRace(e.horaApertura)),
      _dataRow('CIERRE', formatFechaAndesRace(e.horaCierre)),

      _dataRow('ESTADO', e.estatus ? 'Activo' : 'Inactivo'),
      // _dataRow('Rol', e.rol),
    ]);
  }

  Future<void> editarDatos(BuildContext context) async {
    await context.read<TCheckListProvider>().updateTUbicacionesProvider(
          id: e.id,
          idEvento: e.idEvento,
          nombre: e.nombre,
          descripcion: e.descripcion,
          ubicacion: e.ubicacion,
          orden: (e.orden),
          horaApertura: (e.horaApertura),
          horaCierre: (e.horaCierre),
          estatus: e.estatus,
          personal: e.personal,
          itemsList: e.itemsList
        );
    snackBarButon('✅ Registro editado correctamente.', context);
  }

  void snackBarButon(String e, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF0F80DE),
            ),
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            padding: const EdgeInsets.all(10),
            child: H2Text(
              text: e,
              maxLines: 3,
              fontSize: 12,
              color: Colors.white,
              textAlign: TextAlign.center,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ));
  }

  DataRow _dataRow(String campo, String description) {
    return DataRow(
      cells: [
        DataCell(H3Text(
          text: campo.toUpperCase(),
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        )),
        DataCell(H3Text(text: description)),
      ],
    );
  }
}
