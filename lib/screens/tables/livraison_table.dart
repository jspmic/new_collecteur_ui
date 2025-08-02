import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/api/livraison_api.dart';

Map<String, Map<String, String>> modifiedLivraisons = {};

// Function to format stock central
String formatStock(String stock){
  return stock.replaceAll('_', ' ');
}

// Controllers for this kind of table
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
        label: Text("", style: TextStyle(fontWeight: FontWeight.bold))),
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

List<DataRow> _createLivraisonRows() {
  List<Livraison> _data = List.from(collectedLivraison);
  List<DataRow> rows = [];
  _data.map((e){
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
        DataCell(IconButton(icon: const Icon(Icons.remove, color: Colors.red), onPressed: (){})),
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


class LivraisonData extends DataTableSource{
  List<DataRow> livraisonRows = _createLivraisonRows();
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


Widget livraisonTable({required String date, String? dateFin}) {
  if (collectedLivraison.isEmpty){
    return const Center(child: Text("Pas de données", style: TextStyle(color: Colors.grey)));
  }
  fluent.ScrollController _horizontalController = fluent.ScrollController();
  String header = dateFin == null ?
  "Livraisons du $date" : "Livraisons du $date au $dateFin";

  if (collectedLivraison.isEmpty) {
  	return Text("Pas de données");
  }
  return fluent.SafeArea(
      child: fluent.SingleChildScrollView(
          scrollDirection: fluent.Axis.vertical,
          child: fluent.Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              child: PaginatedDataTable(
                primary: false,
                controller: _horizontalController,
                showFirstLastButtons: true,
                columns: _createLivraisonColumns(), source: LivraisonData(),
                header: fluent.Center(child: fluent.Text(header)),
                rowsPerPage: collectedLivraison.length >= 8 ? 8 : collectedLivraison.length,
              ))
      ));
  }
