// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:inka_challenge/model/model_v_tabla_participantes.dart';
import 'package:inka_challenge/model/provider_config_carrera.dart';
import 'package:inka_challenge/model/provider_v_tabla_participantes.dart';
import 'package:inka_challenge/page/widget_table_data_runner.dart';
import 'package:inka_challenge/page/widget_table_dropdown.dart';
import 'package:inka_challenge/page/widget_table_runners.dart';
import 'package:inka_challenge/utils/buton_style.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class PageTablaRunners extends StatelessWidget {
  const PageTablaRunners({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataParticipantes =
        Provider.of<VTablaParticipantesProvider>(context).listaParticipantes;

    return DataPage(
      dataParticipantes: dataParticipantes,
    );
  }
}

class DataPage extends StatefulWidget {
  const DataPage({Key? key, required this.dataParticipantes}) : super(key: key);

  final List<VTablaPartipantesModel> dataParticipantes;
  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;

  //PAGINACION
  final List<int> _perPages = [5, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 5;
  List<bool>? _expanded;

  int _currentPage = 1;
  bool _isSearch = false;
  final List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  final bool _showSelect = true;

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(generateData(widget
          .dataParticipantes)); //GENERATE DATA esta como un widget que proporciona la data.
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;

      int endRange = min(_currentPerPage!, _total);
      _source = _sourceFiltered.getRange(0, endRange).toList();
      setState(() => _isLoading = false);
    });
  }

//FLECHAS PAGINACION y SLECCIONAR CANITDAD DE DATOS MOSTRAR
  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage!;
    Future.delayed(const Duration(seconds: 1)).then((value) {
      _expanded = List.generate(expandedLen as int, (index) => false);
      _source.clear();
      var endRange = start + expandedLen;
      endRange = endRange > _total ? _total : endRange;
      _source = _sourceFiltered.getRange(start, endRange).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) =>
                data['dorsal']
                    .toString()
                    .toLowerCase()
                    .contains(value.toString().toLowerCase()) ||
                data["nombre"]
                    .toString()
                    .toLowerCase()
                    .contains(value.toString().toLowerCase()) ||
                data["distancias"]
                    .toString()
                    .toLowerCase()
                    .contains(value.toString().toLowerCase()))
            .toList();
      }

      //Calculo de la Paginanacion
      _total = _sourceFiltered.length;
      var rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
   

    super.initState();

    //MOSTRAR los Emcabezados de RESPONSIVE DATA TABLE 
    _headers = [
      dataHeaderCustom(header: 'Distancia', value: 'distancias'),
      dataHeaderCustom(header: 'Nombre', value: 'nombre'),

      dataHeaderCustom(header: 'Dorsal', value: 'dorsal'),
      dataHeaderCustom(header: 'Partida', value: 'partida_time'),
      dataHeaderCustom(header: 'Meta', value: 'meta_time'),
      dataHeaderCustom(header: 'Acumulado', value: 'tiempo_acumulado'),
      // dataHeaderCustom(header: 'Estado', value: 'meta'),
      dtaHeaderListProgress(),
    ];
     //CARGAR LA LISTA DEL EVENTO LLAMNDO AL APIREST
    final eventoPref  = Provider.of<EventIdProvider>(context, listen: false).eventoPref;
    final dataProvioder = Provider.of<VTablaParticipantesProvider>(context, listen: false);
    dataProvioder.getIdEvento(eventoPref);
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dataProvioder = Provider.of<VTablaParticipantesProvider>(context);
    final dataEvento  = Provider.of<EventIdProvider>(context);
    return Scaffold(
      body: ScrollWeb(
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
              SafeArea(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: size.height * .9,
                  ),
                  child: ResponsiveDatatable(
                    title: Row(
                      children: [
                        IconButton(
                          style: buttonStyle2(),
                          onPressed: dataProvioder.isSyncing
                              ? null
                              : ()async  {
                                  // _initializeData;
                                  //Refrescar Pagina
                                  _mockPullData();
                                  dataProvioder.actualizarDatosDesdeServidor(dataEvento.eventoPref);

                                },
                          icon: dataProvioder.isSyncing
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(
                                  Icons.refresh_sharp,
                                  color: Colors.white,
                                ),
                          tooltip: 'Actualizar tabla',
                          mouseCursor: MouseCursor.defer,
                        ),
                        IconButton(
                          style: buttonStyle2(),
                          tooltip: 'Imprimir datos',
                          onPressed: () => {},
                          icon: const Icon(
                            Icons.print,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    reponseScreenSizes: const [
                      ScreenSize.xs,
                    ],
                    // commonMobileView: true,//VISTA de DETALlES EN RESPONSIVE
                    headerDecoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF333333),
                          Color(0xFF525252),
                          Color(0xFF8B0000),
                        ],
                      ),
                    ),
                    rowDecoration: const BoxDecoration(
                        // color: (_rowCount++ % 2 == 0) ? Colors.black12 : Colors.transparent,
                        border: Border(
                            bottom: BorderSide(
                                width: 3, color: Color(0x1FB9B4B4)))),
                    selectedDecoration:
                        const BoxDecoration(color: Color(0x1FACABAB)),
                    actions: [
                      if (_isSearch)
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Escriba aquí para buscar',
                              prefixIcon: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      _isSearch = false;
                                    });
                                    _initializeData();
                                  }),
                              suffixIcon: IconButton(
                                  tooltip: 'Buscar',
                                  icon: const Icon(Icons.search),
                                  onPressed: () {})),
                          onSubmitted: (value) {
                            _filterData(value);
                          },
                        )),
                      if (!_isSearch)
                        IconButton(
                            style: buttonStyle2(),
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSearch = true;
                              });
                            }),
                    ],
                    headers: _headers,
                    source: _source,
                    selecteds: _selecteds,
                    showSelect: _showSelect,
                    autoHeight: false,
                    dropContainer: (data) {
                      print(data);
                      print('dropContainer');
                      return DropDownContainer(e: data);//PASA TODA LA DATA 
                    },
                    onSort: (value) {
                      setState(() => _isLoading = true);

                      setState(() {
                        _sortColumn = value;
                        _sortAscending = !_sortAscending;
                        if (_sortAscending) {
                          _sourceFiltered.sort((a, b) =>
                              b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                        } else {
                          _sourceFiltered.sort((a, b) =>
                              a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                        }
                        var rangeTop = _currentPerPage! < _sourceFiltered.length
                            ? _currentPerPage!
                            : _sourceFiltered.length;
                        _source =
                            _sourceFiltered.getRange(0, rangeTop).toList();
                        // _searchKey = value;

                        _isLoading = false;
                      });
                    },
                    expanded: _expanded,
                    sortAscending: _sortAscending,
                    sortColumn: _sortColumn,
                    isLoading: _isLoading,
                    onSelect: (value, item) {
                      print("$value  $item ");
                      if (value!) {
                        setState(() => _selecteds.add(item));
                      } else {
                        setState(() =>
                            _selecteds.removeAt(_selecteds.indexOf(item)));
                      }
                    },
                    onSelectAll: (value) {
                      if (value!) {
                        setState(() => _selecteds =
                            _source.map((entry) => entry).toList().cast());
                      } else {
                        setState(() => _selecteds.clear());
                      }
                    },
                    // footers: [

                    // ],
                    onChangedRow: (value, header) {
                      print(value);
                      print(header);
                      print('onChangedRow');
                      //Se activa al editar un campo
                    },
                    onSubmittedRow: (value, header) {
                      print(value);
                      print(header);
                      print('onSubmittedRow');
                      //Se activa al Guardar un campo
                    },
                    onTabRow: (data) {
                      print(data);
                      print('onTabRow');
                      //Se activa al presionar un campo
                    },
                  ),
                ),
              ),
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _paginatedtable(),
    );
  }

  Row _paginatedtable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const H2Text(
            text: "Filas por página:",
            fontSize: 12,
          ),
        ),
        if (_perPages.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<int>(
              value: _currentPerPage,
              items: _perPages
                  .map((e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text("$e"),
                      ))
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _currentPerPage = value;
                  _currentPage = 1;
                  _resetData();
                });
              },
              isExpanded: false,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text("$_currentPage - $_currentPerPage of $_total"),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: _currentPage == 1
              ? null
              : () {
                  var nextSet0 = _currentPage - _currentPerPage!;
                  setState(() {
                    _currentPage = nextSet0 > 1 ? nextSet0 : 1;
                    _resetData(start: _currentPage - 1);
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentPage + _currentPerPage! - 1 > _total
              ? null
              : () {
                  var nextSet = _currentPage + _currentPerPage!;

                  setState(() {
                    _currentPage =
                        nextSet < _total ? nextSet : _total - _currentPerPage!;
                    _resetData(start: nextSet - 1);
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ],
    );
  }
}
