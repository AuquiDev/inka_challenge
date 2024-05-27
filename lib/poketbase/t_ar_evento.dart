
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_evento.dart';
import 'package:pocketbase/pocketbase.dart';

class TEventoAr {
  
  static getAsitenciaPk() async {
    final records = await ar.collection('ar_evento').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TEventoModel data) async {
    final record = await ar.collection('ar_evento').create(body: data.toJson());
    return record;
  }

  static  putAsitneciaPk({String? id, TEventoModel? data}) async {
    final record = await ar.collection('ar_evento').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await ar.collection('ar_evento').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return ar.realtime;
  }
}