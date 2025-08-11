import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddSuperviseurDialog extends StatefulWidget {
  final List<dynamic> lots;
  final List<dynamic> superviseursList;
  final Future<bool> Function(Superviseur) onAdd;

  const AddSuperviseurDialog({
    super.key,
    required this.lots,
    required this.superviseursList,
    required this.onAdd,
  });

  @override
  State<AddSuperviseurDialog> createState() => _AddSuperviseurDialogState();
}

class _AddSuperviseurDialogState extends State<AddSuperviseurDialog> {
  bool isAdding = false;
  final TextEditingController pssw = TextEditingController();
  final TextEditingController nom = TextEditingController();
  final TextEditingController lot = TextEditingController();
  final TextEditingController alias = TextEditingController();

  String lotChoisie = "";
  bool statusAddConfirmation = false;

  void popItUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: const Text("Info"),
        content: Text(message),
        actions: [
          Button(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text("Ajouter un superviseur"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            controller: nom,
            placeholder: "Nom complet du superviseur...",
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          TextBox(
            controller: alias,
            placeholder: "Alias du superviseur...",
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          const Divider(),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          DropDownButton(
            title: Text(lotChoisie.isEmpty ? "Choisir un lot" : lotChoisie),
            items: widget.superviseursList.isEmpty
                ? [
                    MenuFlyoutItem(text: const Text(""), onPressed: () {}),
                  ]
                : widget.lots.map<MenuFlyoutItem>((_lot) {
                    return MenuFlyoutItem(
                      text: Text(_lot.nom),
                      onPressed: () {
                        setState(() {
                          lot.text = _lot.nom;
                          lotChoisie = _lot.nom;
                        });
                      },
                    );
                  }).toList(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          const Divider(),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          PasswordBox(
            controller: pssw,
            revealMode: PasswordRevealMode.peek,
            placeholder: "Mot de passe du superviseur...",
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () async {
            if (pssw.text.isEmpty ||
                nom.text.isEmpty ||
                alias.text.isEmpty ||
                lot.text.isEmpty) {
			  return;
            }

            String password =
                sha256.convert(utf8.encode(pssw.text)).toString();

            Superviseur addedSuperviseur = Superviseur(
				nom_utilisateur: "",
				nom: "",
				lot: "",
				id: -1
			)
              ..nom = nom.text
              ..psswd = password
              ..lot = lot.text
              ..nom_utilisateur = alias.text;

            setState(() {
				isAdding = true;
            });

            bool status = await widget.onAdd(addedSuperviseur);

            setState(() {
              isAdding = false;
            });

            if (status && mounted) {
              popItUp(context, "Superviseur ajouté");
            } else if (!status && mounted) {
              popItUp(context, "Superviseur non ajouté");
            }

          },
          child: isAdding ? ProgressRing() : Text("Ajouter"),
        ),
        Button(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
      ],
    );
  }
}
