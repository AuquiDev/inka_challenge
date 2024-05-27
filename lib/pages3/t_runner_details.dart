// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:inka_challenge/model/model_distancias_ar.dart';
import 'package:inka_challenge/model/model_runners_ar.dart';
import 'package:inka_challenge/provider/provider_t_distancias_ar.dart';
import 'package:inka_challenge/provider/provider_t_runners_ar.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsRunners extends StatefulWidget {
  const DetailsRunners({
    super.key,
    required this.e,
  });
  final TRunnersModel e;

  @override
  State<DetailsRunners> createState() => _DetailsRunnersState();
}

class _DetailsRunnersState extends State<DetailsRunners> {
  @override
  Widget build(BuildContext context) {
    final lisDetalleTrabajo =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;
    TDistanciasModel obtenerDetalleTrabajo(String idTrabajo) {
      for (var data in lisDetalleTrabajo) {
        if (data.id == widget.e.idDistancia) {
          return data;
        }
      }
      return TDistanciasModel(
        distancias: '',
        descripcion: '',
        estatus: true,
        color: '',
      );
    }

    final v = obtenerDetalleTrabajo(widget.e.idDistancia);

    final isSavingSerer = Provider.of<TRunnersProvider>(context).isSyncing;
    bool isavingProvider = isSavingSerer;
    return SafeArea(
      child: Center(
        child: isavingProvider
            ? const SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        H2Text(
                          text: v.distancias,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                        Image.asset(
                          'assets/img/runner.png',
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            bool confirmDelete = await _confirmDelete(context);
                            if (confirmDelete) {
                              // Navigator.pop(context);
                            } else {
                              print('No Elimiando');
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<TRunnersProvider>().deleteTAsistenciaApp(
                      widget.e.id!,
                    );
                Navigator.of(context).pop(true);
                snackDelete(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return result;
  }

  void snackDelete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: H2Text(
          text:
              '✅ Registro eliminado exitosamente. Vuelve a la página anterior para visualizar los cambios.',
          maxLines: 3,
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
