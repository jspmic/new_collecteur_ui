import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';
import 'package:new_collecteur_ui/api/transfert_api.dart';
import 'package:new_collecteur_ui/api/livraison_api.dart';
import 'package:new_collecteur_ui/screens/afficher_mouvements.dart';
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
	bool isPopulating = false;
	int userId = -1;

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

	void getMouvements() async {
		if (dateDebut == null) {
			popItUp(context, "Veuillez sélectionner au moins la date de début");
			return;
		}
		if (!(types_mouvement.contains(program))) {
			popItUp(context, "Veuillez choisir le type de mouvements");
			return;
		}

		setState(() {
			isPopulating = true;
		});
		bool retrievingStatus = false;
		if (program == "Transfert") {
			retrievingStatus = await getTransferts(dateDebut, dateFin, userId);
		}
		else {
			retrievingStatus = await getLivraisons(dateDebut, dateFin, userId);
		}

		setState(() {
			isPopulating = false;
		});
		if (retrievingStatus && mounted) {
			Navigator.push(
				context,
				PageRouteBuilder(pageBuilder: (context, _, _) => AfficherMouvements(
					dateDebut: formatDate(dateDebut),
					dateFin: formatDate(dateFin),
					program: program
					) // AfficherMouvements
				) // PageRouteBuilder
			);
		}
		else if (mounted && !retrievingStatus) {
			popItUp(context, "Erreur de chargement des mouvements");
		}
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
			content: SingleChildScrollView(
			child: Column(
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
									startDate: DateTime(2004),
									endDate: DateTime(2090),
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
									startDate: DateTime(2003),
									endDate: DateTime(2090),
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
									items: superviseursList.isEmpty ? [MenuFlyoutItem(text: Text("Aucun"), onPressed: () => userId = -1)]
									: superviseursList.map<MenuFlyoutItem>((superv) {
										return MenuFlyoutItem(text: Text(superv.nom_utilisateur), onPressed: () {
											setState(() {
												userId = superv.id;
												superviseur=superv.nom_utilisateur;
											});
										});
									}).toList(),
								) // DropDownButton
							],
						), // Row
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
						isPopulating ? ProgressRing() : Button(
							onPressed: () => getMouvements(),
							child: const Text("Continuer", style: TextStyle(fontSize: 22)),
						),
						SizedBox(
							height: MediaQuery.of(context).size.height/15,
						), // SizedBox
					],
				) // Column
			) // SingleChildScrollView
		); // ScaffoldPage
	  }
}
