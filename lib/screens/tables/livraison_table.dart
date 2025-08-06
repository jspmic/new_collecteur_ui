import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/api/livraison_api.dart';

final fluent.GlobalKey<fluent.NavigatorState> navigatorKey = fluent.GlobalKey<fluent.NavigatorState>();

Map<String, Map<String, String>> modifiedLivraisons = {};

// Function to format stock central
String formatStock(String stock){
  return stock.replaceAll('_', ' ');
}

class DeletePopUp extends fluent.StatefulWidget {
  const DeletePopUp({super.key});

  @override
  State<DeletePopUp> createState() => _DeletePopUpState();
}

class _DeletePopUpState extends fluent.State<DeletePopUp> {
  @override
  fluent.Widget build(fluent.BuildContext context) {
    return const fluent.Text("Hello visible");
  }
}

// Controllers for this kind of table
Map<int, TextEditingController> idControllers = {};
Map<int, TextEditingController> userControllers = {};
Map<int, TextEditingController> dateControllers = {};
Map<int, TextEditingController> logisticOfficialsControllers = {};
Map<int, TextEditingController> numeroMvtControllers = {};
Map<int, TextEditingController> numeroJournalControllers = {};
Map<int, TextEditingController> plaqueControllers = {};
Map<int, TextEditingController> stockDepartControllers = {};
Map<int, TextEditingController> stockRetourControllers = {};
Map<int, TextEditingController> typeTransportControllers = {};
Map<int, TextEditingController> motifControllers = {};
Map<int, TextEditingController> photoMvtControllers = {};
Map<int, TextEditingController> photoJournalControllers = {};
Map<int, TextEditingController> districtControllers = {};
Map<String, TextEditingController> livraisonRetourControllers = {};
Map<String, TextEditingController> collineControllers = {};
Map<String, TextEditingController> inputControllers = {};
Map<String, TextEditingController> quantiteControllers = {};
Map<int, String> keys = {};

List<DataColumn> _createLivraisonColumns() {
  return [
    const DataColumn(
        label: Text("Id", style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Superviseur", style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Plaque", style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Logistic Official",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Numero du mouvement",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Numero du journal du camion",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Stock Central Depart",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Livraison ou Retour",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("District",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Colline",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Produit",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Quantité",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Stock Central Retour",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Type de transport",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Motif", style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Photo du mouvement",
            style: TextStyle(fontWeight: FontWeight.bold))),
    const DataColumn(
        label: Text("Photo du journal",
            style: TextStyle(fontWeight: FontWeight.bold)))
  ];
}

List<DataRow> _createLivraisonRows(fluent.BuildContext context) {
  List<Livraison> _data = List.from(collectedLivraison);
  List<DataRow> rows = [];
  _data.map((e){
    idControllers[e.id] = TextEditingController(text: e.id.toString());
    userControllers[e.id] = TextEditingController(text: e.user);
    dateControllers[e.id] = TextEditingController(text: e.date);
    plaqueControllers[e.id] = TextEditingController(text: e.plaque);
    logisticOfficialsControllers[e.id] = TextEditingController(text: e.logisticOfficial);
    numeroMvtControllers[e.id] = TextEditingController(text: e.numeroMouvement.toString());
    numeroJournalControllers[e.id] = TextEditingController(text: e.numeroJournalDuCamion.toString());
    stockDepartControllers[e.id] = TextEditingController(text: formatStock(e.stockCentralDepart));
    districtControllers[e.id] = TextEditingController(text: e.district);
    stockRetourControllers[e.id] = TextEditingController(text: formatStock(e.stockCentralRetour));
    typeTransportControllers[e.id] = TextEditingController(text: e.typeTransport);
    motifControllers[e.id] = TextEditingController(text: e.motif);
    photoMvtControllers[e.id] = TextEditingController(text: e.photoMvt);
    photoJournalControllers[e.id] = TextEditingController(text: e.photoJournal);
    for (Boucle b in e.boucle) {
	  String key = e.id.toString();
	  keys[e.id] = key; // unique movement-boucle key for special controllers
	  livraisonRetourControllers[key] = TextEditingController(text: b.livraisonRetour);
	  collineControllers[key] = TextEditingController(text: b.colline);
	  inputControllers[key] = TextEditingController(text: b.input);
	  quantiteControllers[key] = TextEditingController(text: b.quantite);
      DataRow row = DataRow(cells: [
        DataCell(TextField(controller: idControllers[e.id],
		  enabled: false,
		  decoration: const InputDecoration(border: InputBorder.none))),

        DataCell(TextField(controller: userControllers[e.id],
		  enabled: false,
		  decoration: const InputDecoration(border: InputBorder.none))),

        DataCell(TextField(controller: dateControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none)), 
		  showEditIcon: true),

        DataCell(TextField(controller: plaqueControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value){}), showEditIcon: true),

        DataCell(TextField(controller: logisticOfficialsControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: numeroMvtControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: numeroJournalControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: stockDepartControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: livraisonRetourControllers[keys[e.id]],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: districtControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: collineControllers[keys[e.id]],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: inputControllers[keys[e.id]],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: quantiteControllers[keys[e.id]],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: stockRetourControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: typeTransportControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: motifControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value) {}), showEditIcon: true),

        DataCell(TextField(controller: photoMvtControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value){}), showEditIcon: true),

        DataCell(TextField(controller: photoJournalControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none),
		  onChanged: (value){}), showEditIcon: true),
    ]);
      rows.add(row);
    }
  }).toList();
  return rows;
}

// void popItUp(BuildContext context, String mssg) async {
// 	await showDialog(context: context,
// 		builder: (context) => ContentDialog(
// 			title: const Text("Information"),
// 			content: Text(mssg),
// 			actions: [
// 				Button(
// 					onPressed: () => Navigator.pop(context),
// 					child: const Text("Ok"),
// 				),
// 			],
// 	));
// }

// void apply(BuildContext context) async {
// 	await showDialog(context: context,
// 		builder: (context) => fluent.ContentDialog(
// 			title: const Text("Confirmation"),
// 			content: const Text("Appliquer les changements?"),
// 			actions: [
// 				fluent.Button(
// 					onPressed: () async {
// 						Navigator.pop(context);
// 						modifiedSuperviseurs.forEach((index, sup) async {
// 							bool status = await modifySuperviseurs(sup);
// 							if (status) {
// 								popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' modifié(s)");
// 							}
// 							else {
// 								popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' non modifié(s)");
// 							}
// 						});
// 						modifiedSuperviseurs = {};
// 					},
// 					child: const Text("Oui"),
// 				),
// 				fluent.Button(
// 					onPressed: () => Navigator.pop(context),
// 					child: const Text("Non"),
// 				),
// 			],
// 		)
// 	);
// }


class LivraisonData extends DataTableSource{
  fluent.BuildContext context;

  late List<DataRow> livraisonRows;

  LivraisonData({required this.context}) {
	  livraisonRows = _createLivraisonRows(context);
  }
  @override
  DataRow? getRow(int index) {
    return livraisonRows[index];
  }
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => livraisonRows.length;
  @override
  int get selectedRowCount => 0;
}

class livraisonTable extends fluent.StatefulWidget {
  final String date;
  final String? dateFin;
  const livraisonTable({super.key, required this.date, this.dateFin});

  @override
  State<livraisonTable> createState() => _livraisonTableState();
}

class _livraisonTableState extends fluent.State<livraisonTable> {
  fluent.ScrollController _horizontalController = fluent.ScrollController();
  bool isVisible = false;

  void toggleVisibility() => isVisible = !isVisible;

  @override
  fluent.Widget build(fluent.BuildContext context) {
	   if (collectedLivraison.isEmpty) {
	   	return Center(child: const Text("Pas de données"));
	   }
	  String header = widget.dateFin == null ?
	  "Livraisons du ${widget.date}" : "Livraisons du ${widget.date} au ${widget.dateFin}";
	  return fluent.SafeArea(
		  child: fluent.SingleChildScrollView(
			  scrollDirection: fluent.Axis.vertical,
			  child: fluent.Column(
			  children: [
				  fluent.Scrollbar(
					  controller: _horizontalController,
					  thumbVisibility: true,
					  child: PaginatedDataTable(
						primary: false,
						controller: _horizontalController,
						showFirstLastButtons: true,
						columns: _createLivraisonColumns(), source: LivraisonData(context: context),
						header: fluent.Center(child: fluent.Text(header)),
						rowsPerPage: collectedLivraison.length >= 8 ? 8 : collectedLivraison.length,
					  )), // ScrollBar
				]
			  ) // Column
		  ) // SingleChildScrollView
	  ); // SafeArea
  }
}
