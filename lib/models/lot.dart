import 'dart:convert';
import "package:new_collecteur_ui/models/district.dart";

Lot lotFromJson(String str) => Lot.fromJson(json.decode(str));

String lotToJson(Lot data) => json.encode(data.toJson());

class Lot {
	String nom;
	List<District> districts;
	Lot({
		required this.nom,
		required this.districts
	});
    factory Lot.fromJson(Map<String, dynamic> json) => Lot(
        nom: json["nom"],
        districts: json["districts"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "districts": districts,
    };
}
