import 'package:new_collecteur_ui/api/autres_champs_api.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/lot.dart';

class DeleteLotDialog extends StatefulWidget {
  final Lot lot;

  const DeleteLotDialog({
	required this.lot,
    super.key,
  });

  @override
  State<DeleteLotDialog> createState() => _DeleteLotDialogState();
}

class _DeleteLotDialogState extends State<DeleteLotDialog> {
  bool isRemoving = false;

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
      title: const Text("Supprimer ce lot?"),
      actions: [
        Button(
          onPressed: () async {
		  	setState(() {
				isRemoving = true;
			});
			bool status = await removeLot(widget.lot);
		  	setState(() {
				isRemoving = false;
			});
			if (status && mounted) {
				popItUp(context, "Lot supprimé");
			}
			else {
				popItUp(context, "Lot non supprimé");
			}
          },
          child: isRemoving ? ProgressRing() : Text("Supprimer"),
        ),
        Button(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer"),
        ),
      ],
    );
  }
}
