import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';

String HOST = dotenv.env["HOST"].toString();
String COLLECTEUR_SECRET = dotenv.env["COLLECTOR_SECRET"].toString();
String CODE = dotenv.env["CODE"].toString();

Future<bool> getSuperviseurs() async {
	Uri uri = Uri.parse("$HOST/api/superviseurs");
	http.Response response = await http.get(
	headers: {"Authorization": COLLECTEUR_SECRET},
	uri);
	if (response.statusCode != 200) {
		return false;
	}
	String _supervisors = jsonDecode(response.body);
	List supervisors = jsonDecode(_supervisors);
	for (var sup in supervisors) {
		superviseursList.add(
			Superviseur(
				id: sup["id"],
				nom: sup["nom"],
				nom_utilisateur: sup["_n_9032"],
				lot: sup["lot"],
			)
		);
	}
	return true;
}

Future<bool> addSuperviseurs(Superviseur sup) async {
	Uri uri = Uri.parse("$HOST/api/list");
	http.Response response = await http.post(
		uri,
		headers: {
			"x-api-key": CODE,
			"Content-Type": "application/json"
		},
		body: superviseurToJson(sup)
	);
	if (response.statusCode != 201) {
		return false;
	}
	final returnedSuperviseur = jsonDecode(response.body);
	sup.id = returnedSuperviseur["id"];
	sup.lot = returnedSuperviseur["lot"];
	sup.psswd = null;
	superviseursList.add(sup);
	return true;
}

Future<bool> deleteSuperviseurs(Superviseur sup) async {
	Uri uri = Uri.parse("$HOST/api/list");
	http.Response response = await http.delete(
		uri,
		headers: {
			"x-api-key": COLLECTEUR_SECRET,
			"Content-Type": "application/json"
		},
		body: jsonEncode({"id": sup.id})
	);
	if (response.statusCode != 200) {
		return false;
	}
	superviseursList.remove(sup);
	return true;
}

Future<bool> modifySuperviseurs(Superviseur sup) async {
	Uri uri = Uri.parse("$HOST/api/list?id=${sup.id}");
	http.Response response = await http.patch(
		uri,
		headers: {
			"x-api-key": COLLECTEUR_SECRET,
			"Content-Type": "application/json"
		},
		body: superviseurToJson(sup)
	);
	if (response.statusCode != 200) {
		return false;
	}
	Superviseur modifiedSuperviseur = superviseurFromJson(response.body);
	int? seekIndex;
	for (Superviseur s in superviseursList) {
		if (s.id == modifiedSuperviseur.id) {
			seekIndex = superviseursList.indexOf(s);
			break;
		}
	}
	if (seekIndex == null) {
		return false;
	}
	superviseursList[seekIndex] = modifiedSuperviseur;
	return true;
}
