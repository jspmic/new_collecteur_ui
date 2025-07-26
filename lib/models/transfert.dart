import 'dart:convert';

Transfert transfertFromJson(String str) => Transfert.fromJson(json.decode(str));
Transfert transfertFromMap(Map<String, dynamic> _map) => Transfert.fromJson(_map);

String transfertToJson(Transfert data) => json.encode(data.toJson());

class Transfert {
    int id;
    String date;
    String plaque;
    String logisticOfficial;
    int numeroMouvement;
	int numeroJournalDuCamion;
    String stockCentralDepart;
    List stockCentralSuivants;
    String stockCentralRetour;
    String photoMvt;
    String photoJournal;
    String typeTransport;
    String user;
    String motif;

    Transfert({
        required this.id,
        required this.date,
        required this.plaque,
        required this.logisticOfficial,
        required this.numeroMouvement,
        required this.numeroJournalDuCamion,
        required this.stockCentralDepart,
        required this.stockCentralSuivants,
        required this.stockCentralRetour,
        required this.photoMvt,
        required this.photoJournal,
        required this.typeTransport,
        required this.user,
        required this.motif,
    });
    factory Transfert.fromJson(Map<String, dynamic> json) => Transfert(
        id: json["id"],
        date: json["date"],
        plaque: json["plaque"],
        logisticOfficial: json["logistic_official"],
        numeroMouvement: json["numero_mouvement"],
        numeroJournalDuCamion: json["numero_journal_du_camion"],
        stockCentralDepart: json["stock_central_depart"],
        stockCentralSuivants: json["stock_central_suivants"],
        stockCentralRetour: json["stock_central_retour"],
        photoMvt: json["photo_mvt"],
        photoJournal: json["photo_journal"],
        typeTransport: json["type_transport"],
        user: json["user"],
        motif: json["motif"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "plaque": plaque,
        "logistic_official": logisticOfficial,
        "numero_mouvement": numeroMouvement,
        "numero_journal_du_camion": numeroJournalDuCamion,
        "stock_central_depart": stockCentralDepart,
        "stock_central_suivants": stockCentralSuivants,
        "stock_central_retour": stockCentralRetour,
        "photo_mvt": photoMvt,
        "photo_journal": photoJournal,
        "type_transport": typeTransport,
        "user": user,
        "motif": motif,
    };
}
