import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:new_collecteur_ui/api/livraison_api.dart';
import 'package:new_collecteur_ui/api/transfert_api.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/screens/tables/transfert_table.dart';
import 'package:new_collecteur_ui/screens/tables/livraison_table.dart';

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
	int a = 0;
	bool isModifying = false;
	bool isDeleting = false;

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

	void delete(BuildContext context) async {
			await showDialog(context: context,
				builder: (context) =>
				StatefulBuilder(builder: (context, _) {
					return ContentDialog(
						title: const Text("Entrer le numéro Id du mouvement"),
						content: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							NumberBox(
								value: a,
								onChanged: (value) {
									if (value != null) { a = value; }
									else { a = 0; }
								},
							)
						]),
						actions: [
							Button(
								onPressed: () async {
									setState(() => isDeleting = true);
									bool status = widget.program == "Transfert" ? 
										await removeTransfert(a) : await removeLivraison(a);
									setState(() => isDeleting = false);
									if (mounted && status) {
										popItUp(context, "Mouvement supprimé");
										return;
									}
									popItUp(context, "Mouvement non supprimé");
								},
								child: isDeleting ? ProgressRing() : Text("Supprimer"),
							),
							Button(
								onPressed: () => Navigator.pop(context),
								child: const Text("Retour"),
							),
						],
					); // ContentDialog
			}) //StatefulBuilder
		); // showDialog
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
					CommandBarButton(onPressed: (){
						delete(context);
					},
						icon: isDeleting ? ProgressRing() : Icon(material.Icons.delete),
						label: Text("Supprimer un mouvement")
					),
					CommandBarButton(onPressed: (){
					},
						icon: isDeleting ? ProgressRing() : Icon(FluentIcons.excel_document),
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
