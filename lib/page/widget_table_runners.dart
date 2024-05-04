
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:inka_challenge/utils/format_fecha.dart';
import 'package:inka_challenge/utils/text_custom.dart';
import 'package:responsive_table/responsive_table.dart';

DatatableHeader dataHeaderCustom({String? header, String? value}) {
  print(' KP: $value');
  return DatatableHeader(
    text: header!.toUpperCase(),
    value: value!, //Muestra el valor de la tabal
    show: true,
    sortable: true,
    // editable: true,
    textAlign: TextAlign.center,
    headerBuilder: (value) {
      return H2Text(
        text: header.toUpperCase(),
        fontSize: 12,
         color: Colors.white,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      );
    },
    sourceBuilder: (value, row) {
      Widget renderedWidget;

      if (value is String) {
        renderedWidget = H2Text(
          text: value,
          fontSize: 11,
          textAlign: TextAlign.center,
        );
      } else if (value is bool) {
        renderedWidget = Checkbox(
          value: value,
          onChanged: (newValue) {
            value = newValue;
          },
        );
      } else if (value is DateTime) {
        print(value);
        renderedWidget = H2Text(
          text: value.year == 1998 ? '-' : formatFechaAndesRace(value),
          fontSize: 11,
          maxLines: 2,
          color:  const Color(0xFF333333),
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        );
      } else {
        renderedWidget = const H2Text(
          text: '..',
          fontSize: 11,
          textAlign: TextAlign.center,
        );
      }

      return renderedWidget;
    },
  );
}

 DatatableHeader dtaHeaderListProgress() {
    return DatatableHeader(
        text: "Received",
        value: "received",
        show: true,
        sortable: false,
        headerBuilder: (value) {
          return H2Text(
            text: 'Progreso'.toUpperCase(),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center,
          );
        },
        sourceBuilder: (value, row) {
          List<bool> receivedList = List<bool>.from(value);
          int totalCheckpoints = receivedList.length;
          int checkpointsCompleted =
              receivedList.where((checkpoint) => checkpoint == true).length;
          return Column(
            children: [
              SizedBox(
                width: 85,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.red.withOpacity(.2),
                  color: Colors.red,
                  value: checkpointsCompleted / totalCheckpoints,
                ),
              ),
              H2Text(
                text: "$checkpointsCompleted of $totalCheckpoints",
                fontSize: 12,
              )
            ],
          );
        },
        textAlign: TextAlign.center);
  }



