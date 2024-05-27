import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/page_admin/t_empleado_details_page.dart';
import 'package:inka_challenge/page_admin/t_empleado_editing_page.dart';
import 'package:inka_challenge/provider/provider_t_empleado.dart';
import 'package:inka_challenge/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/widgets/close_page_buton.dart';
import 'package:provider/provider.dart';

class EmpleadosFormPage extends StatefulWidget {
  const EmpleadosFormPage({
    super.key,
  });

  @override
  State<EmpleadosFormPage> createState() => _EmpleadosFormPageState();
}

class _EmpleadosFormPageState extends State<EmpleadosFormPage> {
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
    final listaEmpleados =
        Provider.of<TEmpleadoProvider>(context).listaEmpleados
          ..sort(
            (a, b) => a.nombre.compareTo(b.nombre),
          );
    return Scaffold(
      appBar: AppBar(
        leading: const ClosePageButon(),
        title: const H2Text(
          text: 'USUARIOS',
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
                        builder: (context) => const EmpleadosFormEditing()));
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
                        content: DetailsEmpleadosWidget(
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
            cellCutom('usuario'),
            cellCutom('Cédula'),
            cellCutom('Rol'),
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

  final TEmpleadoModel e;

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
                          builder: (context) => EmpleadosFormEditing(
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
                text: '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno}',
                fontSize: 13,
                textAlign: TextAlign.center,
              ),
            ),
            TableCell(
              child: H2Text(
                text: e.cedula.toString(),
                fontSize: 13,
                textAlign: TextAlign.center,
              ),
            ),
            TableCell(
              child: Column(
                children: [
                  H2Text(
                    text: e.estado ? 'Activo' : 'Inactivo',
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    textAlign: TextAlign.center,
                  ),
                  H2Text(
                    text: e.rol,
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
                    .read<TEmpleadoProvider>()
                    .deleteTEmpeladoProvider(e.id!);
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
