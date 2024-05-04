
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/model/model_t_checklist.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckListServices {
  
  static get() async {
    final records = await ar.collection('ar_check_list').getFullList(
    sort: '-created', 
    );
    return records;
  }

  static  post(TCheckListModel data) async {
    final record =
        await ar.collection('ar_check_list').create(body: data.toJson());

    return record;
  }

  static  put({String? id, TCheckListModel? data}) async {
    final record =
        await ar.collection('ar_check_list').update(id!, body: data!.toJson());
    return record;
  }

  static Future  delete(String id) async {
    final record = await ar.collection('ar_check_list').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}