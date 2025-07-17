import "package:new_collecteur_ui/models/district.dart";
import "package:new_collecteur_ui/models/lot.dart";
import "package:new_collecteur_ui/models/superviseur.dart";

List<String> types_mouvement = ["Livraison", "Transfert"];
List<Superviseur> superviseursList = [];
Map<String, District> districts = {"Gihogazi": District(id: 0, nom: "Gihogazi", collines: ["Gasambura", "Gitaramuka"])};
List<Lot> lots = [Lot(id: 0, nom: "Lot 1", districts: ["Gihogazi"]), Lot(id: 1, nom: "Lot 2", districts: ["Gihogazi"])];

// Field changed
Map<int, Lot> lotsChanged = {};
List<Superviseur> addedSuperviseurs = [];
Map<String, String> districtsChanged = {};
