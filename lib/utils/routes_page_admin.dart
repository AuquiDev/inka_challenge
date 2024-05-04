
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/pages2/t_empleado_gestion_page.dart';
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

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  Widget buildCard(BuildContext context) {
    TEmpleadoModel? user =  Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return GestureDetector(
      onTap: () {
        if (titulo == 'Empleados') {
          if ( user!.rol == 'admin') {
            print(user.rol);
              navigate(context);    
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Acceso denegado. El usuario no es administrador.'),
              ),
            );
          }
        } else {
          
           navigate(context);    
        }
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: widget,
            ),
            const SizedBox(height: 8),
            Flexible(
              flex: 1,
              child: H2Text(text:
                titulo,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                maxLines: 2,
              ),
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
      Routes(titulo: 'Empleados', page:  const EmpleadosFormPage(), widget: const Icon(Icons.groups_2_outlined)),
      Routes(titulo: 'Crear Almacén', page: const TPageUbicaciones(), widget: const Icon(Icons.inventory_rounded)),

    ];
  }
}
