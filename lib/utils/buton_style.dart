import 'package:flutter/material.dart';

ButtonStyle buttonStyle() {
  return  const ButtonStyle(
    // maximumSize: MaterialStatePropertyAll(Size(150, 80)),
    padding: MaterialStatePropertyAll(EdgeInsets.only(left: 10, right: 10)),
    elevation: MaterialStatePropertyAll(3),
    visualDensity: VisualDensity.compact,
    surfaceTintColor: MaterialStatePropertyAll(Colors.white),
    backgroundColor:  MaterialStatePropertyAll(Color.fromRGBO(65, 193, 63, 1)),
    overlayColor: MaterialStatePropertyAll(Colors.white),
     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),))
  );
}


ButtonStyle buttonStyle2() {
    return  const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 5, right: 5)),
        elevation: MaterialStatePropertyAll(2),
        visualDensity: VisualDensity.compact,
        surfaceTintColor: MaterialStatePropertyAll(Colors.black),
        backgroundColor: MaterialStatePropertyAll(Colors.black),
        overlayColor: MaterialStatePropertyAll(Colors.white30),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color:Colors.black, width: 3,)
        )));
  }
