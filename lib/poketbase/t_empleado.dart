// import 'package:inka_challenge/api/path_key_api.dart';
// import 'package:inka_challenge/models/model_t_empleado.dart';
// import 'package:pocketbase/pocketbase.dart'; 

// class TEmpleado {
//   static getTEmpleado() async {
//     final records = await pb.collection('empleados_personal').getFullList(
//           sort: '-created',
//         );
//     return records;
//   }

//   static postEmpleadosApp(TEmpleadoModel data) async {
//     final record =
//         await pb.collection('empleados_personal').create(body: data.toJson());

//     return record;
//   }

//   static putEmpleadosApp({String? id, TEmpleadoModel? data}) async {
//     final record = await pb
//         .collection('empleados_personal')
//         .update(id!, body: data!.toJson());
//     return record;
//   }

//   static Future deleteEmpleadosApp(String id) async {
//     final record = await pb.collection('empleados_personal').delete(id);
//     return record;
//   }

//   static Future<RealtimeService> realmTimePocket() async {
//     return pb.realtime;
//   }
// }


import 'package:inka_challenge/api/path_key_api.dart';
import 'package:inka_challenge/models/model_t_empleado.dart';
import 'package:pocketbase/pocketbase.dart'; 

class TEmpleado {
  static getTEmpleado() async {
    final records = await ar.collection('empleados_personal').getFullList(
          sort: '-created',
        );
        // print('EMPLEADOS  $records');
    return records;
  }

  static postEmpleadosApp(TEmpleadoModel data) async {
    final record =
        await ar.collection('empleados_personal').create(body: data.toJson());

    return record;
  }

  static putEmpleadosApp({String? id, TEmpleadoModel? data}) async {
    final record = await ar
        .collection('empleados_personal')
        .update(id!, body: data!.toJson());
    return record;
  }

  static Future deleteEmpleadosApp(String id) async {
    final record = await ar.collection('empleados_personal').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return ar.realtime;
  }

}
