

import 'package:inka_challenge/models/model_t_productos_app.dart';
import 'package:inka_challenge/utils/parse_fecha_nula.dart';

class TCheckpointsModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String nombre;
    String ubicacion;
    String descripcion;
    String elevacion;
    int orden;
    DateTime horaApertura;
    DateTime horaCierre;
    bool estatus;
    List<TProductosAppModel> itemsList;

    TCheckpointsModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,
        required this.idEvento,
        required this.nombre,
        required this.ubicacion,
        required this.descripcion,
        required this.elevacion,
        required this.orden,
        required this.horaApertura,
        required this.horaCierre,
        required this.estatus,
        required this.itemsList,
    });

    factory TCheckpointsModel.fromJson(Map<String, dynamic> json) => TCheckpointsModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        nombre: json["nombre"],
        ubicacion: json["ubicacion"],
        descripcion: json["descripcion"],
        elevacion: json["elevacion"],
        orden: json["orden"],
        horaApertura: parseDateTime(json["hora_apertura"]),
        horaCierre: parseDateTime(json["hora_cierre"]),
        estatus: json["estatus"],
        itemsList: json["items_list"] != null
         ? List<TProductosAppModel>.from(json["items_list"].map((x) => TProductosAppModel.fromJson(x)))
         : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        "created": created,
        "updated": updated,

        "id_evento": idEvento,
        "nombre": nombre,
        "ubicacion": ubicacion,
        "descripcion": descripcion,
        "elevacion": elevacion,
        "orden": orden,
        "hora_apertura": horaApertura.toIso8601String(),
        "hora_cierre": horaCierre.toIso8601String(),
        "estatus": estatus,
        "items_list": itemsList,
    };
}
