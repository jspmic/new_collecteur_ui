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

// Inputs collected from the API
List<String> collectedInputs = [];

// Stocks collected from the API
List<String> collectedStocks = [];

// Stocks collected from the API
List<String> collectedTypeTransports = [];

// Typical Fields collected from the API
List<Lot> lots = [];

// Field changed
Map<int, Lot> lotsChanged = {};
Map<int, Superviseur> modifiedSuperviseurs = {};
Map<String, String> districtsChanged = {};

// A little explanation is needed for this one
// The format we'll have at the end of completion is this one:
// {
	// "input": {"Input 1": "Input 1 modified", "Input 2": "Input 2 Modified"}
	// "stock_central": {"Stock 1": "Stock 1 modified", "Stock 2": "Stock 2 Modified"}
	// ...
// }
Map<String, Map<String, String>> autresChampsChanged = {};
