import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/screens/tables/transfert_table.dart';
import 'package:new_collecteur_ui/screens/tables/livraison_table.dart';

class AfficherMouvements extends StatefulWidget {
  final String dateDebut;
  final String dateFin;
  final String program;
  const AfficherMouvements({
	  super.key,
	  required this.dateDebut,
	  required this.dateFin,
	  required this.program,
  });

  @override
  State<AfficherMouvements> createState() => _AfficherMouvementsState();
}

class _AfficherMouvementsState extends State<AfficherMouvements> {
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
				leading: IconButton(
					onPressed: () {
						collectedTransfert.clear();
						collectedLivraison.clear();
						Navigator.pop(context);
					},
					icon: Icon(FluentIcons.back)
				),
			),
			content: widget.program == "Transfert" ? 
					transfertTable(date: widget.dateDebut, dateFin: widget.dateFin)
					: livraisonTable(date: widget.dateDebut, dateFin: widget.dateFin),
		);
	  }
}
