// ignore_for_file: avoid_print

import 'package:inka_challenge/models/model_t_entradas.dart';
import 'package:inka_challenge/poketbase/t_entradas_productos.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TEntradasAppProvider with ChangeNotifier {
  List<TEntradasModel> listaEntradas = [];

  TEntradasAppProvider() {
    print('Tabla Entradas inicilizado.');
    getEntradasAPP();
    // realtime();
  }
  //SET y GETTER
  List<TEntradasModel> get e => listaEntradas;

  void addTEntradas(TEntradasModel e) {
    listaEntradas.add(e);
    notifyListeners();
  }

  void updateTEntradas(TEntradasModel e) {
    listaEntradas[listaEntradas.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTEntradas(TEntradasModel e) {
    listaEntradas.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  //__________________________
  getEntradasAPP() async {
    List<RecordModel> response = await TEntradas.getEntradas();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TEntradasModel productos = TEntradasModel.fromJson(e.data);
      addTEntradas(productos);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postEntradasProvider(
      {String? id,
      String? idProducto,
      String? idEmpleado,
      String? idProveedor,
      double? cantidadEntrada,
      double? precioEntrada,
      double? costoTotal,
      String? descripcionEntrada,
      DateTime? fechaVencimientoENtrada}) async {
    isSyncing = true;
    notifyListeners();
    TEntradasModel data = TEntradasModel(
        id: '',
        idProducto: idProducto!,
        idEmpleado: idEmpleado!,
        idProveedor: idProveedor!,
        cantidadEntrada: cantidadEntrada!,
        precioEntrada: precioEntrada!,
        costoTotal: costoTotal!,
        descripcionEntrada: descripcionEntrada!,
        fechaVencimientoEntrada: fechaVencimientoENtrada!);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await TEntradas.postEntradasApp(data);
    addTEntradas(data);
  }

  updateEntradasProvider(
      {String? id,
      String? idProducto,
      String? idEmpleado,
      String? idProveedor,
      double? cantidadEntrada,
      double? precioEntrada,
      double? costoTotal,
      String? descripcionEntrada,
      DateTime? fechaVencimientoENtrada}) async {
    isSyncing = true;
    notifyListeners();
    TEntradasModel data = TEntradasModel(
        id: id!,
        idProducto: idProducto!,
        idEmpleado: idEmpleado!,
        idProveedor: idProveedor!,
        cantidadEntrada: cantidadEntrada!,
        precioEntrada: precioEntrada!,
        costoTotal: costoTotal!,
        descripcionEntrada: descripcionEntrada!,
        fechaVencimientoEntrada: fechaVencimientoENtrada!);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
    await TEntradas.putEntradasApp(id: id, data: data);
    addTEntradas(data);

    notifyListeners();
  }

  deleteTEntradasApp(String id) async {
    await TEntradas.deleteEntradasApp(id);
    listaEntradas.removeWhere((detalle) => detalle.id == id);
    print('eliminado');
    notifyListeners();
  }

  // Future<void> realtime() async {
  //   await pb.collection('productos_entradas').subscribe('*', (e) {
  //     print('REALTIME Enradas ${e.action}');

  //     switch (e.action) {
  //       case 'create':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //          e.record!.data["collectionId"] = e.record!.collectionId;
  //       e.record!.data["collectionName"] = e.record!.collectionName;
  //         addTEntradas(TEntradasModel.fromJson(e.record!.data));
  //         break;
  //       case 'update':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //          e.record!.data["collectionId"] = e.record!.collectionId;
  //       e.record!.data["collectionName"] = e.record!.collectionName;
  //         updateTEntradas(TEntradasModel.fromJson(e.record!.data));
  //         break;
  //       case 'delete':
  //         e.record!.data['id'] = e.record!.id;
  //         e.record!.data['created'] = DateTime.parse(e.record!.created);
  //         e.record!.data['updated'] = DateTime.parse(e.record!.updated);
  //          e.record!.data["collectionId"] = e.record!.collectionId;
  //       e.record!.data["collectionName"] = e.record!.collectionName;
  //         deleteTEntradas(TEntradasModel.fromJson(e.record!.data));
  //         break;
  //       default:
  //     }
  //   });
  // }
}
