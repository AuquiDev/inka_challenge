
import 'package:inka_challenge/models/model_t_productos_app.dart';
import 'package:inka_challenge/utils/parse_fecha_nula.dart';

class TCheckListModel {
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String nombre;
    String descripcion;
    String ubicacion;
    int orden;
    DateTime horaApertura;
    DateTime horaCierre;
    bool estatus;
    List<TProductosAppModel> itemsList;

    TCheckListModel({
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idEvento,
        required this.nombre,
        required this.descripcion,
        required this.ubicacion,
        required this.orden,
        required this.horaApertura,
        required this.horaCierre,
        required this.estatus,
        required this.itemsList,
    });

    factory TCheckListModel.fromJson(Map<String, dynamic> json) => TCheckListModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        ubicacion: json["ubicacion"],
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
        "descripcion": descripcion,
        "ubicacion": ubicacion,
        "orden": orden,
        "hora_apertura": horaApertura.toIso8601String(),
        "hora_cierre": horaCierre.toIso8601String(),
        "estatus": estatus,
        "items_list": itemsList,
    };
}
