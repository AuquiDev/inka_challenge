// ignore_for_file: avoid_print

import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_t_checklist.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/model/services_t_check_list.dart';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:inka_challenge/models/model_t_productos_app.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckListProvider with ChangeNotifier {
  List<TCheckListModel> listUbicacion = [];

  TCheckListProvider() {
    print('Ubicacion Inicializado');
    getTUbicacionApp();
    realtime();
  }

  //SET Y GET
  List<TCheckListModel> get e => listUbicacion;

  void addtubicacion(TCheckListModel e) {
    listUbicacion.add(e);
    notifyListeners();
  }

  void updateTUbicaciones(TCheckListModel e) {
    listUbicacion[listUbicacion.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTUbicaciones(TCheckListModel e) {
    listUbicacion.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTUbicacionApp() async {
    List<RecordModel> response =  await TCheckListServices.get();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TCheckListModel ubicaciones = TCheckListModel.fromJson(e.data);
      addtubicacion(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTUbicacionesProvider({
    String? id,
    String? idEvento,
    String? nombre,
    String? ubicacion,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura,
    DateTime? horaCierre,
    bool? estatus,
    List<TEmpleadoModel>? personal,
     List<TProductosAppModel>? itemsList
  }) async {
    isSyncing = true;
    notifyListeners();
    TCheckListModel data = TCheckListModel(
      id: '', 
      idEvento: idEvento!, 
      nombre: nombre!, 
      ubicacion: ubicacion!, 
      descripcion: descripcion!, 
      // elevacion: elevacion!, 
      orden: orden!, 
      horaApertura: horaApertura!, 
      horaCierre: horaCierre!, 
      estatus: estatus!, 
      personal: personal!,
      itemsList: itemsList!
      );
    print('PROVIER LISTA: ${personal.length}');

    await TCheckListServices.post(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTUbicacionesProvider({
    String? id,
    String? idEvento,
    String? nombre,
    String? ubicacion,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura, 
    DateTime? horaCierre,
    bool? estatus,
    List<TEmpleadoModel>? personal,
    List<TProductosAppModel>? itemsList
  }) async {
    isSyncing = true;
    notifyListeners();
    TCheckListModel data = TCheckListModel(
        id: id!,
        idEvento: idEvento!, 
        nombre: nombre!, 
        ubicacion: ubicacion!, 
        descripcion: descripcion!,  
        orden: orden!, 
        horaApertura: horaApertura!, 
        horaCierre: horaCierre!, 
        estatus: estatus!, 
        personal: personal!,
        itemsList: itemsList!
        );
        print('PROVIER LISTA: ${itemsList.length}');
    await TCheckListServices.put(id: id, data: data);
        print('PROVIER LISTA: ${itemsList.length}');
    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTUbicacionesApp(String id) async {
    await TCheckListServices.delete(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await ar.collection('ar_check_list').subscribe('*', (e) {
      print('REALTIME CHEKCLIST PROVIDER ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addtubicacion(TCheckListModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTUbicaciones(TCheckListModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTUbicaciones(TCheckListModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
