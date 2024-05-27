// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:inka_challenge/utils/routes_page_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdministracionPage extends StatefulWidget {
  const AdministracionPage({
    super.key,
  });

  @override
  State<AdministracionPage> createState() => _AdministracionPageState();
}

class _AdministracionPageState extends State<AdministracionPage> {
  final ScrollController _scrollController = ScrollController();
  bool showAppBar = true;
 //devulve el valor del scrollDirection.
  void _onScroll() {
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

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

//TITLE SELECT UBICACION

  @override
  Widget build(BuildContext context) {
    final List<Routes> routes = RoutesFactory.createRoutes();
    return Expanded(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              // Calcular el número de columnas en función del ancho disponible
              int crossAxisCount = (constraints.maxWidth / 200).floor();
              // Puedes ajustar el valor 100 según tus necesidades
              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,childAspectRatio: 1.3
                ),
                itemCount: routes.length,
                itemBuilder: (BuildContext context, int index) {
                  final e = routes[index];
                  return e.buildCard(context);
                },
              );
            }),
          )
        ],
      )),
    );
  }
}
