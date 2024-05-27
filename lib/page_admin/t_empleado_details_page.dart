// ignore_for_file: deprecated_member_use

import 'package:inka_challenge/login_page.dart';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:flutter/material.dart';

class DetailsEmpleadosWidget extends StatelessWidget {
  const DetailsEmpleadosWidget({
    super.key,
    required this.e,
  });

  final TEmpleadoModel e;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageLoginUser(
          user: e,
          size: 150,
        ),
        Flexible(
          flex: 1,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: DataTable(
              columns: [
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
            ],
             rows: [
              _dataRow('Nombre', e.nombre),
              _dataRow('Apellido Paterno', e.apellidoPaterno),
              _dataRow('Apellido Materno', e.apellidoMaterno),
              _dataRow('Género', e.sexo),
              _dataRow('cédula (DNI)', e.cedula.toString()),
              _dataRow('Contraseña', e.contrasena),
              _dataRow('Telefono', e.telefono),
               _dataRow('Cuenta', e.estado ? 'Activo' : 'Inactivo'),
              _dataRow('Rol', e.rol),
            ]),
          ),
        ),
      ],
    );
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
