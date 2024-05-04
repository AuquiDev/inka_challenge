import 'package:inka_challenge/model/provider_config_carrera.dart';
import 'package:inka_challenge/pages/menu_principal.dart';
import 'package:inka_challenge/pages/orientation_web_page.dart';
import 'package:inka_challenge/provider/current_page.dart';
import 'package:inka_challenge/shared_preferences/shared_global.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

  @override
  void initState() {
    // Luego, llama al método setLoggedIn en esa instancia
    sharedPrefs.setLoggedIn();
     final eventIdProvider = Provider.of<EventIdProvider>(context,listen:
            false); 
    eventIdProvider.caragrIdEvento(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final layoutmodel = Provider.of<LayoutModel>(context);
    final eventIdProvider = Provider.of<EventIdProvider>(context); // Obtenemos la instancia de EventIdProvider desde el contexto
    eventIdProvider.caragrIdEvento(); // Cargar el ID del evento al inicio
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const TextAppBar(),
      ),
      body: layoutmodel.currentPage, //const ListaOpciones(),
      drawer: const MenuPrincipal(),
    );
  }
}
