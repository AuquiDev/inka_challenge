// ignore_for_file: avoid_print

import 'dart:async';
import 'package:inka_challenge/model/model_evento.dart';
import 'package:inka_challenge/model/model_t_checklist.dart';
import 'package:inka_challenge/model/provider_t_checklist.dart';
import 'package:inka_challenge/provider/provider_t_evento_ar.dart';
// import 'package:inka_challenge/provider/provider_t_empleado.dart';
import 'package:inka_challenge/utils/parse_bool.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:inka_challenge/utils/decoration_form.dart';
import 'package:inka_challenge/widgets/close_page_buton.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class CheckListFormEditing extends StatefulWidget {
  const CheckListFormEditing({
    super.key,
    this.e,
  });
  final TCheckListModel? e;
  @override
  State<CheckListFormEditing> createState() => _CheckListFormEditingState();
}

class _CheckListFormEditingState extends State<CheckListFormEditing> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idEmpleadoController = TextEditingController();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _ordenController = TextEditingController();

  final TextEditingController _horaAperturaController = TextEditingController();
  final TextEditingController _horaCierreController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  final TextEditingController _idEventoController = TextEditingController();


  var title = 'NUEVO REGISTRO';
  bool valueEstadoProducto = true; //SwithAdaptative check

  String? selectedEvento;
  @override
  void initState() {
    if (widget.e != null) {
      _idEmpleadoController.text = widget.e!.id!;
      _idEventoController.text = widget.e!.idEvento;
      _nombreController.text = widget.e!.nombre;
      _descripcionController.text = widget.e!.descripcion;
      _ubicacionController.text = widget.e!.ubicacion;
      _ordenController.text = widget.e!.orden.toString();
      _horaAperturaController.text = widget.e!.horaApertura.toString();
      _horaCierreController.text = widget.e!.horaCierre.toString();
      _estadoController.text = widget.e!.estatus.toString();
      title = 'Editar Registro';
      selectedEvento = _idEventoController.text;
    } else {
      _estadoController.text = valueEstadoProducto.toString();
    }
    super.initState();
  }

  List<Widget> formularios = [];

  // String? selectedRol;
  // String? selectedSexo;
  @override
  Widget build(BuildContext context) {
    // List<String> sexo = ['Femenino', 'Masculino'];
    //EVENTO
    final eventoData = Provider.of<TEventoArProvider>(context);
    List<TEventoModel> listEvento = eventoData.listAsistencia;
    final providerEmpleados = Provider.of<TCheckListProvider>(context);
    formularios = [
      eventoForm(listEvento),
      nombreForm(),
      descripForm(),
      ubicacionForm(),
      ordenForm(),
      // contrasenaFomr(),
      _horaAperForm(context),
      _horaCierrForm(context),
      // rolForm(tipo),
      // sexoForm(sexo),

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
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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

  TextFormField _horaCierrForm(BuildContext context) {
    return TextFormField(
      // enabled: false,
      // readOnly: true, // Deshabilita la edición directa del texto
      showCursor: true, // Muestra el cursor al tocar el campo
      controller: _horaCierreController,
      decoration: decorationTextField(
          hintText: 'campo obligatorio',
          labelText: 'Hora Cierre.',
          prefixIcon:
              const Icon(Icons.calendar_month_outlined, color: Colors.black45)),
      onTap: () {
         selectDateCierre();
        print(_horaCierreController.text);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        selectDateCierre();
        print(value);
      },
    );
  }

  TextFormField _horaAperForm(BuildContext context) {
    return TextFormField(
      // enabled: false,
      readOnly: true, // Deshabilita la edición directa del texto
      showCursor: true, // Muestra el cursor al tocar el campo
      controller: _horaAperturaController,
      decoration: decorationTextField(
          hintText: 'campo obligatorio',
          labelText: 'Hora Apertura.',
          prefixIcon:
              const Icon(Icons.calendar_month_outlined, color: Colors.black45)),
      onTap: () {
       selectDateApertura();
        print(_horaAperturaController.text);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo obligatorio';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        selectDateApertura();
        print(value);
      },
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

  TextFormField ordenForm() {
    return TextFormField(
      controller: _ordenController,
      keyboardType: TextInputType.number,
      maxLength: 2,
      inputFormatters: [
        //Expresion Regular
        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
      ],
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Orden.',
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Campo obligatorio';
        }
        // if (value!.length < 8) {
        //   return 'Ingrese 8 digitos';
        // }
        return null;
      },
    );
  }

  TextFormField ubicacionForm() {
    return TextFormField(
      controller: _ubicacionController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Ubicación.',
      ),
    );
  }

  TextFormField descripForm() {
    return TextFormField(
      controller: _descripcionController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Descripción.',
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

  DropdownButtonFormField<String> eventoForm(List<TEventoModel> listEvento) {
    return DropdownButtonFormField<String>(
      decoration: decorationTextField(
        hintText: 'Selecciona el Evento',
        labelText: 'Evento',
      ),
      value: selectedEvento,
      onChanged: (String? newValue) async {
        setState(() {
          selectedEvento = newValue;
        });
        print(newValue);
        _idEventoController.text = newValue!;
      },
      items: listEvento.map((TEventoModel e) {
        return DropdownMenuItem<String>(
          value: e.id,
          child: Row(
            children: <Widget>[
              H2Text(
                text: e.nombre,
                fontSize: 12,
              )
            ],
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obligatorio';
        } else {
          return null;
        }
      },
    );
  }

  Future<void> editarDatos() async {
    await context.read<TCheckListProvider>().updateTUbicacionesProvider(
          id: widget.e!.id,
          idEvento: _idEventoController.text,
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          ubicacion: _ubicacionController.text,
          orden: int.parse(_ordenController.text),
          horaApertura: DateTime.parse(_horaAperturaController.text),
          horaCierre: DateTime.parse(_horaCierreController.text),
          estatus: parseBool(_estadoController.text),
        );
    snackBarButon('✅ Registro editado correctamente.');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TCheckListProvider>().postTUbicacionesProvider(
          //  id: id,
          idEvento: _idEventoController.text,
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          ubicacion: _ubicacionController.text,
          orden: int.parse(_ordenController.text),
          horaApertura: DateTime.parse(_horaAperturaController.text),
          horaCierre: DateTime.parse(_horaCierreController.text),
          estatus: parseBool(_estadoController.text),
        );
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
    _descripcionController.clear();
    _ubicacionController.clear();
    _horaAperturaController.clear();
    _ordenController.clear();
    _idEventoController.clear();
    _horaCierreController.clear();
  }

 
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

  void selectDateApertura() async {
  DateTime? selectedDate = await showOmniDateTimePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
    lastDate: DateTime.now().add(const Duration(days: 3652)),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: 1,
    secondsInterval: 1,
    isForce2Digits: true,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    constraints: const BoxConstraints(
      maxWidth: 350,
      maxHeight: 650,
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(
          Tween(
            begin: 0,
            end: 1,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    selectableDayPredicate: (dateTime) {
      // Disable 25th Feb 2023
      if (dateTime == DateTime(2023, 2, 25)) {
        return false;
      } else {
        return true;
      }
    },
  );

  if (selectedDate != null) {
    setState(() {
      _horaAperturaController.text = selectedDate.toString() ;//_formatDate(selectedDate) + ' ' + _formatTime(selectedDate);
      print('APERTURA: ${_horaAperturaController.text}');
    });
  }
}

void selectDateCierre() async {
  DateTime? selectedDate = await showOmniDateTimePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
    lastDate: DateTime.now().add(const Duration(days: 3652)),
    is24HourMode: false,
    isShowSeconds: false,
    minutesInterval: 1,
    secondsInterval: 1,
    isForce2Digits: true,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    constraints: const BoxConstraints(
      maxWidth: 350,
      maxHeight: 650,
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1.drive(
          Tween(
            begin: 0,
            end: 1,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    selectableDayPredicate: (dateTime) {
      // Disable 25th Feb 2023
      if (dateTime == DateTime(2023, 2, 25)) {
        return false;
      } else {
        return true;
      }
    },
  );

  if (selectedDate != null) {
    setState(() {
      _horaCierreController.text = selectedDate.toString();//_formatDate(selectedDate) + ' ' + _formatTime(selectedDate);
      print('CIERRE : ${_horaCierreController.text}');
      print(DateTime.now());
    });
  }
}


}
