import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';

class Mouvements extends StatefulWidget {
  const Mouvements({super.key});

  @override
  State<Mouvements> createState() => _MouvementsState();
}

class _MouvementsState extends State<Mouvements> {
	DateTime? dateDebut;
	DateTime? dateFin;
	String program = "Program";
	String superviseur = "Superviseur";
	bool isCharging = false;

	void popItUp(BuildContext context, String mssg) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Status du chargement"),
				content: Text(mssg),
				actions: [
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Ok"),
					),
				],
			)
		);
	}
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
				commandBar: CommandBar(primaryItems: [
					CommandBarButton(
						onPressed: () async {
							setState(() {
								isCharging = true;
							});
							bool initStatus = await init();
							if (!initStatus) {
								popItUp(context, "Le chargement a échoué");
								setState(() {
									isCharging = false;
								});
								return;
							}
							popItUp(context, "Le chargement s'est effectué avec succès");
							setState(() {
								isCharging = false;
							});
						},
						icon: isCharging ? ProgressRing() : Icon(FluentIcons.refresh),
						label: const Text("Charger")
					)
				]),
				title: const Text("Mouvements")
			),
			content: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								const Text("Date début:"),
								Divider(),
								DatePicker(
									header: "Choisissez une date",
									selected: dateDebut,
									onChanged: (date) => setState(() => dateDebut = date ),
									locale: Locale('fr')
								)
							],
						), // Row
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								const Text("Date fin:"),
								Divider(),
								DatePicker(
									header: "Choisissez une date",
									selected: dateFin,
									onChanged: (date) => setState(() => dateFin = date ),
									locale: Locale('fr')
								)
							],
						), // Row
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Divider(),
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								const Text("Type de mouvements:"),
								DropDownButton(
									title: Text(program),
									items: types_mouvement.map<MenuFlyoutItem>((type) {
										return MenuFlyoutItem(text: Text(type), onPressed: () {
											setState(() {
												program=type.toString();
											});
										});
									}).toList(),
								)
							],
						), // Row
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Divider(),
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								const Text("Superviseur:"),
								DropDownButton(
									title: Text(superviseur),
									items: superviseursList.isEmpty ? [
										MenuFlyoutItem(text: Text(""), onPressed: (){})
									] : superviseursList.map<MenuFlyoutItem>((superv) {
										return MenuFlyoutItem(text: Text(superv.nom_utilisateur), onPressed: () {
											setState(() {
												superviseur=superv.nom_utilisateur;
											});
										});
									}).toList(),
								)
							],
						), // Row
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						Button(
							onPressed: () => getSuperviseurs(),
							child: const Text("Continuer", style: TextStyle(fontSize: 22)),
						)
					],
				)
		); // ScaffoldPage
	  }
}
