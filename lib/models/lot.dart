import 'dart:convert';

Lot lotFromJson(String str) => Lot.fromJson(json.decode(str));

String lotToJson(Lot data) => json.encode(data.toJson());

class Lot {
	int id;
	String nom;
	List<String> districts;
	Lot({
		required this.id,
		required this.nom,
		required this.districts
	});
    factory Lot.fromJson(Map<String, dynamic> json) => Lot(
        id: json["id"],
        nom: json["nom"],
        districts: json["districts"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "districts": districts,
    };
}
