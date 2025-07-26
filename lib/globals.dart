import "package:new_collecteur_ui/models/district.dart";
import "package:new_collecteur_ui/models/lot.dart";
import "package:new_collecteur_ui/models/superviseur.dart";
import "package:new_collecteur_ui/models/transfert.dart";
import "package:new_collecteur_ui/models/livraison.dart";

List<String> types_mouvement = ["Livraison", "Transfert"];
List<Superviseur> superviseursList = [];

// Transferts collected from the API
List<Transfert> collectedTransfert = [];

// Livraisons collected from the API
List<Livraison> collectedLivraison = [];

// Typical Fields collected from the API
List<Lot> lots = [];

// Field changed
Map<int, Lot> lotsChanged = {};
Map<int, Superviseur> modifiedSuperviseurs = {};
Map<String, String> districtsChanged = {};
