// ignore_for_file: avoid_print

import 'dart:async';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/provider/provider_t_empleado.dart';
import 'package:inka_challenge/utils/parse_bool.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:inka_challenge/utils/decoration_form.dart';
import 'package:inka_challenge/widgets/close_page_buton.dart';
import 'package:provider/provider.dart';

class EmpleadosFormEditing extends StatefulWidget {
  const EmpleadosFormEditing({
    super.key,
    this.e,
  });
  final TEmpleadoModel? e;
  @override
  State<EmpleadosFormEditing> createState() => _EmpleadosFormEditingState();
}

class _EmpleadosFormEditingState extends State<EmpleadosFormEditing> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // List<DateTime?> _selectedDates = [];
  var title = 'NUEVO USUARIO';
  bool valueEstadoProducto = true; //SwithAdaptative check
  bool isVisible = true; //contraseña
  String rolPuesto = '';
  @override
  void initState() {
    if (widget.e != null) {
      _idEmpleadoController.text = widget.e!.id!;
      _estadoController.text = widget.e!.estado.toString();
      _nombreController.text = widget.e!.nombre;
      _apellidoPaternoController.text = widget.e!.apellidoPaterno;
      _apellidoMaternoController.text = widget.e!.apellidoMaterno;
      _sexoController.text = widget.e!.sexo;
      _cedulaController.text = widget.e!.cedula.toString();
      _telefonoController.text = widget.e!.telefono;
      _contrasenaController.text = widget.e!.contrasena;
      _roleController.text = widget.e!.rol.toString();
      title = 'Editar Registro';
    } else {
      _estadoController.text = valueEstadoProducto.toString();
    }
    super.initState();
  }

  List<Widget> formularios = [];

  String? selectedRol;
  String? selectedSexo;
  @override
  Widget build(BuildContext context) {
    List<String> tipo = ['admin', 'user'];
    List<String> sexo = ['Femenino', 'Masculino'];
    final providerEmpleados = Provider.of<TEmpleadoProvider>(context);
    formularios = [
      nombreForm(),
      apellido1Form(),
      apellido2Form(),
      cedulaForm(),
      contrasenaFomr(),
      rolForm(tipo),
      sexoForm(sexo),
      
      estatusForm(),
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.white,
          title: H2Text(
            text: title,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          leading: const ClosePageButon(),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 140,
                  child: Card(
                    color: const Color(0xFF1866EE),
                    child: TextButton(
                      onPressed: providerEmpleados.isSyncing
                          ? null
                          : () async {
                              print('push buton');
                              if (_formKey.currentState!.validate()) {
                                if (widget.e != null) {
                                  editarDatos();
                                  _formKey.currentState!.save();
                                } else {
                                  enviarDatos();
                                  _formKey.currentState!.save();
                                }
                              } else {
                                completeForm();
                              }
                            },
                      child: Center(
                          child: providerEmpleados.isSyncing
                              ? const CircularProgressIndicator(color: Colors.white,)
                              : const H2Text(
                                  text: 'Guardar',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                )),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 300).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return ScrollWeb(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 2.9,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 20),
                        itemCount: formularios.length,
                        itemBuilder: (BuildContext context, int index) {
                          final e = formularios[index];
                          return e;
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget estatusForm() {
    return SwitchListTile.adaptive(
      dense: true,
      title: const H2Text(
        text: 'ESTADO USUARIO',
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      subtitle: H2Text(
        text: parseBool(_estadoController.text) ? 'Activo' : 'Inactivo',
        fontSize: 14,
      ),
      value: parseBool(_estadoController.text),
      activeColor: Colors.green,
      inactiveTrackColor: Colors.red,
      onChanged: (value) {
        setState(() {
          _estadoController.text = value.toString();
        });
      },
    );
  }

  DropdownButtonFormField<String> rolForm(List<String> tipo) {
    return DropdownButtonFormField<String>(
      decoration: decorationTextField(
        hintText: 'Selecciona el Rol',
        labelText: 'Rol',
      ),
      value: selectedRol,
      onChanged: (String? newValue) async {
        setState(() {
          selectedRol = newValue;
          print(newValue);
        });
        _sexoController.text = selectedRol!;
      },
      items: tipo.map((String trail) {
        return DropdownMenuItem<String>(
          value: trail,
          child: H2Text(
            text: trail,
            color: Colors.black87,
            fontSize: 12,
          ),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> sexoForm(List<String> sexo) {
    return DropdownButtonFormField<String>(
      decoration: decorationTextField(
        hintText: 'Selecciona el genero',
        labelText: 'Genero',
      ),
      value: selectedSexo,
      onChanged: (String? newValue) async {
        setState(() {
          selectedSexo = newValue;
          print(newValue);
        });
        _sexoController.text = selectedSexo!;
      },
      items: sexo.map((String trail) {
        return DropdownMenuItem<String>(
          value: trail,
          child: H2Text(
            text: trail,
            color: Colors.black87,
            fontSize: 12,
          ),
        );
      }).toList(),
    );
  }

  TextFormField contrasenaFomr() {
    return TextFormField(
      controller: _contrasenaController,
      obscureText: isVisible,
      // maxLength: 6,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Denegar espacios
      ],
      decoration: decorationTextField(
          hintText: 'campo obligatorio',
          labelText: 'Ingrese su Contraseña',
          prefixIcon: IconButton(
              onPressed: () {
                isVisible = !isVisible;
                setState(() {});
              },
              icon: Icon(
                isVisible != true ? Icons.visibility : Icons.visibility_off,
                size: 18,
              ))),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Campo obligatorio';
        }
        if (value!.length < 6) {
          return 'Ingrese más de 6 caracteres';
        }
        if (value.contains(' ')) {
          return 'La contraseña no puede contener espacios';
        }
        return null;
      },
    );
  }

  TextFormField cedulaForm() {
    return TextFormField(
      controller: _cedulaController,
      keyboardType: TextInputType.number,
      maxLength: 8,
      inputFormatters: [
        //Expresion Regular
        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
      ],
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Nro. de Cédula: ',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Campo obligatorio';
        }
        if (value!.length < 8) {
          return 'Ingrese 8 digitos';
        }
        return null;
      },
    );
  }

  TextFormField apellido2Form() {
    return TextFormField(
      controller: _apellidoMaternoController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Apellido Materno.',
      ),
    );
  }

  TextFormField apellido1Form() {
    return TextFormField(
      controller: _apellidoPaternoController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Apellido Paterno.',
      ),
    );
  }

  TextFormField nombreForm() {
    return TextFormField(
      controller: _nombreController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Nombre',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        } else {
          return null;
        }
      },
    );
  }

  Future<void> editarDatos() async {
    await context.read<TEmpleadoProvider>().updateEmpleadoProvider(
        id: widget.e!.id,
        estado: parseBool(_estadoController.text),
        nombre: _nombreController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        sexo: _sexoController.text,
        cedula: int.parse(_cedulaController.text),
        telefono: _telefonoController.text,
        contrasena: _contrasenaController.text,
        rol: _roleController.text);
    snackBarButon('✅ Registro editado correctamente.');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TEmpleadoProvider>().postEmpleadoProvider(
        //  id: id,
        estado: parseBool(_estadoController.text),
        nombre: _nombreController.text,
        apellidoPaterno: _apellidoPaternoController.text,
        apellidoMaterno: _apellidoMaternoController.text,
        sexo: _sexoController.text,
        cedula: int.parse(_cedulaController.text),
        telefono: _telefonoController.text,
        contrasena: _contrasenaController.text,
        rol: _roleController.text);
    snackBarButon('✅ Se ha añadido un nuevo registro.');
    _cleanAll();
  }

  void snackBarButon(String e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          H2Text(
            text: e,
            maxLines: 3,
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ));
  }

  void _cleanAll() {
    _estadoController.clear();
    _nombreController.clear();
    _apellidoPaternoController.clear();
    _apellidoMaternoController.clear();
    _sexoController.clear();
    _cedulaController.clear();
    _telefonoController.clear();
    _contrasenaController.clear();
    _roleController.clear();
  }

  // Future<void> _pickDate(BuildContext context) async {
  //   final List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
  //     context: context,
  //     config: CalendarDatePicker2WithActionButtonsConfig(
  //         calendarType: CalendarDatePicker2Type.single),
  //     dialogSize: const Size(375, 400),
  //     value: _selectedDates,
  //   );

  //   if (pickedDates != null && pickedDates.isNotEmpty) {
  //     setState(() {
  //       _selectedDates = pickedDates;
  //       // _fechaacimientoController.text =
  //       //     pickedDates[0].toString(); //_formatDate(pickedDates[0]);
  //       print('posicion 01 ${pickedDates[0]}');
  //       // print('TextController ${_fechaacimientoController.text}');
  //     });
  //   }
  // }

  //ENOMCTRAR ERROR DE FORMUALRIO Y REDIRIGIR AUTOMETICAMENTE
  void completeForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: H2Text(
          text: '🚨 Por favor, completa todos los campos obligatorios.',
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



    // TextFormField(
                    //   // enabled: false,
                    //   readOnly:
                    //       true, // Deshabilita la edición directa del texto
                    //   showCursor:
                    //       true, // Muestra el cursor al tocar el campo
                    //   controller: _fechaacimientoController,
                    //   decoration: decorationTextField(
                    //       hintText: 'campo obligatorio',
                    //       labelText: 'Fecha de Nacimiento.',
                    //       prefixIcon: const Icon(
                    //           Icons.calendar_month_outlined,
                    //           color: Colors.black45)),
                    //   onTap: () {
                    //     _pickDate(context);
                    //     print(_fechaacimientoController.text);
                    //   },
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Campo obligatorio';
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    //   onChanged: (value) {
                    //     _pickDate(context);
                    //     print(value);
                    //   },
                    // ),