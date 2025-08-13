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
List<District> districts = []; // districts in their totality

// Field changed
Map<int, Lot> lotsChanged = {};
Map<int, Superviseur> modifiedSuperviseurs = {};
Map<String, String> districtsChanged = {};


// An example with this field would be:
// - For a Livraison: {
						// '1': {'date': '24/13/2090', 'district': 'Gitaramuka', ...},
						// '2': {...},
						// '...': {...}
						// }  // Stored in modifiedLivraisons
// - For a Transfert: {
						// '1': {'date': '24/13/2090', 'district': 'Gitaramuka', ...},
						// '2': {...},
						// '...': {...}
						// }  // Stored in modifiedTransferts
// the keys are the ids of the movements
// the values are maps with key the name of the field changed and the value the new value

Map<int, Map<String, String>> modifiedLivraisons = {};
Map<int, Map<String, String>> modifiedTransferts = {};

// A little explanation is needed for this one
// The format we'll have at the end of completion is this one:
// {
	// "input": {"Input 1": "Input 1 modified", "Input 2": "Input 2 Modified"}
	// "stock_central": {"Stock 1": "Stock 1 modified", "Stock 2": "Stock 2 Modified"}
	// ...
// }
Map<String, Map<String, String>> autresChampsChanged = {};
