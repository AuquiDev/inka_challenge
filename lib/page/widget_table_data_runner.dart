import 'package:inka_challenge/model/model_v_tabla_participantes.dart';

class TimeRunner {
  String checkpoint;
  DateTime fecha;
  bool estatus;

  TimeRunner(
    this.checkpoint,
    this.fecha,
    this.estatus,
  );
}


class TimeAcumulado {
  String checkPoints1;
  String acumulado;
  String checkPoints2;

  TimeAcumulado(
    this.checkPoints1,
    this.acumulado,
    this.checkPoints2,
  );
}
 
List<Map<String, dynamic>> generateData(List<VTablaPartipantesModel> dataParticipantes) {
    List<Map<String, dynamic>> temps = [];

    for (var e in dataParticipantes) {
      temps.add({
        "id": e.id,
        "collectionId": e.collectionId,
        "collectionName": e.collectionName,
        "idEvento": e.idEvento,
        "idDistancia": e.idDistancia,
        "distancias": e.distancias,
        "dorsal": e.dorsal,
        "nombre": e.nombre,
        "tiempo_acumulado": e.tiempoAcumulado,
        "tiempo_total": e.tiempoTotal,
        "tiempo_partida_1": e.tiempoPartida1,
        "tiempo_1_2": e.tiempo12,
        "tiempo_2_3": e.tiempo23,
        "tiempo_3_4": e.tiempo34,
        "tiempo_4_5": e.tiempo45,
        "tiempo_5_6": e.tiempo56,
        "tiempo_6_7": e.tiempo67,
        "tiempo_7_8": e.tiempo78,
        "tiempo_8_9": e.tiempo89,
        "tiempo_9_10": e.tiempo910,
        "tiempo_10_11": e.tiempo1011,
        "tiempo_11_12": e.tiempo1112,
        "tiempo_12_13": e.tiempo1213,
        "tiempo_13_meta": e.tiempo13Meta,
        "partida": e.partida,
        "partida_time": e.partidaTime,
        "punto1": e.punto1,
        "punto1_time": e.punto1Time,
        "puntp2": e.puntp2,
        "punto2_time": e.punto2Time,
        "puntp3": e.puntp3,
        "punto3_time": e.punto3Time,
        "puntp4": e.puntp4,
        "punto4_time": e.punto4Time,
        "puntp5": e.puntp5,
        "punto5_time": e.punto5Time,
        "puntp6": e.puntp6,
        "punto6_time": e.punto6Time,
        "puntp7": e.puntp7,
        "punto7_time": e.punto7Time,
        "puntp8": e.puntp8,
        "punto8_time": e.punto8Time,
        "puntp9": e.puntp9,
        "punto9_time": e.punto9Time,
        "puntp10": e.puntp10,
        "punto10_time": e.punto10Time,
        "puntp11": e.puntp11,
        "punto11_time": e.punto11Time,
        "puntp12": e.puntp12,
        "punto12_time": e.punto12Time,
        "puntp13": e.puntp13,
        "punto13_time": e.punto13Time,
        "meta": e.meta,
        "meta_time": e.metaTime,
        //CHECK LIST 
        'checklist': [
          TimeRunner(e.idChecList01, e.fechaInfo01, e.estadoInfo01),
          TimeRunner(e.idChecList02, e.fechaDoc02, e.estadoDoc02),
          TimeRunner(e.idChecList03, e.fechaKits03, e.estadoKits03),
          TimeRunner(e.idChecList04, e.fechaEquipaje04, e.estadoEquipaje04),
          TimeRunner(e.idChecList05, e.fechaBuses05, e.estadoBuses05),
          TimeRunner(e.idChecList06, e.fechaMedallas06, e.estadoMedallas06),
          TimeRunner(e.idChecList07, e.fechaRopaFin07, e.estadoRopaFin07),
          TimeRunner(e.idChecList08, e.fechaDevoRopa08, e.estadoDevoRopa08),
        ],
        //INtervalos
        'intervalos': [
          TimeAcumulado(e.pointsPartida, e.tiempoPartida1, e.pointsPunto01),
          TimeAcumulado(e.pointsPunto01, e.tiempo12, e.pointsPunto02),
          TimeAcumulado(e.pointsPunto02, e.tiempo23, e.pointsPunto03),
          TimeAcumulado(e.pointsPunto03, e.tiempo34, e.pointsPunto04),
          TimeAcumulado(e.pointsPunto04, e.tiempo45, e.pointsPunto05),
          TimeAcumulado(e.pointsPunto05, e.tiempo56, e.pointsPunto06),
          TimeAcumulado(e.pointsPunto06, e.tiempo67, e.pointsPunto07),
          TimeAcumulado(e.pointsPunto07, e.tiempo78, e.pointsPunto08),
          TimeAcumulado(e.pointsPunto08, e.tiempo89, e.pointsPunto09),
          TimeAcumulado(e.pointsPunto09, e.tiempo910, e.pointsPunto10),
          TimeAcumulado(e.pointsPunto10, e.tiempo1011, e.pointsPunto11),
          TimeAcumulado(e.pointsPunto11, e.tiempo1112, e.pointsPunto12),
          TimeAcumulado(e.pointsPunto12, e.tiempo1213, e.pointsPunto13),
          TimeAcumulado(e.pointsPunto13, e.tiempo13Meta, e.pointsMeta),
        ],
        //Fechas
        'time': [
          TimeRunner(e.pointsPartida, e.partidaTime, e.partida),
          TimeRunner(e.pointsPunto01, e.punto1Time, e.punto1),
          TimeRunner(e.pointsPunto02, e.punto2Time, e.puntp2),
          TimeRunner(e.pointsPunto03, e.punto3Time, e.puntp3),
          TimeRunner(e.pointsPunto04, e.punto4Time, e.puntp4),
          TimeRunner(e.pointsPunto05, e.punto5Time, e.puntp5),
          TimeRunner(e.pointsPunto06, e.punto6Time, e.puntp6),
          TimeRunner(e.pointsPunto07, e.punto7Time, e.puntp7),
          TimeRunner(e.pointsPunto08, e.punto8Time, e.puntp8),
          TimeRunner(e.pointsPunto09, e.punto9Time, e.puntp9),
          TimeRunner(e.pointsPunto10, e.punto10Time, e.puntp10),
          TimeRunner(e.pointsPunto11, e.punto11Time, e.puntp11),
          TimeRunner(e.pointsPunto12, e.punto12Time, e.puntp12),
          TimeRunner(e.pointsPunto13, e.punto13Time, e.puntp13),
          TimeRunner(e.pointsMeta, e.metaTime, e.meta),
        ],
        "received": [
          e.partida,
          e.punto1,
          e.puntp2,
          e.puntp3,
          e.puntp4,
          e.puntp5,
          e.puntp6,
          e.puntp7,
          e.puntp8,
          e.puntp9,
          e.puntp10,
          e.puntp11,
          e.puntp12,
          e.puntp13,
          e.meta,
        ],
        "data": e
      });
    }
    return temps;
  }




// class CheckPoints extends StatelessWidget {
//   const CheckPoints({
//     super.key,
//     required this.e,
//   });

//   final Map<String, dynamic> e;

//   @override
//   Widget build(BuildContext context) {
//      DateTime partida =  e['partida_time'];
//      int horap = partida.hour; 
//       int minp = partida.minute; 
//     String tiempoAcu =  e['tiempo_acumulado'];
//     // Dividir la cadena en partes separadas por ':'
//   List<String> partes = tiempoAcu.split(':');
  
//   // Obtener la hora, los minutos y los segundos
//   int hora = int.parse(partes[0]);
//   int minutos = int.parse(partes[1]);
//   int segundos = int.parse(partes[2]);
  
//     print('Hora: $hora');
//     print('Minutos: $minutos');
//     print('Segundos: $segundos');
  
//     return H2Text(text: '$hora:$minutos:$segundos');
//   }
// }