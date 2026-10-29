import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/globals.dart';
import "package:new_collecteur_ui/models/modification.dart";


Future<bool> getModifications() async {
	String secret = dotenv.env["COLLECTOR_SECRET"].toString();
	String host = dotenv.env["HOST"].toString();

	String url = "$host/api/modifications";

	Uri uri = Uri.parse(url);

	http.Response response = await http.get(
	uri,
	headers: {'x-api-key': secret}
	);

	if (response.statusCode != 200) {
		return false;
	}

	Map<String, List<String>> responseModifications = jsonDecode(response.body);

	List<String>? done = responseModifications["done"]!;
	List<String>? undone = responseModifications["undone"]!;

	print(done);
	print(undone);
	
	for (String d in done) {
		Modification m = modificationFromJson(d);
		collectedDoneModifications.add(m);
	}

	for (String d in undone) {
		Modification m = modificationFromJson(d);
		collectedUndoneModifications.add(m);
	}

	return true;
}
