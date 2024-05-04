import 'package:inka_challenge/model/provider_config_carrera.dart';
import 'package:inka_challenge/pages/menu_principal.dart';
import 'package:inka_challenge/provider/current_page.dart';
import 'package:inka_challenge/shared_preferences/shared_global.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  @override
  void initState() {
    // Luego, llama al método setLoggedIn en esa instancia
    sharedPrefs.setLoggedIn();
    //Ide del EVENTO AR, LACHAY
    final eventIdProvider = Provider.of<EventIdProvider>(context,listen:
            false); 
    eventIdProvider.caragrIdEvento(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final layoutmodel = Provider.of<LayoutModel>(context);

    final dataEvento = Provider.of<EventIdProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: H2Text(
          text: dataEvento.eventoPref,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          const SizedBox(width: 150, child: MenuPrincipal()),
          const VerticalDivider(
            width: 1,
          ),
          Expanded(flex: 3, child: layoutmodel.currentPage),
        ],
      ),
      // drawer: const MenuPrincipal(),
    );
  }
}

class TextAppBar extends StatelessWidget {
  const TextAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: H2Text(
          text: 'Logística de Operaciones y Almacén',
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w900),
    );
  }
}
