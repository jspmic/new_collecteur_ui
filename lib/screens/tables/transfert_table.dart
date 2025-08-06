import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/transfert.dart';
import 'package:new_collecteur_ui/api/transfert_api.dart';
import 'package:new_collecteur_ui/screens/tables/livraison_table.dart';

// Global controllers for Livraison and Transfert
Map<int, TextEditingController> idControllers = {};
Map<int, TextEditingController> userControllers = {};
Map<int, TextEditingController> dateControllers = {};
Map<int, TextEditingController> logisticOfficialsControllers = {};
Map<int, TextEditingController> numeroMvtControllers = {};
Map<int, TextEditingController> numeroJournalDuCamionControllers = {};
Map<int, TextEditingController> plaqueControllers = {};
Map<int, TextEditingController> stockDepartControllers = {};
Map<int, TextEditingController> stockRetourControllers = {};
Map<int, TextEditingController> typeTransportControllers = {};
Map<int, TextEditingController> motifControllers = {};
Map<int, TextEditingController> photoMvtControllers = {};
Map<int, TextEditingController> photoJournalControllers = {};

// Transfert-specific controller
Map<String, TextEditingController> stockSuivantsControllers = {};

String formatStock(String stock){
  return stock.replaceAll('_', ' ');
}

TextEditingController printStockSuivants(Transfert objTransf){
  String result = "";
  for (String stock in objTransf.stockCentralSuivants){
    result += "${formatStock(stock)} - ";
  }
  stockSuivantsControllers[objTransf.id.toString()] = TextEditingController(text: result);
  return stockSuivantsControllers[objTransf.id.toString()]!;
}

List<DataColumn> _createTransfertColumns() {
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
        label: Text("Succession des stocks",
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

List<DataRow> _createTransfertRows() {
  List<Transfert> data = List.from(collectedTransfert);
  return data.map((e) {
    idControllers[e.id] = TextEditingController(text: e.id.toString());
    userControllers[e.id] = TextEditingController(text: e.user);
    dateControllers[e.id] = TextEditingController(text: e.date);
    plaqueControllers[e.id] = TextEditingController(text: e.plaque);
    logisticOfficialsControllers[e.id] = TextEditingController(text: e.logisticOfficial);
    numeroMvtControllers[e.id] = TextEditingController(text: e.numeroMouvement.toString());
    numeroJournalDuCamionControllers[e.id] = TextEditingController(text: e.numeroJournalDuCamion.toString());
    stockDepartControllers[e.id] = TextEditingController(text: formatStock(e.stockCentralDepart));
    stockRetourControllers[e.id] = TextEditingController(text: formatStock(e.stockCentralRetour));
    typeTransportControllers[e.id] = TextEditingController(text: e.typeTransport);
    motifControllers[e.id] = TextEditingController(text: e.motif);
    photoMvtControllers[e.id] = TextEditingController(text: e.photoMvt);
    photoJournalControllers[e.id] = TextEditingController(text: e.photoJournal);
    printStockSuivants(e);
    return DataRow(cells: [
	  DataCell(TextField(controller: idControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none),
		enabled: false)
		),

	  DataCell(TextField(controller: userControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none),
		enabled: false),
		),

	  DataCell(TextField(controller: dateControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: plaqueControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: logisticOfficialsControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: numeroMvtControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: numeroJournalDuCamionControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: stockDepartControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

      DataCell(TextField(controller: stockSuivantsControllers[e.id.toString()]),
	  	showEditIcon: true
	  ),

	  DataCell(TextField(controller: stockRetourControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true),

	  DataCell(TextField(controller: typeTransportControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none),
		), showEditIcon: true),

	  DataCell(TextField(controller: motifControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true
		),

	  DataCell(TextField(
		  controller: photoMvtControllers[e.id],
		  decoration: const InputDecoration(border: InputBorder.none)),
		  showEditIcon: true
		),

	  DataCell(TextField(controller: photoJournalControllers[e.id],
		decoration: const InputDecoration(border: InputBorder.none)),
		showEditIcon: true
		)
    ]);
  }).toList();
}


class TransfertData extends DataTableSource{
  List<DataRow> transfertRows = _createTransfertRows();
  @override
  DataRow? getRow(int index) {
    return transfertRows[index];
  }
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => transfertRows.length;
  @override
  int get selectedRowCount => 0;
}



Widget transfertTable({required String date, String? dateFin}) {
  ScrollController _horizontalController = ScrollController();
  String header;
  header = dateFin == null ?
  "Transferts du $date" : "Transferts du $date au $dateFin";

  if (collectedTransfert.isEmpty) {
  	return Center(child: Text("Pas de données"));
  }
  return SafeArea(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: fluent.Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              child: PaginatedDataTable(
                primary: false,
                controller: _horizontalController,
                showFirstLastButtons: true,
                columns: _createTransfertColumns(), source: TransfertData(),
                header: Center(child: Text(header)),
                rowsPerPage: collectedTransfert.length >= 20 ? 20 : collectedTransfert.length,
              ))
      ));
}
