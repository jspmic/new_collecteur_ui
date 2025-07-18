import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';

void clearGlobals() {
	superviseursList = [];
	// districts = {};
	// lots = [];
}

void initializeGlobals() {
	superviseursList = [Superviseur(id: 0, nom_utilisateur: "")];
}

Future<bool> init() async {
	await dotenv.load(fileName: ".env");
	try {
		bool loadingSuperviseurs = await getSuperviseurs();
		if (!loadingSuperviseurs) {
			return false;
		}
	} on Exception {
		return false;
	}
	return true;
}

// Function to format a date
String? formatDate(DateTime? _date){
  if (_date == null){
    return null;
  }
  return "${_date?.day} / ${_date?.month} / ${_date?.year}";
}
