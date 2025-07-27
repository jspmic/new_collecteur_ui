import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/api/annonces_api.dart';

class Annonces extends StatefulWidget {
  const Annonces({super.key});

  @override
  State<Annonces> createState() => _AnnoncesState();
}

class _AnnoncesState extends State<Annonces> {
	String annonce = "";
	String superviseur = "Tous";
	int userId = -1;
	bool isAnnouncing = false;
	DateTime? dateSelected;
	DateTime now = DateTime.now();

	void popItUp(BuildContext context, String mssg, String sub) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: Text(mssg),
				content: Text(sub),
				actions: [
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Ok"),
					),
				],
			)
		);
	}

	void announce() async {
		if (dateSelected == null || annonce.isEmpty) {
			return;
		}
		Duration diff = dateSelected!.difference(DateTime.now());
		int timeout = diff.inSeconds;
		setState(() {
				  isAnnouncing = true;
				});
		bool status = await postAnnouncement(userId: userId,
							timeout: timeout, announcement: annonce);
		setState(() {
				  isAnnouncing = false;
				});
		if (status && mounted) {
			if (userId == -1) {
				popItUp(context, "Tous les superviseurs ont reçu l'annonce",
						"Il/elle verra l'annonce lors de leurs prochaines sessions pendant ${diff.inHours} heure(s)");
			}
			else {
				popItUp(context, "Le superviseur a reçu l'annonce",
				"Il/elle verra l'annonce lors de ses prochaines sessions pendant ${diff.inHours} heure(s)");
			}
		}
		else if (!status && mounted) {
				popItUp(context, "L'annonce n'a pas été envoyé", "Vérifier votre connexion ou contactez le maintaineur");
		}
	}

	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text("Annonces"))),
			content: Column(
				children: [
					SizedBox(
						height: MediaQuery.of(context).size.height/15,
					), // SizedBox
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						children: [
							const Text("Superviseur (par défaut: Tous) :"),
							DropDownButton(
								title: Text(superviseur),
								items: superviseursList.isEmpty ? [
									MenuFlyoutItem(text: Text(""), onPressed: (){})
								] : superviseursList.map<MenuFlyoutItem>((superv) {
									return MenuFlyoutItem(text: Text(superv.nom_utilisateur), onPressed: () {
										setState(() {
											userId = superv.id;
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

					Divider(),

					SizedBox(
						height: MediaQuery.of(context).size.height/15,
					), // SizedBox

					Row(
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						children: [
							const Text("Date de disparition de l'annonce:"),
							Divider(),
							DatePicker(
								showYear: false,
								startDate: DateTime(now.year, now.month, now.day+1),
								endDate: DateTime(now.year, now.month+1),
								selected: dateSelected,
								onChanged: (date) => setState(() => dateSelected = date ),
								locale: Locale('fr')
							)
						],
					), // Row
					SizedBox(
						height: MediaQuery.of(context).size.height/15,
					), // SizedBox

					SizedBox(
						width: MediaQuery.of(context).size.width/2,
						child: TextBox(
							placeholder: "Annonce...",
							onChanged: (value) => annonce = value,
							maxLines: 3,
						), // TextBox
					), // SizedBox
					SizedBox(
						height: MediaQuery.of(context).size.height/15,
					), // SizedBox
					isAnnouncing ? ProgressRing() : Button(
						onPressed: () => announce(), 
						child: const Text("Annoncer", style: TextStyle(fontSize: 22)),
					),
					SizedBox(
						height: MediaQuery.of(context).size.height/15,
					), // SizedBox
					Text("Une annonce déstinée à un superviseur annule la précédente", style: TextStyle(color: Colors.red))
				],
			), // Column
		); //ScaffoldPage
	  }
}
