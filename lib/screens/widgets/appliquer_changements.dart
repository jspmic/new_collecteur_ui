import 'dart:convert';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ApplyChanges extends StatefulWidget {
  final Future<bool> Function(Superviseur) onModify;

  const ApplyChanges({
    super.key,
    required this.onModify,
  });

  @override
  State<ApplyChanges> createState() => _ApplyChangesState();
}

class _ApplyChangesState extends State<ApplyChanges> {
  bool isModifying = false;
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
      title: isModifying ? ProgressRing() : Text("Appliquer les changements?"),
	  content: SingleChildScrollView(child: Column(
	  	children: modifiedSuperviseurs.isEmpty ? [Text("Aucune modification enregistrée")]
		: modifiedSuperviseurs.values.map((sup) {
			return Text("-> Le superviseur ${sup.nom} sera modifié");
		}).toList(),
	  )),
      actions: [
        Button(
			onPressed: () {
				setState(() {
				  isModifying = true;
				});
				modifiedSuperviseurs.forEach((index, sup) async {
					bool status = await widget.onModify(sup);
					if (status && mounted) {
						popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' modifié(s)");
						modifiedSuperviseurs.removeWhere((index, value) => index == sup.id);
					}
					else if (mounted && !status) {
						popItUp(context, "Superviseur(s) '${sup.nom_utilisateur}' non modifié(s)");
					}
				});
				setState(() {
				  isModifying = false;
				});
			},
			child: Text("Appliquer")
        ),
        Button(
			onPressed: () => Navigator.pop(context),
			child: Text("Fermer")
        ),
      ],
    );
  }
}
