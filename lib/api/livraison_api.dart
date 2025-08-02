import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';

String HOST = dotenv.env["HOST"].toString();
String COLLECTEUR_SECRET = dotenv.env["COLLECTOR_SECRET"].toString();
String CODE = dotenv.env["CODE"].toString();

Future<bool> getLivraisons(DateTime? _date1, DateTime? _date2, int userId) async {
	Uri uri;
	String date1 = formatDate(_date1);
	String date2 = formatDate(_date2);
	if (date2.isNotEmpty) {
		uri = Uri.parse("$HOST/api/livraisons?date=$date1&date2=$date2&userId=$userId");
	}
	else {
		uri = Uri.parse("$HOST/api/livraisons?date=$date1&userId=$userId");
	}

	http.Response response = await http.get(uri);
	if (response.statusCode != 200) {
		return false;
	}

	List responseLivraisons = jsonDecode(response.body);
	responseLivraisons.forEach((livraisonStr) {
		Livraison l = livraisonFromJson(livraisonStr);
		collectedLivraison.add(l);
	});
	return true;
}

Future<bool> removeLivraison(Livraison l) async {
  var url = Uri.parse("$HOST/api/livraisons?id=${l.id}");
  try {
    http.Response response = await http.delete(url, headers: {
      "x-api-key": COLLECTEUR_SECRET,
	  'Content-Type': 'application/json; charset=UTF-8'
    }
	).timeout(const Duration(minutes: 2), onTimeout: () {
      return http.Response("No connection", 404);
    });
    if (response.statusCode == 200) {
		collectedLivraison.removeWhere((value) { return value.id == l.id; });
    }
  } on http.ClientException {
    return false;
  }
	return true;
}
