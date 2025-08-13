import 'package:new_collecteur_ui/api/transfert_api.dart';
import 'package:new_collecteur_ui/api/livraison_api.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ApplyMovementsChanges extends StatefulWidget {
  final String program;

  const ApplyMovementsChanges({
    super.key,
    required this.program,
  });

  @override
  State<ApplyMovementsChanges> createState() => _ApplyMovementsChangesState();
}

class _ApplyMovementsChangesState extends State<ApplyMovementsChanges> {
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
  Future<bool> modifyMovement() async{
	  bool status = widget.program == "Transfert" ? await modifyTransfert() : await modifyLivraison();
	  return status;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Appliquer les modifications effectuées?"),
      actions: [
        Button(
			onPressed: () async {
				setState(() {
				  isModifying = true;
				});
				bool statusModify = await modifyMovement();
				setState(() {
				  isModifying = false;
				});
				if (statusModify) {
					popItUp(context, "Les modifications ont été enregistrées");
				}
				else {
					popItUp(context, "Une erreur est survenue");
				}
			},
			child: isModifying ? ProgressRing() : Text("Appliquer")
        ),
        Button(
			onPressed: () => Navigator.pop(context),
			child: Text("Fermer")
        ),
      ],
    );
  }
}
