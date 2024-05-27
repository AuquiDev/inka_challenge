import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/page_admin/t_empleado_gestion_page.dart';
import 'package:inka_challenge/pages2/t_ubicaciones_page.dart';

import 'package:inka_challenge/provider/provider_datacahe.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routes {
  Routes({required this.titulo, required this.page, required this.widget});

  final String titulo;
  final Widget page;
  final Widget widget;

  Widget buildCard(BuildContext context) {
    TEmpleadoModel? user =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return GestureDetector(
      onTap: () {
        if (user!.rol == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Acceso denegado. El usuario no es administrador.'),
            ),
          );
        }
      },
      child: Card(
        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget,
            H2Text(
              text: titulo.toUpperCase(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class RoutesFactory {
  static List<Routes> createRoutes() {
    return [
      Routes(
          titulo: 'USUARIOS',
          page: const EmpleadosFormPage(),
          widget: const Icon(
            Icons.groups_2_outlined,
            color: Colors.black54,
            size: 100,
          )),
      Routes(
          titulo: 'Almacén',
          page: const TPageUbicaciones(),
          widget: const Icon(
            Icons.holiday_village,
            size: 100,
          )),
    ];
  }
}
