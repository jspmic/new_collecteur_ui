import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';

String HOST = dotenv.env["HOST"].toString();
String COLLECTEUR_SECRET = dotenv.env["COLLECTOR_SECRET"].toString();
String CODE = dotenv.env["CODE"].toString();

Future<bool> postAnnouncement({required int userId, required int timeout,
							   required String announcement}) async {
	Uri url = Uri.parse("$HOST/api/announce?id=$userId&t=$timeout&a=$announcement");
	http.Response response = await http.post(url,
		headers: {"x-api-key": COLLECTEUR_SECRET},
	);
	if (response.statusCode != 201) {
		return false;
	}
	return true;
}
