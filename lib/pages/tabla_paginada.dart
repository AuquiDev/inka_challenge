// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:inka_challenge/models/model_t_productos_app.dart';
import 'package:inka_challenge/models/model_t_proveedor.dart';
import 'package:inka_challenge/pages/tabla_source.dart';
import 'package:inka_challenge/pages2/t_ubicaciones_page.dart';
import 'package:inka_challenge/provider/provider_t_proveedorapp.dart';
import 'package:inka_challenge/utils/buton_style.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:inka_challenge/utils/decoration_form.dart';
import 'package:inka_challenge/utils/format_fecha.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlmacenGestionPage extends StatelessWidget {
  const AlmacenGestionPage(
      {super.key,
      required this.listaTproductos,
      required this.updateStateProducto,
      required this.title,
      required this.currentCategory,
      required ScrollController scrollController,
      required this.showAppBar})
      : _scrollController = scrollController;
  final List<TProductosAppModel> listaTproductos;
  final VoidCallback updateStateProducto;
  final String title;
  final String currentCategory;
  final ScrollController _scrollController;
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return ListTempralTableState(
      inventario: listaTproductos,
      updateStateProducto: updateStateProducto,
      title: title,
      currentCategory: currentCategory,
      scrollController: _scrollController,
      showAppBar: showAppBar,
    );
  }
}

class ListTempralTableState extends StatefulWidget {
  const ListTempralTableState(
      {super.key,
      required this.inventario,
      required this.updateStateProducto,
      required this.title,
      required this.currentCategory,
      required ScrollController scrollController,
      required this.showAppBar})
      : _scrollController = scrollController;
  final List<TProductosAppModel> inventario;
  final VoidCallback updateStateProducto;
  final String title;
  final String currentCategory;
  final ScrollController _scrollController;
  final bool showAppBar;
  @override
  State<ListTempralTableState> createState() => _ListTempralTableStateState();
}

class _ListTempralTableStateState extends State<ListTempralTableState> {
  // //VARIBLE que pemrite visulaizar el campo de buscador
  // bool isvisibleSeachField = false;
  // //VARIABLE que permite visualizar el formulario
  // bool isVisibleFormEditing = false;

  int indexcopy = 0;

  //PRODUCTOS BUSCAR
  // Creamos un Buscador de datos en la tabla
  late TextEditingController _searchControllerProductos;
  late List<TProductosAppModel> filterListacompraProductos;

  bool isClear = false;
  //MOTOR DE BUSQUEDA DE PRODUCTOS DE LA TABLA
  _filterProductCompraProductos(String searchtext) {
    setState(() {
      filterListacompraProductos = widget.inventario
          .where((e) =>
              e.id.toLowerCase().contains(searchtext.toLowerCase()) ||
              e.nombreProducto
                  .toLowerCase()
                  .contains(searchtext.toLowerCase()) ||
              e.unidMedida.toLowerCase().contains(searchtext.toLowerCase()) ||
              e.marcaProducto
                  .toLowerCase()
                  .contains(searchtext.toLowerCase()) ||
              e.tipoProducto.toLowerCase().contains(searchtext.toLowerCase()) ||
              e.fechaVencimiento
                  .toString()
                  .toLowerCase()
                  .contains(searchtext.toLowerCase()) ||
              e.idProveedor.toLowerCase().contains(searchtext.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    //PRODUCTOS FILTER
    filterListacompraProductos = widget.inventario;
    _searchControllerProductos =
        TextEditingController(); //Inicializamos el buscador en campo de busqueda

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //PAGINACION de tabla, mostrarl os datos
  List<int> rowsPerPageOptions = [
    10,
    15,
    20,
    25,
    30,
    40,
    50,
  ];

  int selectedRowsPerPage = 10; // Valor predeterminado inicial

  @override
  Widget build(BuildContext context) {
  
    //PROVEEDOR
    final listaProveedor =
        Provider.of<TProveedorProvider>(context).listaProveedor;

    //FILTRADO Por fecha de Vencimiento. agrupoar por mes y año
    Map<dynamic, List<TProductosAppModel>> fechaFilter = {};

    widget.inventario.forEach((e) {
      String keyFecha =
          '${e.fechaVencimiento.year}-${e.fechaVencimiento.month.toString().padLeft(2, '0')}';

      if (!fechaFilter.containsKey(keyFecha)) {
        fechaFilter[keyFecha] = [];
      }
      fechaFilter[keyFecha]!.add(e);
    });

    // ORDEN ASCENDENTE: Convertir el Map a una Lista Ordenada por la clave (fecha)
    List<dynamic> sortkeyDate = fechaFilter.keys.toList()..sort();

    //FILTRAR por PROVEEDOR
    Map<String, List<TProductosAppModel>> proveedorFilter = {};
    widget.inventario.forEach((e) {
      if (!proveedorFilter.containsKey(e.idProveedor)) {
        proveedorFilter[e.idProveedor] = [];
      }
      proveedorFilter[e.idProveedor]!.add(e);
    });
    //ORDENAMIENTO PROVEEDOR
    List<dynamic> sortedKeyProveedor = proveedorFilter.keys.toList()..sort();

   
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //PROVEEDOR FILTER
                Expanded(
                    flex: 1,
                    child: _proveedorFilter(context, sortedKeyProveedor,
                        proveedorFilter, listaProveedor)),
                //FECHAVENCIMIENTO FILTER
                Expanded(
                    flex: 1,
                    child: _fechaVenciFilter(sortkeyDate, fechaFilter)),
              ],
            ),
            Expanded(
              child: ScrollWeb(
                child: Row(
                  children: [
                    Flexible(
                      child: ListView(
                        controller: widget._scrollController,
                        children: [
                          PaginatedDataTable(
                            header: TextField(
                              onChanged: (value) {
                                _filterProductCompraProductos(value);
                              },
                              controller: _searchControllerProductos,
                              decoration: decorationTextField(
                                  hintText: 'Escribe algo.',
                                  labelText: 'buscar..',
                                  prefixIcon: _searchControllerProductos
                                          .text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _searchControllerProductos
                                                  .text = '';
                                              _filterProductCompraProductos(
                                                  _searchControllerProductos
                                                      .text);
                                            });
                                          },
                                          icon: const Icon(Icons.clear))
                                      : const Icon(
                                          Icons.search,
                                        )),
                            ),
                            actions: [
                             
                             
                              rowStateColor(),

                              //FILTRADOPAGE : filtra datos por pagina
                              numberRowPaginated(),
                            ],
                            // dataRowHeight: 40, // Altura de las filas de datos
                            // Altura de la fila de encabezado
                            headingRowHeight: 50,
                            horizontalMargin: 10, // Margen horizontal
                            columnSpacing: 5, // Espacio entre columnas
                            // Mostrar columna de casilla de verificación
                            showCheckboxColumn: true,
                            // Mostrar botones de primera/última página
                            showFirstLastButtons: true,
                            // Índice de la primera fila visible inicialmente
                            initialFirstRowIndex: 0,
                            // Comportamiento del arrastre
                            dragStartBehavior: DragStartBehavior.start,
                            // Margen horizontal de la casilla de verificación
                            checkboxHorizontalMargin: 10,
                            // Orden ascendente o descendente
                            sortAscending: false,
                            // Marcar como primario si es el Widget superior en la jerarquía
                            primary: true,
                            // Número de filas por página
                            rowsPerPage: selectedRowsPerPage,
                            columns: listColumn,
                            source: SourceDatatable(
                              // listaCompraProvider: listaCompraProvider,
                              context: context,
                              indexcopy: indexcopy,
                              // updateParentState: updateState,
                              filterListacompra: filterListacompraProductos,
                              // psetState: psetState
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _proveedorFilter(
      BuildContext context,
      List<dynamic> sortedKeyProveedor,
      Map<String, List<TProductosAppModel>> proveedorFilter,
      List<TProveedorModel> listaProveedor) {
    return Column(
      children: [
        const H2Text(
          text: 'FILTRAR POR PROVEEDOR',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                child: const Column(
                  children: [
                    Icon(
                      Icons.add_circle_sharp,
                      size: 20,
                      color: Colors.blue,
                    ),
                    H2Text(
                      text: 'Provedor',
                      fontSize: 12,
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TPageUbicaciones()));
                },
              ),
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () async {
                    _filterProductCompraProductos('');
                  },
                  child: const H2Text(
                    text: 'General',
                    fontSize: 12,
                  )),
              ...List.generate(sortedKeyProveedor.length, (index) {
                final e = sortedKeyProveedor[index];
                //SUBLISTA
                final subList = proveedorFilter[e];
                String obtenerCategoria(String idCategoria) {
                  for (var data in listaProveedor) {
                    if (data.id == idCategoria) {
                      return data.nombreContactoProveedor;
                    }
                  }
                  return 'null';
                }

                String proveedor = obtenerCategoria(e);
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: TextButton(
                      style: buttonStyle(),
                      onPressed: () async {
                        if (e != '') {
                          _filterProductCompraProductos(e);
                        } else if (subList.isNotEmpty) {
                          _filterProductCompraProductos(subList[0].id);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H2Text(
                              text: (proveedor),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            H2Text(
                              text: '#${subList!.length}',
                              fontSize: 12,
                            ),
                          ],
                        ),
                      )),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Column _fechaVenciFilter(List<dynamic> sortkeyDate,
      Map<dynamic, List<TProductosAppModel>> fechaFilter) {
    return Column(
      children: [
        const H2Text(
          text: 'FILTRAR POR FECHE Venc.',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () async {
                    _filterProductCompraProductos('');
                  },
                  child: const H2Text(
                    text: 'General',
                    fontSize: 12,
                    maxLines: 2,
                  )),
              const VerticalDivider(),
              ...List.generate(sortkeyDate.length, (index) {
                final fechaKey = sortkeyDate[index];
                //subLista
                final productoPorfechaV = fechaFilter[fechaKey];
                //ORDENAR LA SUBLISTA
                productoPorfechaV!.sort(
                    (a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));
                DateTime fechaDateTime = DateTime.parse('$fechaKey-01');
                return ElevatedButton(
                    style: buttonStyle(),
                    onPressed: () async {
                      _filterProductCompraProductos(fechaKey);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          H2Text(
                            text: fechaFiltrada(fechaDateTime),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          H2Text(
                            text: '#${productoPorfechaV.length}',
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ));
              }),
            ],
          ),
        ),
      ],
    );
  }

  DropdownButton<int> numberRowPaginated() {
    return DropdownButton<int>(
      iconSize: 30,
      elevation: 40,
      value: selectedRowsPerPage,
      onChanged: (newValue) {
        setState(() {
          selectedRowsPerPage = newValue!;
        });
      },
      items: rowsPerPageOptions.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget rowStateColor() {
    final size = MediaQuery.of(context).size;

    return size.width > 1200
        ? Row(
            children: [
              _stateIndicator(color: Colors.red, text: 'Agotado\nVencido'),
              _stateIndicator(
                  color: Colors.blue, text: 'menor a 10\nF.V. próxima'),
            ],
          )
        : const SizedBox();
  }

  TextButton _stateIndicator({Color? color, String? text}) {
    return TextButton.icon(
        onPressed: null,
        icon: Icon(
          Icons.circle,
          color: color,
        ),
        label: H2Text(
          text: text!,
          fontSize: 10,
          maxLines: 3,
        ));
  }
}



List<DataColumn> listColumn = [
  DataColumn(
      label: H2Text(
    text: 'Image'.toUpperCase(),
    fontSize: 11,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Producto'.toUpperCase(),
    fontSize: 11,
    color: Colors.black,
  )),
  DataColumn(
      label: H2Text(
    text: 'Stock'.toUpperCase(),
    fontSize: 11,
    color: Colors.black,
  )),
  DataColumn(
      label: TextButton.icon(
          onPressed: null,
          label: const H2Text(
            text: 'F.V',
            fontSize: 11,
          ),
          icon: const Icon(Icons.calendar_month))),
  const DataColumn(
      label: H2Text(
    text: '',
    fontSize: 11,
    color: Colors.black,
  )),
];
