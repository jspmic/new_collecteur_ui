import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';

class Superviseurs extends StatefulWidget {
  const Superviseurs({super.key});

  @override
  State<Superviseurs> createState() => _SuperviseursState();
}

class _SuperviseursState extends State<Superviseurs> {
	bool isDeleting = false;

	void apply(BuildContext context) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Confirmation"),
				content: const Text("Appliquer les changements?"),
				actions: [
					Button(
						onPressed: (){},
						child: const Text("Oui"),
					),
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Non"),
					),
				],
			)
		);
	}

	void deny(BuildContext context) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Confirmation"),
				content: const Text("Annuler les changements?"),
				actions: [
					Button(
						onPressed: (){},
						child: const Text("Oui"),
					),
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Non"),
					),
				],
			)
		);
	}

	void addSuperviseur(BuildContext context) async {
		bool isLoading = false;
		TextEditingController pssw = TextEditingController();
		TextEditingController nom = TextEditingController();
		Superviseur s = Superviseur(nom_utilisateur: "", id: 0);
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Ajouter un superviseur"),
				content: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					mainAxisSize: MainAxisSize.min,
					children: [
						TextBox(
							controller: nom,
							placeholder: "Nom du superviseur (minuscule, sans espace)",
						),
						SizedBox(height: MediaQuery.of(context).size.height/25),
						PasswordBox(
							controller: pssw,
							revealMode: PasswordRevealMode.peek,
							placeholder: "Mot de passe...",
						),
					],
				), // Column
				actions: [
					Button(
						onPressed: () async {
							if (pssw.text.isEmpty || nom.text.isEmpty) {
								return;
							}
							String password = sha256.convert(utf8.encode(pssw.text)).toString();
							s.nom_utilisateur = nom.text;
							s.psswd = password;
							bool status = await addSuperviseurs(s);
							if (status) {
								Navigator.pop(context);
								// Add a new Popup here to show the status
							}
							else {
								// Add a new Popup here to show the status
							}
						},
						child: isLoading ? ProgressRing() : Text("Ajouter"),
					),
					Button(
						onPressed: () => Navigator.pop(context),
						child: const Text("Annuler"),
					),
				],
			)
		);
		setState(() { });
	}

	void deletePopItUp(BuildContext context, String mssg) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Status de l'opération"),
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

	void delete(Superviseur s) async {
		setState(() {
			isDeleting = true;
		});
		bool deleteStatus = await deleteSuperviseurs(s);
		if (deleteStatus) {
			deletePopItUp(context, "Superviseur supprimé");
		}
		else {
			deletePopItUp(context, "Superviseur non supprimé");
		}
		setState(() {
			isDeleting = false;
		});
	}

	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
			title: Text("Superviseurs"),
			commandBar: CommandBar(primaryItems: [
				CommandBarButton(
					onPressed: () => addSuperviseur(context),
					label: Text("Ajouter un superviseur"),
					icon: Icon(FluentIcons.add)
				),
				CommandBarButton(
					onPressed: () => apply(context),
					label: Text("Appliquer"),
					tooltip: "Appliquer les changements",
					icon: Icon(FluentIcons.accept)
				),
				CommandBarButton(
					onPressed: () => deny(context),
					label: Text("Annuler"),
					tooltip: "Annuler les changements",
					icon: Icon(FluentIcons.calculator_multiply)
				)
			]),
			), // PageHeader
			content: ListView.builder(
				shrinkWrap: true,
				itemCount: superviseursList.length,
				itemBuilder: (context, index) {
					final superviseur = superviseursList[index];
					final pssw = superviseur.psswd;
					return Expander(
						leading: isDeleting ? ProgressRing() : IconButton(onPressed: () => delete(superviseur),
						icon: Icon(FluentIcons.calculator_multiply)),
						header: TextBox(placeholder: superviseur.nom_utilisateur),
						content: PasswordBox(placeholder: pssw ?? "Nouveau mot de passe pour le superviseur...", revealMode: PasswordRevealMode.peek),
					); // Expander
				}
			),
		);
	  }
}
