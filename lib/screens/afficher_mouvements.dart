import 'dart:io';
import 'package:new_collecteur_ui/models/livraison.dart';
import 'package:new_collecteur_ui/screens/widgets/remove_mouvement.dart';
import 'package:path/path.dart' as p;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';
import 'package:new_collecteur_ui/screens/tables/transfert_table.dart';
import 'package:new_collecteur_ui/screens/tables/livraison_table.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

Future<bool> writeCounter(String fileName, List<int> bytes) async {
	if (collectedTransfert.isEmpty && collectedLivraison.isEmpty) {
		return false;
	}
	String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

	if (selectedDirectory == null) {
		return false;
	}

	File file = File(p.join(selectedDirectory, fileName));
	try {
		file.writeAsBytes(bytes);
	} on Exception {
		// Deal with exceptions in a friendly way
		return false;
	}

	return true;
}
class AfficherMouvements extends StatefulWidget {
  final String dateDebut;
  final String dateFin;
  final String program;
  const AfficherMouvements({
	  super.key,
	  required this.dateDebut,
	  required this.dateFin,
	  required this.program,
  });

  @override
  State<AfficherMouvements> createState() => _AfficherMouvementsState();
}

class _AfficherMouvementsState extends State<AfficherMouvements> {
	bool isModifying = false;

	void popItUp(BuildContext context, String mssg) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Information"),
				content: Text(mssg),
				actions: [
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Ok"),
					),
				],
		));
	}

	bool isLoading = false;
	Color? stateColor;

	void storeTransfert() async {
		final xcel.Workbook workbook = xcel.Workbook();
		final xcel.Worksheet sheet = workbook.worksheets[0];
		sheet.getRangeByIndex(1, 1).setText("Date");
		sheet.getRangeByIndex(1, 2).setText("Plaque");
		sheet.getRangeByIndex(1, 3).setText("Logistic Official");
		sheet.getRangeByIndex(1, 4).setText("Numero du mouvement");
		sheet.getRangeByIndex(1, 5).setText("Numero du journal du camion");
		sheet.getRangeByIndex(1, 6).setText("Stock Central Depart");
		sheet.getRangeByIndex(1, 7).setText("Succession des stocks");
		sheet.getRangeByIndex(1, 8).setText("Stock Central Retour");
		sheet.getRangeByIndex(1, 9).setText("Type de transport");
		sheet.getRangeByIndex(1, 10).setText("Motif");
		sheet.getRangeByIndex(1, 11).setText("Photo du mouvement");
		sheet.getRangeByIndex(1, 12).setText("Photo du journal du camion");
		DateFormat format = DateFormat("dd/MM/yyyy");
		for (var i = 0; i < collectedTransfert.length; i++) {
		  final item = collectedTransfert[i];
		  DateTime dateTime = format.parse(item.date);
		  sheet.getRangeByIndex(i + 2, 1).setDateTime(dateTime);
		  sheet.getRangeByIndex(i + 2, 2).setText(item.plaque);
		  sheet.getRangeByIndex(i + 2, 3).setText(item.logisticOfficial);
		  sheet.getRangeByIndex(i + 2, 4).setNumber(item.numeroMouvement.toDouble());//.setText(item.numero_mouvement.toString());
		  sheet.getRangeByIndex(i + 2, 5).setNumber(item.numeroJournalDuCamion.toDouble());
		  sheet.getRangeByIndex(i + 2, 6).setText(formatStock(item.stockCentralDepart));
		  sheet.getRangeByIndex(i + 2, 7).setText(stockSuivantsControllers[item.id.toString()]!.text);
		  sheet.getRangeByIndex(i + 2, 8).setText(formatStock(item.stockCentralRetour));
		  sheet.getRangeByIndex(i + 2, 9).setText(item.typeTransport);
		  sheet.getRangeByIndex(i + 2, 10).setText(item.motif);
		  sheet.hyperlinks.add(sheet.getRangeByIndex(i + 2, 11), xcel.HyperlinkType.url, item.photoMvt);
		  sheet.hyperlinks.add(sheet.getRangeByIndex(i + 2, 12), xcel.HyperlinkType.url, item.photoJournal);
		}
		final List<int> bytes = workbook.saveAsStream();
		String date = widget.dateDebut.replaceAll('/', '_');
		String now = DateFormat('hh_mm_ss_a').format(DateTime.now());
		String filename = "Transferts_${date}_$now.xlsx";
		bool status = await writeCounter(filename, bytes);
		workbook.dispose();
		if (status) {
			popItUp(context, "Consulter le fichier '$filename' dans le répértoire choisi");
			setState(() {
			  stateColor = Colors.green;
			});
		}
		else {
			popItUp(context, "Aucun enregistrement n'a eu lieu");
			setState(() {
			  stateColor = Colors.red;
			});
		}
	}

	void storeLivraison() async{
		int count = 2;
		setState(() {
		  stateColor = Colors.blue;
		});
		final xcel.Workbook workbook = xcel.Workbook();
		final xcel.Worksheet sheet = workbook.worksheets[0];
		sheet.getRangeByIndex(1, 1).setText("Date");
		sheet.getRangeByIndex(1, 2).setText("Plaque");
		sheet.getRangeByIndex(1, 3).setText("Logistic Official");
		sheet.getRangeByIndex(1, 4).setText("Numero du mouvement");
		sheet.getRangeByIndex(1, 5).setText("Numero du journal du camion");
		sheet.getRangeByIndex(1, 6).setText("Stock Central Depart");
		sheet.getRangeByIndex(1, 7).setText("Livraison ou Retour");
		sheet.getRangeByIndex(1, 8).setText("District");
		sheet.getRangeByIndex(1, 9).setText("Colline");
		sheet.getRangeByIndex(1, 10).setText("Produit");
		sheet.getRangeByIndex(1, 11).setText("Quantité");
		sheet.getRangeByIndex(1, 12).setText("Stock Central Retour");
		sheet.getRangeByIndex(1, 13).setText("Type de transport");
		sheet.getRangeByIndex(1, 14).setText("Motif");
		sheet.getRangeByIndex(1, 15).setText("Photo du mouvement");
		sheet.getRangeByIndex(1, 16).setText("Photo du journal du camion");
		DateFormat format = DateFormat("dd/MM/yyyy");
		for (var i = 0; i < collectedLivraison.length; i++) {
		  for (Boucle j in collectedLivraison[i].boucle) {
			Livraison item = collectedLivraison[i];
			DateTime dateTime = format.parse(item.date);
			sheet.getRangeByIndex(i + count, 1).setDateTime(dateTime);
			sheet.getRangeByIndex(i + count, 2).setText(item.plaque);
			sheet.getRangeByIndex(i + count, 3).setText(item.logisticOfficial);
			sheet.getRangeByIndex(i + count, 4).setNumber(item.numeroMouvement
				.toDouble());
			sheet.getRangeByIndex(i + count, 5).setNumber(item.numeroJournalDuCamion
				.toDouble());
			sheet.getRangeByIndex(i + count, 6).setText(formatStock(item.stockCentralDepart));
			sheet.getRangeByIndex(i + count, 7).setText(j.livraisonRetour);
			sheet.getRangeByIndex(i + count, 8).setText(item.district);
			sheet.getRangeByIndex(i + count, 9).setText(j.colline);
			sheet.getRangeByIndex(i + count, 10).setText(j.input);
			try {
			  sheet.getRangeByIndex(i + count, 11).setNumber(double.parse(j.quantite));
			}
			on FormatException {
			  sheet.getRangeByIndex(i + count, 11).setText(j.quantite);
			}
			sheet.getRangeByIndex(i + count, 12).setText(formatStock(item.stockCentralRetour));
			sheet.getRangeByIndex(i + count, 13).setText(item.typeTransport);
			sheet.getRangeByIndex(i + count, 14).setText(item.motif);
			sheet.hyperlinks.add(
				sheet.getRangeByIndex(i + count, 15), xcel.HyperlinkType.url,
				item.photoMvt);
			sheet.hyperlinks.add(
				sheet.getRangeByIndex(i + count, 16), xcel.HyperlinkType.url,
				item.photoJournal);
			count++;
		  }
		}
		final List<int> bytes = workbook.saveAsStream();
		String date = widget.dateDebut.replaceAll('/', '_');
		String now = DateFormat('hh_mm_ss_a').format(DateTime.now());
		String filename = "Livraisons_${date}_$now.xlsx";
		bool status = await writeCounter(filename, bytes);
		workbook.dispose();
		if (status) {
			popItUp(context, "Consulter le fichier '$filename' dans le répértoire choisi");
			setState(() {
			  stateColor = Colors.green;
			});
		}
		else {
			setState(() {
			popItUp(context, "Aucun enregistrement n'a eu lieu");
			  stateColor = Colors.red;
			});
		}
	}
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
				leading: IconButton(
					onPressed: () {
						collectedTransfert.clear();
						collectedLivraison.clear();
						Navigator.pop(context);
					},
					icon: Icon(FluentIcons.back)
				),
				commandBar: CommandBar(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				primaryItems: [
					CommandBarButton(onPressed: (){},
						icon: Icon(material.Icons.arrow_circle_up_outlined),
						label: Text("Appliquer les changements")
					),
					CommandBarButton(onPressed: () async {
						await showDialog(context: context,
							builder: (context) => DeleteMouvementDialog(program: widget.program)
						);
						setState(() {});
					},
						icon: Icon(material.Icons.delete),
						label: Text("Supprimer un(e) ${widget.program.toLowerCase()}")
					),
					CommandBarButton(onPressed: () => widget.program == "Transfert" ? storeTransfert() : storeLivraison(),
						icon: Icon(FluentIcons.excel_document),
						label: Text("Générer un fichier excel")
					),
				]),
			),
			content: widget.program == "Transfert" ? 
					transfertTable(date: widget.dateDebut, dateFin: widget.dateFin)
					: livraisonTable(date: widget.dateDebut, dateFin: widget.dateFin.isEmpty ? null : widget.dateFin)
		);
	  }
}
