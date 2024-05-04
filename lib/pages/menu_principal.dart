import 'package:inka_challenge/login_page.dart';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/page/page_table_dashoard.dart';
import 'package:inka_challenge/provider/current_page.dart';
import 'package:inka_challenge/provider/provider_datacahe.dart';
import 'package:inka_challenge/provider/provider_t_productoapp.dart';
import 'package:inka_challenge/routes_pages/routes_pages.dart';
import 'package:inka_challenge/utils/buton_style.dart';
import 'package:inka_challenge/utils/scroll_web.dart';
import 'package:inka_challenge/shared_preferences/shared_global.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentImage =
        Provider.of<UsuarioProvider>(context).usuarioEncontrado;
    return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.zero, // Establece el radio de borde como cero
        ),
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UsuarioDate(currentImage: currentImage),
                const ButtonInicio(),
                const Expanded(child: ListaOpcionesphone()),
                const CloseSesion()
              ],
            ),
          ),
        ));
  }
}

class TextTitleMenu extends StatelessWidget {
  const TextTitleMenu({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return H2Text(text: title.toUpperCase(), color: Colors.grey, fontSize: 11);
  }
}

class ListaOpcionesphone extends StatelessWidget {
  const ListaOpcionesphone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<TProductosAppProvider>(context);
    return ScrollWeb(
      child: ListView.builder(
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final listaRoutes = routes[index];
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitleMenu(
                    title: "Carrera",
                  ),
                  CardMenuItem(
                      dataProvider: dataProvider, listaRoutes: listaRoutes),
                ],
              );
            } else if (index == 5) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitleMenu(
                    title: "Logística",
                  ),
                  CardMenuItem(
                      dataProvider: dataProvider, listaRoutes: listaRoutes),
                ],
              );
            } else if (index == 14) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitleMenu(
                    title: "Contabilidad",
                  ),
                  CardMenuItem(
                      dataProvider: dataProvider, listaRoutes: listaRoutes),
                ],
              );
            } else if (index == 17) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitleMenu(
                    title: "Gestión RRHH",
                  ),
                  CardMenuItem(
                      dataProvider: dataProvider, listaRoutes: listaRoutes),
                ],
              );
            } else {
              return CardMenuItem(
                  dataProvider: dataProvider, listaRoutes: listaRoutes);
            }
          }),
    );
  }
}

class CardMenuItem extends StatelessWidget {
  const CardMenuItem({
    super.key,
    required this.dataProvider,
    required this.listaRoutes,
  });

  final TProductosAppProvider dataProvider;
  final PageRoutes listaRoutes;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle2(),
      onPressed: () {
        dataProvider.asignarStockDesdeVistas();
        final screensize = MediaQuery.of(context).size;
        if (screensize.width > 900) {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = listaRoutes.path;
        } else {
          final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
          layoutmodel.currentPage = listaRoutes.path;
          Navigator.pop(context);
        }
        // Navigator.push(context,
        //     MaterialPageRoute(builder: ((context) => listaRoutes.path)));
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
        leading: listaRoutes.icon,
        title: H2Text(
          text: listaRoutes.title,
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ButtonInicio extends StatelessWidget {
  const ButtonInicio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle2(),
      onPressed: () {
        final layoutmodel = Provider.of<LayoutModel>(context, listen: false);
        layoutmodel.currentPage = const TablaParticipacion();
      },
      child: const ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.all(0),
        leading: Icon(
          Icons.home,
          color: Colors.white60,
        ),
        title: H2Text(
          text: "Dashoard",
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CloseSesion extends StatelessWidget {
  const CloseSesion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle2(),
      onPressed: () async {
        SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
        // Luego, llama al método setLoggedIn en esa instancia
        await sharedPrefs.logout(context);
        await SharedPrefencesGlobal().deleteImage();
        await SharedPrefencesGlobal().deleteNombre();
      },
      child: const ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.all(0),
        minVerticalPadding: 0,
        leading: Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            H2Text(
              text: 'Cerrar Sesión',
              fontSize: 10,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class UsuarioDate extends StatelessWidget {
  const UsuarioDate({
    super.key,
    required this.currentImage,
  });

  final TEmpleadoModel? currentImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: const Color(0xFF8B0000),
          child: ImageLoginUser(
            user: currentImage,
            size: 70,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              H2Text(
                  text: currentImage!.nombre,
                  color: Colors.white,
                  fontSize: 11),
              H2Text(
                  text: currentImage!.rol, color: Colors.white, fontSize: 10),
            ],
          ),
        )
      ],
    );
  }
}
