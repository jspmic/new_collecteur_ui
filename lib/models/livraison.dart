// To parse this JSON data, do
//
//     final livraison = livraisonFromJson(jsonString);

import 'dart:convert';

Livraison livraisonFromJson(String str) => Livraison.fromJson(json.decode(str));

String livraisonToJson(Livraison data) => json.encode(data.toJson());

class Livraison {
    int id;
    String date;
    String plaque;
    String logisticOfficial;
    int numeroMouvement;
    int numeroJournalDuCamion;
    String stockCentralDepart;
    String district;
    List<Boucle> boucle;
    String stockCentralRetour;
    String photoMvt;
    String photoJournal;
    String typeTransport;
    String user;
    String motif;

    Livraison({
        required this.id,
        required this.date,
        required this.plaque,
        required this.logisticOfficial,
        required this.numeroMouvement,
        required this.numeroJournalDuCamion,
        required this.stockCentralDepart,
        required this.district,
        required this.boucle,
        required this.stockCentralRetour,
        required this.photoMvt,
        required this.photoJournal,
        required this.typeTransport,
        required this.user,
        required this.motif,
    });

    factory Livraison.fromJson(Map<String, dynamic> json) { 
		int boucleId = 0;
		return Livraison(
			id: json["id"],
			date: json["date"],
			plaque: json["plaque"],
			logisticOfficial: json["logistic_official"],
			numeroMouvement: json["numero_mouvement"],
			numeroJournalDuCamion: json["numero_journal_du_camion"],
			stockCentralDepart: json["stock_central_depart"],
			district: json["district"],
			boucle: List<Boucle>.from(json["boucle"].values.map((x) {
				boucleId += 1;
				return Boucle.fromJson(x, boucleId);
			})),
			stockCentralRetour: json["stock_central_retour"],
			photoMvt: json["photo_mvt"],
			photoJournal: json["photo_journal"],
			typeTransport: json["type_transport"],
			user: json["user"],
			motif: json["motif"],
		);
	}

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "plaque": plaque,
        "logistic_official": logisticOfficial,
        "numero_mouvement": numeroMouvement,
        "numero_journal_du_camion": numeroJournalDuCamion,
        "stock_central_depart": stockCentralDepart,
        "district": district,
        "boucle": List<dynamic>.from(boucle.map((x) => x.toJson())),
        "stock_central_retour": stockCentralRetour,
        "photo_mvt": photoMvt,
        "photo_journal": photoJournal,
        "type_transport": typeTransport,
        "user": user,
        "motif": motif,
    };
}

class Boucle {
	int boucleId;
    String livraisonRetour;
    String colline;
    String input;
    String quantite;

    Boucle({
        required this.boucleId,
        required this.livraisonRetour,
        required this.colline,
        required this.input,
        required this.quantite,
    });

    factory Boucle.fromJson(Map<String, dynamic> json, int boucleId) => Boucle(
		boucleId: boucleId,
        livraisonRetour: json["livraison_retour"] ?? "",
        colline: json["colline"] ?? "",
        input: json["input"] ?? "",
        quantite: json["quantite"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "livraison_retour": livraisonRetour,
        "colline": colline,
        "input": input,
        "quantite": quantite,
    };
}
