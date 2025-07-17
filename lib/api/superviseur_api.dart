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
				nom_utilisateur: sup["_n_9032"],
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
		body: jsonEncode(sup.toJson())
	);
	if (response.statusCode != 201) {
		return false;
	}
	sup.psswd = "";
	superviseursList.add(sup);
	return true;
}
