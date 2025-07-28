import 'dart:convert';

District districtFromJson(String str) => District.fromJson(json.decode(str));

String districtToJson(District data) => json.encode(data.toJson());

class District {
	String nom;
	List collines;
	District({
		required this.nom,
		required this.collines
	});
    factory District.fromJson(Map<String, dynamic> json) => District(
        nom: json["nom"],
        collines: json["collines"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "collines": collines,
    };
}
