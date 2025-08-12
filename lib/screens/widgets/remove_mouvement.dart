import 'package:new_collecteur_ui/api/livraison_api.dart';
import 'package:new_collecteur_ui/api/transfert_api.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DeleteMouvementDialog extends StatefulWidget {
  final String program;

  const DeleteMouvementDialog({
    super.key,
    required this.program,
  });

  @override
  State<DeleteMouvementDialog> createState() => _DeleteMouvementDialogState();
}

class _DeleteMouvementDialogState extends State<DeleteMouvementDialog> {
  bool isDeleting = false;
  int a = 0;
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
						}
						else if (mounted && !status) {
							popItUp(context, "Mouvement non supprimé");
						}
					},
					child: isDeleting ? ProgressRing() : Text("Supprimer"),
				),
				Button(
					onPressed: () => Navigator.pop(context),
					child: const Text("Retour"),
				),
			],
		); // ContentDialog
	}
}
