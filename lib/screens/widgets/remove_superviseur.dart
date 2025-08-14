import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DeleteSuperviseurDialog extends StatefulWidget {
  final Superviseur superviseur;
  final Future<bool> Function(Superviseur) onDelete;

  const DeleteSuperviseurDialog({
    super.key,
    required this.superviseur,
    required this.onDelete,
  });

  @override
  State<DeleteSuperviseurDialog> createState() => _DeleteSuperviseurDialogState();
}

class _DeleteSuperviseurDialogState extends State<DeleteSuperviseurDialog> {
  bool isDeleting = false;
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
      title: Text("Supprimer le superviseur ${widget.superviseur.nom_utilisateur}?"),
      actions: [
        Button(
			onPressed: () async {
				setState(() {
				  isDeleting = true;
				});

				bool status = await widget.onDelete(widget.superviseur);

				setState(() {
				  isDeleting = false;
				});

				if (mounted && status) {
					popItUp(context, "Superviseur supprimé");
				}
				else {
					popItUp(context, "Superviseur non supprimé");
				}
			},
			child: Text("Supprimer")
        ),
        Button(
			onPressed: () => Navigator.pop(context),
			child: Text("Fermer")
        ),
      ],
    );
  }
}
