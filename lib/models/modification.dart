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
    String requestedAt;

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
			mouvementId: json["mouvement_id"],
			mouvementName: json["mouvement_name"],
			description: json["description"],
			status: json["status"],
			superviseur: json["superviseur"],
			requestedAt: json["requested_at"]
		);
	}

    Map<String, dynamic> toJson() => {
        "id": id,
		"mouvement_id": mouvementId,
		"mouvement_name": mouvementName,
		"description": description,
		"status": status,
		"superviseur": superviseur,
		"requested_at": requestedAt
    };
}
