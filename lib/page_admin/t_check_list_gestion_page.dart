import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:inka_challenge/model/model_t_checklist.dart';
import 'package:inka_challenge/model/provider_t_checklist.dart';
import 'package:inka_challenge/page_admin/t_check_list_details_page.dart';
import 'package:inka_challenge/page_admin/t_check_list_editing_page.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/widgets/close_page_buton.dart';
import 'package:provider/provider.dart';

class CheckListFormPage extends StatefulWidget {
  const CheckListFormPage({
    super.key,
  });

  @override
  State<CheckListFormPage> createState() => _CheckListFormPageState();
}

class _CheckListFormPageState extends State<CheckListFormPage> {
  //FUNCION PARA BLOQUEAR el giro de pantalla y mantenerla en Vertical.
  late ExpandedTileController _controller;
  @override
  void initState() {
    _controller = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Bloquear la rotación de la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Solo retrato
    ]);
  }

  @override
  void dispose() {
    // Restaurar las preferencias de orientación cuando la página se destruye
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listaEmpleados = Provider.of<TCheckListProvider>(context).listUbicacion
          ..sort( (a, b) => a.orden.compareTo(b.orden),);
    return Scaffold(
      appBar: AppBar(
        leading: const ClosePageButon(),
        title: const H2Text(
          text: 'CHECK LIST',
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        actions: [
          Card(
            color: const Color(0xFF11B816),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckListFormEditing()));
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
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              tableHeader(),
              Expanded(
                child: ScrollWeb(
                  child: ExpandedTileList.builder(
                    itemCount: listaEmpleados.length,
                    itemBuilder: (context, index, controller) {
                      final e = listaEmpleados[index];
                      Color color = index % 2 == 0
                          ? Colors.black.withOpacity(.2)
                          : Colors.black.withOpacity(.1);
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
                          trailingPadding: const EdgeInsets.symmetric(horizontal: 0)
                        ),
                        contentseparator: 0,
                        controller: _controller,
                        title: CardCustomEmpleados(e: e),
                        content: DetailsCheckListWidget(
                          e: e,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpandedTile tableHeader() {
    return ExpandedTile(
      expansionAnimationCurve: Curves.easeInOut,
      theme: const ExpandedTileThemeData(
        headerColor: Colors.black,
        headerRadius: 0.0,
        headerPadding: EdgeInsets.all(1.0),
        headerSplashColor: Colors.white,
        contentBackgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(0.0),
        contentRadius: 1.0,
      ),
      controller: _controller,
      title: Table(
        children: [
          TableRow(children: [
            cellCutom('Editar'),
            cellCutom('Eliminar'),
            cellCutom('Check List'),
            // cellCutom('Cédula'),
            cellCutom('Ubicación'),
            // cellCutom('detalles'),
          ])
        ],
      ),
      content: const SizedBox(),
    );
  }

  TableCell cellCutom(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: H2Text(
          text: text.toUpperCase(),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CardCustomEmpleados extends StatelessWidget {
  const CardCustomEmpleados({
    super.key,
    required this.e,
  });

  final TCheckListModel e;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Table(
        border: TableBorder.all(
            style: BorderStyle.solid, color: Colors.black.withOpacity(.1)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            TableCell(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckListFormEditing(
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
                    _mostrarDialogoConfirmacion(context);
                  },
                  icon: const Icon(Icons.delete, color: Color(0xFFAB3D35))),
            ),
            TableCell(
              child: H2Text(
                text: '  ${e.orden})  ${e.nombre} ',
                fontSize: 13,
                textAlign: TextAlign.start,
              ),
            ),
            // TableCell(
            //   child: H2Text(
            //     text: e.descripcion.toString(),
            //     fontSize: 13,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            TableCell(
              child: Column(
                children: [
                  H2Text(
                    text: e.estatus ? 'Activo' : 'Inactivo',
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    textAlign: TextAlign.center,
                  ),
                  H2Text(
                    text: e.ubicacion,
                    fontSize: 13,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context) {
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
                context
                    .read<TCheckListProvider>()
                    .deleteTUbicacionesApp(e.id!);
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
}
