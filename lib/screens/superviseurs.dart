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
	bool statusDeleteConfirmation = false;
	bool statusAddConfirmation = false;
	bool statusApplyConfirmation = false;
	bool isDeleting = false;
	bool isModifying = false;
	String lot = "Nouveau Lot pour le superviseur...";
	String lotChoisie = "Lot d'opération du superviseur...";
	Superviseur addedSuperviseur = Superviseur(nom_utilisateur: "", id: 0, lot: "", nom: "");

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

	void apply(BuildContext context) async {
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Confirmation"),
				content: const Text("Appliquer les changements?"),
				actions: [
					Button(
						onPressed: () async {
							statusApplyConfirmation = true;
							Navigator.pop(context);
						},
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
						onPressed: (){
							setState(() {
								modifiedSuperviseurs = {};
							});
						},
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
		TextEditingController pssw = TextEditingController();
		TextEditingController nom = TextEditingController();
		TextEditingController lot = TextEditingController();
		TextEditingController alias = TextEditingController();

		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Ajouter un superviseur"),
				content: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					mainAxisSize: MainAxisSize.min,
					children: [
						TextBox(
							controller: nom,
							placeholder: "Nom complet du superviseur...",
						),
						SizedBox(height: MediaQuery.of(context).size.height/25),
						TextBox(
							controller: alias,
							placeholder: "Alias du superviseur...",
						),
						SizedBox(height: MediaQuery.of(context).size.height/25),
						Divider(),
						SizedBox(height: MediaQuery.of(context).size.height/25),
						DropDownButton(
							title: Text(lotChoisie),
							items: superviseursList.isEmpty ? [
								MenuFlyoutItem(text: Text(""), onPressed: (){})
							] : lots.map<MenuFlyoutItem>((_lot) {
								return MenuFlyoutItem(text: Text(_lot.nom), onPressed: () {
									setState(() {
										lot.text = _lot.nom;
										lotChoisie = _lot.nom;
									});
								});
							}).toList(),
						), // DropDownButton
						SizedBox(height: MediaQuery.of(context).size.height/25),
						Divider(),
						SizedBox(height: MediaQuery.of(context).size.height/25),
						PasswordBox(
							controller: pssw,
							revealMode: PasswordRevealMode.peek,
							placeholder: "Mot de passe du superviseur...",
						),
					],
				), // Column
				actions: [
					Button(
						onPressed: () async {
							if (pssw.text.isEmpty || nom.text.isEmpty || alias.text.isEmpty || lot.text.isEmpty) {
								return; }
							setState(() {
							  statusAddConfirmation = true;
							});
							String password = sha256.convert(utf8.encode(pssw.text)).toString();
							addedSuperviseur.nom = nom.text;
							addedSuperviseur.psswd = password;
							addedSuperviseur.lot = lot.text;
							addedSuperviseur.nom_utilisateur = alias.text;
							bool status = await addSuperviseurs(addedSuperviseur);
							if (status && mounted) {
								statusAddConfirmation = true;
								popItUp(context, "Superviseur ajouté");
							}
							else if (!status && mounted) {
								popItUp(context, "Superviseur non ajouté");
							}
							setState(() {
							  statusAddConfirmation = false;
							});
							Navigator.pop(context);
						},
						child: Text("Ajouter"),
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
		await showDialog(context: context,
			builder: (context) => ContentDialog(
				title: const Text("Confirmation"),
				content: Text("Voulez-vous supprimer le superviseur '${s.nom_utilisateur}'?"),
				actions: [
					Button(
						onPressed: () {
							statusDeleteConfirmation = true;
							setState(() {
								isDeleting = true;
							});
							Navigator.pop(context);
						},
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

	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
			title: Text("Superviseurs"),
			commandBar: CommandBar(primaryItems: [
				CommandBarButton(
					onPressed: () async {
						setState(() {
						  statusAddConfirmation = true;
						});
						addSuperviseur(context);
					},
					label: statusAddConfirmation ? ProgressRing() : Text("Ajouter un superviseur"),
					icon: Icon(FluentIcons.add)
				),
				CommandBarButton(
					onPressed: () {
						if (modifiedSuperviseurs.isEmpty) {
							popItUp(context, "Pas de changement(s) enregistré(s)");
							return;
						}
						apply(context);
						if (statusApplyConfirmation) {
							setState(() {
								isModifying = true;
							});
							modifiedSuperviseurs.forEach((index, sup) async {
								bool status = await modifySuperviseurs(sup);
								if (status && mounted) {
									popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' modifié(s)");
									modifiedSuperviseurs = {};
								}
								else if (mounted && !status) {
									popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' non modifié(s)");
								}
							});
							setState(() {
								isModifying = false;
							});
						}
					},
					label: isModifying ? ProgressBar() : Text("Appliquer"),
					tooltip: "Appliquer les changements",
					icon: Icon(FluentIcons.accept)
				),
				CommandBarButton(
					onPressed: () => modifiedSuperviseurs.isEmpty ? popItUp(context, "Pas de changement(s) enregistré(s)") :
					deny(context),
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
					final username = superviseur.nom_utilisateur;
					final lot = superviseur.lot;
					final nom = superviseur.nom;
					final pssw = superviseur.psswd;

					TextEditingController usernameController = TextEditingController();
					TextEditingController lotController = TextEditingController();
					TextEditingController nomController = TextEditingController();
					TextEditingController psswController = TextEditingController();
					return Expander(
						leading: isDeleting ? ProgressRing() : IconButton(onPressed: () async {
							delete(superviseur);
							if (statusDeleteConfirmation && mounted) {
								bool deleteStatus = await deleteSuperviseurs(superviseur);
								if (deleteStatus && mounted) {
									deletePopItUp(context, "Superviseur supprimé");
								}
								else if (!deleteStatus && mounted) {
									deletePopItUp(context, "Superviseur non supprimé");
								}
								setState(() {
									isDeleting = false;
								});
							}

						},
						icon: Icon(FluentIcons.calculator_multiply)),
						trailing: IconButton( 
							onPressed: () => setState(() {
								usernameController.text = "";
								lotController.text = "";
								nomController.text = "";
								psswController.text = "";
							}),
							icon: Icon(FluentIcons.refresh)
						),
						header: TextBox(
							controller: usernameController,
							placeholder: superviseur.nom_utilisateur,
							onChanged: (newUsername) {
								if (newUsername.isEmpty) {
									superviseur.nom_utilisateur = username;
								}
								else {
									superviseur.nom_utilisateur = newUsername;
								}
								modifiedSuperviseurs[superviseur.id] = superviseur;
							},
						), // TextBox
						content: Column(
						children: [
							TextBox(
								controller: lotController,
								placeholder: superviseur.lot,
								onChanged: (newLot) {
									if (newLot.isNotEmpty) {
										superviseur.lot = newLot;
										modifiedSuperviseurs[superviseur.id] = superviseur;
									}
									else {
										superviseur.lot = lot;
									}
								},
							),
							TextBox(
								controller: nomController,
								placeholder: superviseur.nom,
								onChanged: (newNom) {
									if (newNom.isNotEmpty) {
										superviseur.nom = newNom;
										modifiedSuperviseurs[superviseur.id] = superviseur;
									}
									else {
										superviseur.nom = nom;
									}
								},
							),
							PasswordBox(
								controller: psswController,
								placeholder: pssw ?? "Nouveau mot de passe pour le superviseur...",
								revealMode: PasswordRevealMode.peek,
								onChanged: (newPassword) {
									if (newPassword.isEmpty) {
										superviseur.psswd = null;
									}
									else {
										String password = sha256.convert(utf8.encode(newPassword)).toString();
										superviseur.psswd = password;
									}
									modifiedSuperviseurs[superviseur.id] = superviseur;
								},
							), // PasswordBox
						]
					) // Column
					); // Expander
				}
			),
		);
	  }
}
