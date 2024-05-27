
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/models/model_t_ubicacion_almacen.dart';
import 'package:pocketbase/pocketbase.dart';

class TUbicacionAlmacen {
  
  static getUbicacionAlmacen() async {
    final records = await ar.collection('ubicacion_almacen').getFullList(
    sort: '-created', 
    );
    return records;
  }

  static  postUbicacionApp(TUbicacionAlmacenModel data) async {
    final record =
        await ar.collection('ubicacion_almacen').create(body: data.toJson());

    return record;
  }

  static  putUbicacionApp({String? id, TUbicacionAlmacenModel? data}) async {
    final record =
        await ar.collection('ubicacion_almacen').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteUbicacionApp(String id) async {
    final record = await ar.collection('ubicacion_almacen').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return ar.realtime;
  }
}