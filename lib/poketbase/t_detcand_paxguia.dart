
// TCantidadPaxGuia
import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/models/model_t_detcand_pax_guia.dart';
import 'package:pocketbase/pocketbase.dart';

class TCantidadPaxGuia {
  static getTCantidadPaxGuiaPK() async {
    final records = await pb.collection('cantidad_pasajeros_guia').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postTCantidadPaxGuiaPK(TCantidadPaxGuiaModel data) async {
    final record =
        await pb.collection('cantidad_pasajeros_guia').create(body: data.toJson());

    return record;
  }

  static  putTCantidadPaxGuiaPK({String? id, TCantidadPaxGuiaModel? data}) async {
    final record =
        await pb.collection('cantidad_pasajeros_guia').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteTCantidadPaxGuiaPk(String id) async {
    final record = await pb.collection('cantidad_pasajeros_guia').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}