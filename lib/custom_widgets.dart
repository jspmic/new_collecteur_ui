import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/api/autres_champs_api.dart';

void clearGlobals() {
	superviseursList = [];
	// districts = {};
	// lots = [];
}

String formatStock(String stock){
  return stock.replaceAll('_', ' ');
}

void initializeGlobals() {
	superviseursList = [Superviseur(id: 0, nom_utilisateur: "", nom: "", lot: "")];
}

// This function saves a certain movement to the new content
void saveModified(String movement, int id, Map<String, String> content){
  if (movement == "Livraison"){
	modifiedLivraisons.containsKey(id) ? modifiedLivraisons[id]!.addAll(content)
	: modifiedLivraisons[id] = content;
  }
  else {
	modifiedTransferts.containsKey(id) ? modifiedTransferts[id]!.addAll(content)
	: modifiedTransferts[id] = content;
  }
}

void saveChange(String movement, {required int id,
				required String columnName, required String newValue}){
  saveModified(movement, id, {columnName: newValue});
  print(modifiedLivraisons);
}

void saveBoucle(Livraison l, int boucleId, String columnName, String newValue){
	// Making a copy of the `boucle` to not overwrite it by mistake
	Boucle boucle = l.boucle.firstWhere((b) => b.boucleId == boucleId);
	switch (columnName) {
		case "livraison_retour":
			boucle.livraisonRetour = newValue;
		case "input":
			boucle.input = newValue;
		case "quantite":
			boucle.quantite = newValue;
		case "colline":
			boucle.colline = newValue;
		default:
		return;
	};
	modifiedLivraisons.containsKey(l.id) ?
	  modifiedLivraisons[l.id]!.addAll({"boucle": jsonEncode(boucle.toJson())})
	: modifiedLivraisons[l.id] = {"boucle": jsonEncode(boucle.toJson())};
	print(modifiedLivraisons);
}

Future<bool> init() async {
	await dotenv.load(fileName: ".env");
	clearGlobals();
	try {
		bool loadingSuperviseurs = await getSuperviseurs();
		bool loadingFields = await getFields();
		if (!loadingSuperviseurs || !loadingFields) {
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
