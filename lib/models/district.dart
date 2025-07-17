import 'dart:convert';

District districtFromJson(String str) => District.fromJson(json.decode(str));

String districtToJson(District data) => json.encode(data.toJson());

class District {
	int id;
	String nom;
	List<String> collines;
	District({
		required this.id,
		required this.nom,
		required this.collines
	});
    factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        nom: json["nom"],
        collines: json["collines"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "collines": collines,
    };
}
