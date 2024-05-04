// ignore_for_file: avoid_print

import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_t_checkpoints.dart';
import 'package:flutter/material.dart';
import 'package:inka_challenge/model/services_t_check_points.dart';
import 'package:inka_challenge/models/model_t_productos_app.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckpointsProvider with ChangeNotifier {
  List<TCheckpointsModel> listUbicacion = [];

  TCheckpointsProvider() {
    print('Ubicacion Inicializado');
    getTUbicacionApp();
    realtime();
  }

  //SET Y GET
  List<TCheckpointsModel> get e => listUbicacion;

  void addtubicacion(TCheckpointsModel e) {
    listUbicacion.add(e);
    notifyListeners();
  }

  void updateTUbicaciones(TCheckpointsModel e) {
    listUbicacion[listUbicacion.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTUbicaciones(TCheckpointsModel e) {
    listUbicacion.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTUbicacionApp() async {
    List<RecordModel> response =
        await TCheckpointsServices.getUbicacionAlmacen();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TCheckpointsModel ubicaciones = TCheckpointsModel.fromJson(e.data);
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
    List<TProductosAppModel>? itemsList,
  }) async {
    isSyncing = true;
    notifyListeners();
    TCheckpointsModel data = TCheckpointsModel(
      id: '', 
      idEvento: idEvento!, 
      nombre: nombre!, 
      ubicacion: ubicacion!, 
      descripcion: descripcion!, 
      elevacion: elevacion!, 
      orden: orden!, 
      horaApertura: horaApertura!, 
      horaCierre: horaCierre!, 
      estatus: estatus!, 
      itemsList: itemsList!);

    await TCheckpointsServices.postUbicacionApp(data);

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
     List<TProductosAppModel>? itemsList,
  }) async {
    isSyncing = true;
    notifyListeners();
    TCheckpointsModel data = TCheckpointsModel(
        id: id!,
        idEvento: idEvento!, 
        nombre: nombre!, 
        ubicacion: ubicacion!, 
        descripcion: descripcion!, 
        elevacion: elevacion!, 
        orden: orden!, 
        horaApertura: horaApertura!, 
        horaCierre: horaCierre!, 
        estatus: estatus!, 
        itemsList: itemsList!);
    await TCheckpointsServices.putUbicacionApp(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTUbicacionesApp(String id) async {
    await TCheckpointsServices.deleteUbicacionApp(id);
    notifyListeners();
  }

  Future<void> realtime() async {
    await ar.collection('ar_check_points').subscribe('*', (e) {
      print('REALTIME CHCEKpOITNS PROVIDER ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addtubicacion(TCheckpointsModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTUbicaciones(TCheckpointsModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTUbicaciones(TCheckpointsModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
