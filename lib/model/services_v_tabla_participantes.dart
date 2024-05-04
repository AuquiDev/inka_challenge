// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:inka_challenge/api/path_key_api.dart';

class VTablaParticipantesServices {
  static get_v_TablaParticipantes() async {
    final records =  await ar.collection('ar_view_check_points').getFullList();
    // print('DATA GENERAL=> : $records');
    return records;
  }
}
