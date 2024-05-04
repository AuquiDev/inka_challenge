// TRolesSueldo

import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/models/model_t_empleado.rolessueldo.dart';
import 'package:pocketbase/pocketbase.dart';



class TRolesSueldo {
  static getRolesSueldoApp() async {
    final records = await pb.collection('rolesSueldo_Empleados').getFullList(
          sort: '-created',
        );
    return records;
  }

  static  postRolesSueldoApp(TRolesSueldoModel data) async {
    final record =
        await pb.collection('rolesSueldo_Empleados').create(body: data.toJson());

    return record;
  }

  static  putRolesSueldoApp({String? id, TRolesSueldoModel? data}) async {
    final record =
        await pb.collection('rolesSueldo_Empleados').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteRolesSueldoApp(String id) async {
    final record = await pb.collection('rolesSueldo_Empleados').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
