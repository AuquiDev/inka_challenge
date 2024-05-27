// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:inka_challenge/model/model_distancias_ar.dart';
import 'package:inka_challenge/model/model_runners_ar.dart';
import 'package:inka_challenge/pages3/qr_generate_runners.dart';
import 'package:inka_challenge/pages3/t_runner_details.dart';
import 'package:inka_challenge/pages3/t_pdf_export_asistencias.dart';
import 'package:inka_challenge/pages3/t_runners_editing.dart';
import 'package:inka_challenge/provider/provider_t_distancias_ar.dart';
import 'package:inka_challenge/provider/provider_t_runners_ar.dart';

import 'package:inka_challenge/utils/buton_style.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:inka_challenge/utils/decoration_form.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ListRunners extends StatefulWidget {
  const ListRunners({
    super.key,
    required this.listAsitencia,
  });
  final List<TRunnersModel> listAsitencia;
  @override
  State<ListRunners> createState() => _ListRunnersState();
}

class _ListRunnersState extends State<ListRunners> {
  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;

  void _onScroll() {
    //devulve el valor del scrollDirection.
    setState(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //Scroll Abajo
        showAppBar = true;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //Scroll Arriba
        showAppBar = false;
      }
    });
  }

  //FILTRAR NombreAsistencia logica del Buscador en botones
  late List<TRunnersModel> filterTidEmpleado;

  //Le tenemos que pasar como parametro el id de trabajo, para filtrado por grupo
  _filterTEmpleados(String searchText) {
    filterTidEmpleado = widget.listAsitencia
        .where((e) => e.idDistancia.contains(searchText))
        .toList();
  }

  //FILTRAMOS lal ogica del buscador de producto en base a lista filtrada de ubicacion
  late TextEditingController _searchTextEditingController;
  late List<TRunnersModel> filterTProductos;
  _filterTEntradas(String seachText) {
    setState(() {
      filterTProductos = filterTidEmpleado
          .where((e) =>
              e.nombre.toLowerCase().contains(seachText.toLowerCase()) ||
              e.apellidos.toLowerCase().contains(seachText.toLowerCase()) ||
              e.pais.toLowerCase().contains(seachText.toLowerCase()) ||
              e.genero.toLowerCase().contains(seachText.toLowerCase()) ||
              e.tallaDePolo.toLowerCase().contains(seachText.toLowerCase()) ||
              e.dorsal.toLowerCase().contains(seachText.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    filterTidEmpleado = widget.listAsitencia;
    _searchTextEditingController = TextEditingController();
    filterTProductos = filterTidEmpleado;
    super.initState();
    //Scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  //TEXTO nombre de ubicacion segun el boton se asigna el valor al titulo de ubicacion
  String tituloEmpleado = 'Full';

  @override
  Widget build(BuildContext context) {
    //LISTA GRUPOS ALMACÉN
    final listatrabajoApi =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    List<TDistanciasModel> listaDetallTrabajo = listatrabajoApi;

    listaDetallTrabajo.sort((a, b) => a.distancias.compareTo(b.distancias));

    final isavingProvider = Provider.of<TRunnersProvider>(context).isSyncing;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          showAppBar
              ? DelayedDisplay(
                  slidingBeginOffset: const Offset(0.0, -0.35),
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: H1Text(
                          text: 'Corredores'.toUpperCase(),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                        trailing: Column(
                          children: [
                            H2Text(
                              text: '$tituloEmpleado ',
                              fontSize: 18,
                              // color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            H2Text(
                              text: '#${filterTProductos.length}',
                              fontSize: 13,
                            ),
                          ],
                        ),
                        leading: Card(
                          color: const Color(0xFF11B816),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RunnersFormEditing()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: H2Text(
                                text: 'Nuevo',
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ScrollWeb(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listaDetallTrabajo.length,
                            itemBuilder: (BuildContext context, int index) {
                              final e =
                                  listaDetallTrabajo.reversed.toList()[index];

                              return Card(
                                child: TextButton(
                                    onPressed: () {
                                      _filterTEmpleados(e.id.toString());
                                      _filterTEntradas('');
                                      tituloEmpleado = e.distancias;
                                    },
                                    child: H2Text(
                                      text: e.distancias,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    )),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          isavingProvider
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.black,
                ))
              : Flexible(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              style: buttonStyle(),
                              onPressed: () {
                                _filterTEmpleados('');
                                _filterTEntradas('');
                                tituloEmpleado = 'Full';
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 15),
                                child: H2Text(
                                  text: 'General'.toUpperCase(),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          PDFExportAsistencia(
                              listaCorrdores: filterTProductos
                                ..sort((a, b) => a.nombre.compareTo(b.nombre)),
                              tituloEmpleado: tituloEmpleado),
                          Container(
                            height: 60,
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Card(
                              child: TextField(
                                  controller: _searchTextEditingController,
                                  onChanged: (value) {
                                    _filterTEntradas(value);
                                  },
                                  decoration: decorationTextField(
                                    hintText: 'Escribe el nombre o el dorsal',
                                    labelText: 'buscar',
                                    prefixIcon: IconButton(
                                        onPressed: () {
                                          _searchTextEditingController.clear();
                                          _filterTEntradas('');
                                        },
                                        icon: _searchTextEditingController
                                                .text.isEmpty
                                            ? const Icon(Icons.search)
                                            : const Icon(Icons.close)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      ListTAsistencias(
                        listaTproductos: filterTProductos,
                        scrollController: _scrollController,
                        showAppBar: showAppBar,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class ListTAsistencias extends StatefulWidget {
  const ListTAsistencias({
    super.key,
    required this.listaTproductos,
    required ScrollController scrollController,
    required this.showAppBar,
  }) : _scrollController = scrollController;
  final List<TRunnersModel> listaTproductos;
  final ScrollController _scrollController;
  final bool showAppBar;

  @override
  State<ListTAsistencias> createState() => _ListTAsistenciasState();
}

class _ListTAsistenciasState extends State<ListTAsistencias> {
  late ExpandedTileController _controller;
  @override
  void initState() {
    _controller = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //FILTRADO Por fecha de creacion. agrupoar por mes y año
    Map<dynamic, List<TRunnersModel>> paisFilter = {};

    for (var e in widget.listaTproductos) {
      String keyPais = e.pais;

      if (!paisFilter.containsKey(keyPais)) {
        paisFilter[keyPais] = [];
      }
      paisFilter[keyPais]!.add(e);
    }

    // ORDEN ASCENDENTE: Convertir el Map a una Lista Ordenada por la clave (fecha)
    List<dynamic> sortedKeys = paisFilter.keys.toList()
      ..sort(
        (a, b) => a.compareTo(b),
      );

    final listaGrupoAPi =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    List<TDistanciasModel> listaGrupos = listaGrupoAPi;
    return Expanded(
      child: ScrollWeb(
        child: ListView.builder(
            controller: widget._scrollController,
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final paisKey = sortedKeys[index];
              final subLista = paisFilter[paisKey];

              //ORDENAR LA SUBLISTA
              subLista!.sort((a, b) => a.nombre.compareTo(b.nombre));

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        H2Text(
                            text: paisKey.toString().toUpperCase(),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.redAccent),
                        const VerticalDivider(),
                        H2Text(
                            text: '#${subLista.length}',
                            fontSize: 12,
                            color: Colors.red),
                      ],
                    ),
                  ),
                  if (subLista.isNotEmpty)
                    ExpandedTileList.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subLista.length,
                      itemBuilder: (context, index, controller) {
                        final e = subLista.reversed.toList()[index];
                        String obtenerDetalleTrabajo(String idTrabajo) {
                          for (var data in listaGrupos) {
                            if (data.id == idTrabajo) {
                              return data.distancias;
                            }
                          }
                          return 'null';
                        }

                        final codigo = obtenerDetalleTrabajo(e.idDistancia);

                        Color color = index % 2 == 0
                            ? const Color(0xFFEFE9E9)
                            : Colors.grey.withOpacity(.1);

                        return ExpandedTile(
                          expansionAnimationCurve: Curves.easeInOut,
                          theme: ExpandedTileThemeData(
                              headerColor: color,
                              headerRadius: 0.0,
                              headerPadding: const EdgeInsets.all(3.0),
                              headerSplashColor: Colors.white,
                              contentBackgroundColor: Colors.white,
                              contentPadding: const EdgeInsets.all(.0),
                              contentRadius: .0,
                              trailingPadding:
                                  const EdgeInsets.symmetric(horizontal: 0)),
                          contentseparator: 0,
                          controller: _controller,
                          title: DelayedDisplay(
                            delay: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                Table(
                                  children: [
                                    if (index == 0) tableHeader(),
                                    TableRow(children: [
                                      // cellCutomRow(e.dorsal),
                                      TableCell(
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RunnersFormEditing(
                                                          e: e,
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: IconButton(
                                            onPressed: () {
                                              _mostrarDialogoConfirmacion(
                                                  context, e);
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Color(0xFFAB3D35))),
                                      ),
                                      cellCutomRow(
                                          '${e.nombre} ${e.apellidos}'),
                                      // cellCutomRow(e.pais),
                                      cellCutomRow(e.genero),
                                      cellCutomRow(e.tallaDePolo),
                                      cellCutomRow(e.telefono),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: H2Text(
                                            text: codigo,
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ),
                          ),
                          content: Row(
                            children: [
                              Expanded(child:  DetailsRunners(e: e),),
                              PageQrGenerateRunner(e: e,)
                            ],
                          )
                         
                        );
                      },
                    ),
                ],
              );
            }),
      ),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context, TRunnersModel e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este elemento?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                context.read<TRunnersProvider>().deleteTAsistenciaApp(e.id!);
                _eliminarElemento(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _eliminarElemento(BuildContext context) {
    // Mostrar SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Elemento eliminado correctamente"),
      ),
    );

    Navigator.of(context).pop();
  }

  TableRow tableHeader() {
    return TableRow(
        decoration: const BoxDecoration(color: Colors.transparent),
        children: [
          cellCutom('DORSAL'),
          cellCutom('NOMBRE'),
          cellCutom('PAIS'),
          cellCutom('GENERO'),
          cellCutom('TALLA POLO'),
          cellCutom('TELEFONO'),
          cellCutom('DISTANCIA'),
        ]);
  }

  TableCell cellCutom(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: H2Text(
          text: text.toUpperCase(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TableCell cellCutomRow(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: H2Text(
          text: text,
          fontSize: 13,
          color: Colors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
