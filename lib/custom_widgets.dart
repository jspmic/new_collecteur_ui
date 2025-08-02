import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/api/autres_champs_api.dart';

void clearGlobals() {
	superviseursList = [];
	// districts = {};
	// lots = [];
}

void initializeGlobals() {
	superviseursList = [Superviseur(id: 0, nom_utilisateur: "", nom: "", lot: "")];
}

// This function saves a certain movement to the new content
// void saveModified(String movement, String id, Map<String, String> content, {int? boucleId}){
// 	//   if (movement == "Livraison"){
// 	// modifiedLivraisons.containsKey(id) ? modifiedLivraisons[id]!.addAll(content)
// 	// : modifiedLivraisons[id] = content;
// 	//   }
// 	//   else {
// 	modifiedTransferts.containsKey(id) ? modifiedTransferts[id]!.addAll(content)
// 	: modifiedTransferts[id] = content;
//   // }
// }


// void saveChange(String movement, {required int id,
// 				required String columnName, required String newValue}){
//   saveModified(movement, id.toString(), {columnName: newValue});
// }

Future<bool> init() async {
	await dotenv.load(fileName: ".env");
	clearGlobals();
	try {
		bool loadingSuperviseurs = await getSuperviseurs();
		bool loadingFields = await getFields();
		if (!loadingSuperviseurs) {
			return false;
		}
	} on Exception {
		return false;
	}
	return true;
}

// Function to format a date
String formatDate(DateTime? _date){
  if (_date == null){
    return "";
  }
  return "${_date.day}/${_date.month}/${_date.year}";
}
