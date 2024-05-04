
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:inka_challenge/model/model_v_tabla_participantes.dart';
import 'package:inka_challenge/model/services_v_tabla_participantes.dart';
import 'package:pocketbase/pocketbase.dart';

class VTablaParticipantesProvider with ChangeNotifier {
  List<VTablaPartipantesModel> listaParticipantes = [];

  VTablaParticipantesProvider(){
    print('V Tabla Participantes Provider Inicializado');
    // getVtableParticipantes();
  }

  //FUnciones dentro de una clase : get y setter.
  List<VTablaPartipantesModel> get e => listaParticipantes;

  void addVParticipante(VTablaPartipantesModel e){
    listaParticipantes.add(e);
    notifyListeners();
  }

 bool isSyncing = false;
  //REVISAR LA DOCUMENTACION DEL FUTURE BUILDER SIMULAR REAL TIME
  Future<void> actualizarDatosDesdeServidor(String idEvento) async {
    isSyncing = true;
    notifyListeners();
    await getIdEvento(idEvento);
    await Future.delayed(const Duration(seconds: 1));
    isSyncing = false;
    notifyListeners();
  }

   // Función para cargar solo los datos que coinciden con el idEvento
  Future<void> getIdEvento(String idEvento) async {
    listaParticipantes.clear();
    List<RecordModel> response = await VTablaParticipantesServices.get_v_TablaParticipantes();

    for (var e in response) {
      var dataView = VTablaPartipantesModel.fromJson(e.data);
      dataView.setId = e.id;
      dataView.setCollectionId = e.collectionId;
      dataView.setCollectionName = e.collectionName;
      if ( dataView.idEvento == idEvento) {
        addVParticipante(dataView);
        print(dataView.dorsal);
      }
    }
    print('LISta : ${listaParticipantes.length}');
    notifyListeners();
  }

}
