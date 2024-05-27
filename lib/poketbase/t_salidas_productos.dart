
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/models/model_t_salidas.dart';
import 'package:pocketbase/pocketbase.dart';



class TSalidasApp {
  static getSalidasApp() async {
    final records = await ar.collection('productos_salida').getFullList(
          sort: '-created',
        );
    return records;
  }

  static  postSalidasApp(TSalidasAppModel data) async {
    final record =
        await ar.collection('productos_salida').create(body: data.toJson());

    return record;
  }

  static  putSalidasApp({String? id, TSalidasAppModel? data}) async {
    final record =
        await ar.collection('productos_salida').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteSalidasApp(String id) async {
    final record = await ar.collection('productos_salida').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return ar.realtime;
  }
}
