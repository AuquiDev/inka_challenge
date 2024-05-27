

class TDistanciasModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String distancias;
    String descripcion;
    bool estatus;
    String color;

    TDistanciasModel({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.distancias,
        required this.descripcion,
        required this.estatus,
        required this.color,
    });

    factory TDistanciasModel.fromJson(Map<String, dynamic> json) => TDistanciasModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        distancias: json["distancias"],
        descripcion: json["descripcion"],
        estatus: json["estatus"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created.toIso8601String(),
        // "updated": updated.toIso8601String(),
        "distancias": distancias,
        "descripcion": descripcion,
        "estatus": estatus,
        "color": color,
    };
}
