// ignore_for_file: avoid_print

import 'dart:async';
// import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:inka_challenge/model/model_distancias_ar.dart';
import 'package:inka_challenge/model/model_evento.dart';
import 'package:inka_challenge/model/model_runners_ar.dart';
import 'package:inka_challenge/provider/provider_t_distancias_ar.dart';
import 'package:inka_challenge/provider/provider_t_evento_ar.dart';
import 'package:inka_challenge/provider/provider_t_runners_ar.dart';
// import 'package:inka_challenge/provider/provider_t_empleado.dart';
import 'package:inka_challenge/utils/parse_bool.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:inka_challenge/utils/decoration_form.dart';
import 'package:inka_challenge/widgets/close_page_buton.dart';
import 'package:provider/provider.dart';

class RunnersFormEditing extends StatefulWidget {
  const RunnersFormEditing({
    super.key,
    this.e,
  });
  final TRunnersModel? e;
  @override
  State<RunnersFormEditing> createState() => _RunnersFormEditingState();
}

class _RunnersFormEditingState extends State<RunnersFormEditing> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idRunnerController = TextEditingController();
  final TextEditingController _idEventoController = TextEditingController();
  final TextEditingController _idDistanciaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dorsalController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();

  final TextEditingController _cedulaController = TextEditingController();

  final TextEditingController _tallaController = TextEditingController();

  var title = 'NUEVO CORREDOR';
  bool valueEstadoProducto = true; //SwithAdaptative check
  bool isVisible = true; //contraseña
  String rolPuesto = '';

  @override
  void initState() {
    if (widget.e != null) {
      _idRunnerController.text = widget.e!.id!;
      _idEventoController.text = widget.e!.idEvento;
      _idDistanciaController.text = widget.e!.idDistancia;

      _nombreController.text = widget.e!.nombre;
      _apellidoController.text = widget.e!.apellidos;
      _dorsalController.text = widget.e!.dorsal;
      _paisController.text = widget.e!.pais;
      _telefonoController.text = widget.e!.telefono.toString();
      _estadoController.text = widget.e!.estado.toString();

      _generoController.text = widget.e!.genero;
      _cedulaController.text = widget.e!.numeroDeDocumentos.toString();

      _tallaController.text = widget.e!.tallaDePolo;

      title = 'Editar Registro';
    } else {
      _estadoController.text = valueEstadoProducto.toString();
    }
    super.initState();
  }

  List<Widget> formularios = [];

  String? selectedTallaPolo;
  String? selectedSexo;
  String? selectedEvento;
  String? selectedDistancia;
  @override
  Widget build(BuildContext context) {
    List<String> tipo = [
      'XS (Extra Small)',
      'S (Small)', 
      'M (Medium)',
      'L (Large)',
      'XL (Extra Large)'
    ];
    List<String> sexo = ['Femenino', 'Masculino'];
    final providerEmpleados = Provider.of<TRunnersProvider>(context);
    //EVENTO
    final eventoData = Provider.of<TEventoArProvider>(context);
    List<TEventoModel> listEvento = eventoData.listAsistencia;
    //DISTANCIA
    final distanData = Provider.of<TDistanciasArProvider>(context);
    List<TDistanciasModel> listDistancia = distanData.listAsistencia;

    formularios = [
      eventoForm(listEvento),
      distanciaForm(listDistancia),
      nombreForm(),
      apellido1Form(),
      dorsalForm(),

      // paisForm(),

      tallaPoloForm(tipo),
      sexoForm(sexo),
      estatusForm(),
       telefonoForm(),
      cedulaForm(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textForm(
                        evento: 'ID.EVENTO',
                        distan: 'ID.DISTN',
                        nombre: 'NOMBRE',
                        dorsal: 'DORSAL',
                        pais: 'PAIS',
                        tefl: 'TELEFONO',
                        sexo: 'SEXO',
                        talla: 'TALLA',
                        cedula: 'NRO.DOC'),
                    textForm(
                      evento: _idEventoController.text,
                      distan: _idDistanciaController.text,
                      nombre:
                          '${_nombreController.text} ${_apellidoController.text}',
                      dorsal: _dorsalController.text,
                      pais: _paisController.text,
                      tefl: _telefonoController.text,
                      sexo: _generoController.text,
                      talla: _tallaController.text,
                      cedula: _cedulaController.text,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pickerPaisForm(),
                    Card(
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calcular el número de columnas en función del ancho disponible
                    int crossAxisCount = (constraints.maxWidth / 300).floor();
                    // Puedes ajustar el valor 100 según tus necesidades
                    return ScrollWeb(
                      child: GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 3,
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

  Widget pickerPaisForm() {
    return Column(
      children: [
        const H2Text(
          text: 'Seleccione País',
          fontSize: 13,
          color: Colors.blue,
        ),
        Card(
          child: CountryCodePicker(
            initialSelection: 'PE',
            favorite: const ['+51', 'PE'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            onChanged: (CountryCode? country) {
              setState(() {});
              print(country!.code);
              _paisController.text = country.name!;
              print('Prefijo del país: ${country.dialCode}');
              _telefonoController.text = country.dialCode!;
            },
          ),
        ),
      ],
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
              //   Image.asset(
              //     e.logo!,
              //     width: 40,
              //     height: 40,
              //   ),
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

  DropdownButtonFormField<String> distanciaForm(
      List<TDistanciasModel> listEvento) {
    return DropdownButtonFormField<String>(
      decoration: decorationTextField(
        hintText: 'Selecciona distancia',
        labelText: 'Distancia',
      ),
      value: selectedDistancia,
      onChanged: (String? newValue) async {
        setState(() {
          selectedDistancia = newValue;
        });
        print(newValue);
        _idDistanciaController.text = newValue!;
      },
      items: listEvento.map((TDistanciasModel e) {
        return DropdownMenuItem<String>(
          value: e.id,
          child: Row(
            children: <Widget>[
              H2Text(
                text: e.distancias,
                fontSize: 12,
              ),
              const VerticalDivider(),
              H2Text(
                text: e.descripcion,
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

  Widget textForm({
    String? evento,
    String? distan,
    String? nombre,
    String? dorsal,
    String? pais,
    String? tefl,
    String? sexo,
    String? talla,
    String? cedula,
  }) =>
      Table(
        children: [
          TableRow(
              decoration: const BoxDecoration(color: Colors.black12),
              children: [
                H2Text(
                  text: pais!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: evento!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: distan!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: nombre!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: dorsal!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
               
                H2Text(
                  text: sexo!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: talla!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                 H2Text(
                  text: tefl!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
                H2Text(
                  text: cedula!,
                  fontSize: 13,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
              ]),
        ],
      );

  Widget estatusForm() {
    return SwitchListTile.adaptive(
      dense: true,
      title: const H2Text(
        text: 'ESTADO',
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

  DropdownButtonFormField<String> tallaPoloForm(List<String> tipo) {
    return DropdownButtonFormField<String>(
      decoration: decorationTextField(
        hintText: 'Selecciona el Talla',
        labelText: 'Talla Polo',
      ),
      value: selectedTallaPolo,
      onChanged: (String? newValue) async {
        setState(() {
          selectedTallaPolo = newValue;
          print(newValue);
        });
        _tallaController.text = selectedTallaPolo!;
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
        _generoController.text = selectedSexo!;
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

  TextFormField telefonoForm() {
    return TextFormField(
      controller: _telefonoController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Nro. Telefóno',
      ),
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
    );
  }

  TextFormField dorsalForm() {
    return TextFormField(
      controller: _dorsalController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Nro. Dorsal.',
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

  TextFormField apellido1Form() {
    return TextFormField(
      controller: _apellidoController,
      decoration: decorationTextField(
        hintText: 'campo obligatorio',
        labelText: 'Apellidos.',
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
    await context.read<TRunnersProvider>().updateTAsistenciaProvider(
          id: widget.e!.id,
          idEvento: _idEventoController.text,
          idDistancia: _idDistanciaController.text,
          nombre: _nombreController.text,
          apellidos: _apellidoController.text,
          dorsal: _dorsalController.text,
          pais: _paisController.text,
          telefono: _telefonoController.text,
          estado: parseBool(_estadoController.text),
          genero: _generoController.text,
          numeroDeDocumentos: int.parse(_cedulaController.text),
          tallaDePolo: _tallaController.text,
        );
    snackBarButon('✅ Registro editado correctamente.');
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> enviarDatos() async {
    await context.read<TRunnersProvider>().postTAsistenciaProvider(
          //  id: id,
          idEvento: _idEventoController.text,
          idDistancia: _idDistanciaController.text,

          nombre: _nombreController.text,
          apellidos: _apellidoController.text,
          dorsal: _dorsalController.text,
          pais: _paisController.text,

          telefono: _telefonoController.text,
          estado: parseBool(_estadoController.text),
          genero: _generoController.text,

          numeroDeDocumentos: int.parse(_cedulaController.text),
          tallaDePolo: _tallaController.text,
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
    _apellidoController.clear();
    _dorsalController.clear();
    _paisController.clear();
    _cedulaController.clear();
    _telefonoController.clear();
    _generoController.clear();
    _tallaController.clear();
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
}
