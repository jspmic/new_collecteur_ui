import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/options.dart';
import 'package:new_collecteur_ui/globals.dart';

class AutresChamps extends StatefulWidget {
  final Option opt;
  const AutresChamps({super.key,
  					required this.opt});

  @override
  State<AutresChamps> createState() => _AutresChampsState();
}

class _AutresChampsState extends State<AutresChamps> {
	final Set<int> expandedLots = {};
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text(widget.opt.title))),
			content: Column(
				children: [
					Expander(
						header: Text("Produits"),
						content: Text(""),
					),
					SizedBox(
						height: MediaQuery.of(context).size.height/30,
					), // SizedBox
					Expander(
						header: Text("Stocks"),
						content: Text(""),
					),
					SizedBox(
						height: MediaQuery.of(context).size.height/30,
					), // SizedBox
					Expander(
						header: Text("Type de transports"),
						content: Text(""),
					),
				],
			),
		);
	  }
}
