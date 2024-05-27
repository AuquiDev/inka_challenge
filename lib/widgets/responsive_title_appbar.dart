
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:flutter/material.dart';

class ResponsiveTitleAppBar extends StatelessWidget {
  const ResponsiveTitleAppBar({
    super.key,
    required this.title, required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           H2Text(
            text: title.toUpperCase(), //Movimientos de Inventario
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
           H2Text(
            text: subtitle,
            fontSize: 13,
          ),
         ],)
        ],
      ),
    );
  }
}