import 'dart:convert';

Modification modificationFromJson(String str) => Modification.fromJson(json.decode(str));

String modificationToJson(Modification data) => json.encode(data.toJson());

class Modification {

    int id;
    int mouvementId;
    String mouvementName;
    String description;
    bool status;
    String superviseur;
    DateTime requestedAt;

    Modification({
        required this.id,
		required this.mouvementId,
		required this.mouvementName,
		required this.description,
		required this.status,
		required this.superviseur,
		required this.requestedAt
    });

    factory Modification.fromJson(Map<String, dynamic> json) { 
		return Modification(
			id: json["id"],
			mouvementId: json["mouvementId"],
			mouvementName: json["mouvementName"],
			description: json["description"],
			status: json["status"],
			superviseur: json["superviseur"],
			requestedAt: json["requestedAt"]
		);
	}

    Map<String, dynamic> toJson() => {
        "id": id,
		"mouvementName": mouvementName,
		"description": description,
		"status": status,
		"superviseur": superviseur,
		"requestedAt": requestedAt
    };
}
