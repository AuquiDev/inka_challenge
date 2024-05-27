// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_null_comparison

import 'package:inka_challenge/pages3/t_runners_list_page.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/provider/provider_t_runners_ar.dart';
import 'package:provider/provider.dart';

class FormularioAsistenciapage extends StatelessWidget {
  const FormularioAsistenciapage({super.key});

  @override
  Widget build(BuildContext context) {
    final listAsitencia =
        Provider.of<TRunnersProvider>(context).listAsistencia;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: ListRunners(
            listAsitencia: listAsitencia,
          )),
    );
  }
}
