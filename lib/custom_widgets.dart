import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/api/autres_champs_api.dart';
import 'package:new_collecteur_ui/models/transfert.dart';

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
	modifiedLivraisons.containsKey(id.toString()) ? modifiedLivraisons[id.toString()]!.addAll(content)
	: modifiedLivraisons[id.toString()] = content;
  }
  else {
	modifiedTransferts.containsKey(id.toString()) ? modifiedTransferts[id.toString()]!.addAll(content)
	: modifiedTransferts[id.toString()] = content;
  }
}

void saveChange(String movement, {required int id,
				required String columnName, required String newValue}){
  saveModified(movement, id, {columnName: newValue});
  print(modifiedTransferts);
}

void saveStockSuivants(Transfert t, String newValue){
  List<String> stocks = newValue.split(' - ');
  modifiedTransferts.containsKey(t.id.toString()) ?
  modifiedTransferts[t.id.toString()]!["stock_central_suivants"] = jsonEncode(stocks)
  : modifiedTransferts[t.id.toString()] = {"stock_central_suivants": jsonEncode(stocks)};
  print(modifiedTransferts);
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
	List<Map<String, dynamic>> boucles = [];
	for (Boucle b in l.boucle) {
		if (b.boucleId != boucle.boucleId) {
			boucles.add(b.toJson());
		}
		else {
			boucles.add(boucle.toJson());
		}
	}
	modifiedLivraisons.containsKey(l.id) ?
	  modifiedLivraisons[l.id.toString()]!.addAll({"boucle": jsonEncode(boucles)})
	: modifiedLivraisons[l.id.toString()] = {"boucle": jsonEncode(boucles)};
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
