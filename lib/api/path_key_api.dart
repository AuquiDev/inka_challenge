import 'package:pocketbase/pocketbase.dart';
final pb = PocketBase('https://planet-broken.pockethost.io');

final ar = PocketBase('https://andes-race-challenge.pockethost.io');








// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:inka_challenge/model/model_v_tabla_participantes.dart';
// import 'package:inka_challenge/model/provider_config_carrera.dart';
// import 'package:inka_challenge/model/services_v_tabla_participantes.dart';
// import 'package:pocketbase/pocketbase.dart';

// class VTablaParticipantesProvider with ChangeNotifier {
//   List<VTablaPartipantesModel> listaParticipantes = [];

//   VTablaParticipantesProvider(){
//     print('V Tabla Participantes Provider Inicializado');
//     // getVtableParticipantes();
//   }

//   //FUnciones dentro de una clase : get y setter.
//   List<VTablaPartipantesModel> get e => listaParticipantes;

//   void addVParticipante(VTablaPartipantesModel e){
//     listaParticipantes.add(e);
//     notifyListeners();
//   }
  
//   String  idEvento = EventIdProvider().idEvento;

//   // getVtableParticipantes() async {
//   //   List<RecordModel> response = await VTablaParticipantesServices.get_v_TablaParticipantes();
//   //   for (var e in response) {
//   //     var dataView = VTablaPartipantesModel.fromJson(e.data);
//   //     dataView.setId = e.id;
//   //     dataView.setCollectionId = e.collectionId;
//   //     dataView.setCollectionName = e.  collectionName;
//   //     addVParticipante(dataView);
//   //   }
//   //   notifyListeners();
//   // }

//    // Función para cargar solo los datos que coinciden con el idEvento
//   Future<void> getVtableParticipantes() async {
//     listaParticipantes.clear(); // Borrar la lista almacenada
//     List<RecordModel> response = await VTablaParticipantesServices.get_v_TablaParticipantes();
//     for (var e in response) {
//       var dataView = VTablaPartipantesModel.fromJson(e.data);
//       dataView.setId = e.id;
//       dataView.setCollectionId = e.collectionId;
//       dataView.setCollectionName = e.collectionName;
//       if (idEvento == dataView.idEvento) {
//         addVParticipante(dataView);
//       }
//     }
//     notifyListeners();
//   }

//   //REVISAR LA DOCUMENTACION DEL FUTURE BUILDER SIMULAR REAL TIME
//   Future<void> actualizarDatosDesdeServidor() async {
//     listaParticipantes.clear();
//     await getVtableParticipantes();
//     print('nuevosDatos V tabla Participantes');
//     notifyListeners();
//   }
// }
