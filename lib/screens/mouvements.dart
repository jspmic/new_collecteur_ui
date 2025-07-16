import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';
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
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: Center(
				heightFactor: 2,
				child: const Text("Mouvements", style: TextStyle(fontSize: 24)),
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
								DatePicker(
									header: "Choisissez une date",
									selected: dateDebut,
									onChanged: (date) => setState(() => dateDebut = date ),
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
								DatePicker(
									header: "Choisissez une date",
									selected: dateFin,
									onChanged: (date) => setState(() => dateFin = date ),
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
									items: superviseurs.map<MenuFlyoutItem>((superv) {
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
							onPressed: (){},
							child: const Text("Continuer", style: TextStyle(fontSize: 22)),
						)
					],
				)
		); // ScaffoldPage
	  }
}
