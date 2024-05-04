
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_t_checkpoints.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckpointsServices {
  
  static getUbicacionAlmacen() async {
    final records = await ar.collection('ar_check_points').getFullList(
    sort: '-created', 
    );
    return records;
  }

  static  postUbicacionApp(TCheckpointsModel data) async {
    final record =
        await ar.collection('ar_check_points').create(body: data.toJson());

    return record;
  }

  static  putUbicacionApp({String? id, TCheckpointsModel? data}) async {
    final record =
        await ar.collection('ar_check_points').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteUbicacionApp(String id) async {
    final record = await ar.collection('ar_check_points').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}