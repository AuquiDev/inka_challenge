
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Grid Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Grid Example'),
        ),
        body: MyCustomGrid(),
      ),
    );
  }
}

class MyCustomGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenWidth = constraints.maxWidth;
        final columnsCount = (screenWidth / 200).floor(); // Ajusta el ancho del elemento según sea necesario
        final itemWidth = screenWidth / columnsCount; // Ancho de cada elemento
        final itemHeight = itemWidth * 2; // Alto de cada elemento (triple del ancho)

        final itemCount = 20; // Cantidad de elementos en el grid

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(10.0), // Espacio alrededor del grid
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnsCount, // Columnas dinámicas según el ancho de la pantalla
                  mainAxisSpacing: 10.0, // Espacio vertical entre elementos
                  crossAxisSpacing: 10.0, // Espacio horizontal entre elementos
                  childAspectRatio: 1 / 2, // Relación de aspecto de cada elemento (alto:ancho)
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: Colors.blue, // Color de fondo del contenedor
                      child: Center(
                        child: Text('Item $index', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                  childCount: itemCount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
