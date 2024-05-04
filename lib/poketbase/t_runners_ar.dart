

import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_runners_ar.dart';
import 'package:pocketbase/pocketbase.dart';

class TRunners {
  static getAsitenciaPk() async {
    final records = await ar.collection('ar_corredores').getFullList(
          sort: '-created',
        );
    print('POKETBASE RECORD :$records');
    return records;
  }

  static  postAsistenciaPk(TRunnersModel data) async {
    final record =
        await pb.collection('ar_corredores').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TRunnersModel? data}) async {
    final record = await pb.collection('ar_corredores').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_corredores').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}