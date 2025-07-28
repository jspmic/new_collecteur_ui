import 'dart:convert';
Livraison livraisonFromJson(String str) => Livraison.fromJson(json.decode(str));
Livraison livraisonFromMap(Map<String, dynamic> _map) => Livraison.fromJson(_map);

class Livraison {
	int id;
    String date;
    String plaque;
    String logisticOfficial;
    int numeroMouvement;
    int numeroJournalDuCamion;
    String district;
    String stockCentralDepart;
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
        required this.district,
        required this.stockCentralDepart,
        required this.boucle,
        required this.stockCentralRetour,
        required this.photoMvt,
        required this.photoJournal,
        required this.typeTransport,
        required this.user,
        required this.motif,
    });

    factory Livraison.fromJson(Map<String, dynamic> json) => Livraison(
        id: json["id"],
        date: json["date"],
        plaque: json["plaque"],
        logisticOfficial: json["logistic_official"],
        numeroMouvement: json["numero_mouvement"],
        numeroJournalDuCamion: json["numero_journal_du_camion"],
        district: json["district"],
        stockCentralDepart: json["stock_central_depart"],
		// To be fixed
		boucle: json["boucle"].map<List>((value) {
			return boucleFromMap(value);
		}).toList(),
		//
        stockCentralRetour: json["stock_central_retour"],
        photoMvt: json["photo_mvt"],
        photoJournal: json["photo_journal"],
        typeTransport: json["type_transport"],
        user: json["user"],
        motif: json["motif"],
    );
}

Boucle boucleFromMap(Map<String, String> map) => Boucle.fromMap(map);
class Boucle {
    String livraisonRetour;
    String colline;
    String input;
    String quantite;

    Boucle({
        required this.livraisonRetour,
        required this.colline,
        required this.input,
        required this.quantite,
    });

	factory Boucle.fromMap(Map<String, String> _map) => Boucle(
			livraisonRetour: _map['livraison_retour'].toString(),
			colline: _map['colline'].toString(),
			input: _map['input'].toString(),
			quantite: _map['quantite'].toString());

	Map<String, String> toMap() {
		return {
			"livraison_retour": livraisonRetour,
			"colline": colline,
			"input": input,
			"quantite": quantite,
		};
	}
}
