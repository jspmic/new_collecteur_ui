import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/district.dart';
import 'package:new_collecteur_ui/models/lot.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';

String HOST = dotenv.env["HOST"].toString();
String COLLECTEUR_SECRET = dotenv.env["COLLECTOR_SECRET"].toString();
String CODE = dotenv.env["CODE"].toString();

Future<bool> getFields() async {
	Uri uri = Uri.parse("$HOST/api/fields");
	http.Response response = await http.get(
	headers: {"x-api-key": COLLECTEUR_SECRET},
	uri);
	if (response.statusCode == 200) {
		Map resp = jsonDecode(response.body);
		Map<String, dynamic> _lots = resp["lots"]; // lot: district
		Map<String, dynamic> _districts = resp["districts"]; // district: colline
		Map<String, District> collectedDistricts = {};
		for (String district in _districts.keys) {
			District d = District(
				nom: district,
				collines: _districts[district]
			);
			collectedDistricts[d.nom] = d;
		}
		for (String lot in _lots.keys) {
			List lotDistricts = _lots[lot];
			List<District> districts = [];
			for (String lotDistrict in lotDistricts) {
				districts.add(collectedDistricts[lotDistrict]!);
			}
			Lot l = Lot(
				nom: lot,
				districts: districts
			);
			lots.add(l);
		}
	}
	else {
		return false;
	}
	return true;
}
