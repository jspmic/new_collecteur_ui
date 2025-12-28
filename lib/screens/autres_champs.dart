import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/options.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/custom_widgets.dart';

class AutresChamps extends StatefulWidget {
  final Option opt;
  const AutresChamps({super.key,
  					required this.opt});

  @override
  State<AutresChamps> createState() => _AutresChampsState();
}

class _AutresChampsState extends State<AutresChamps> {
	final Set<int> expandedInputs = {};
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text(widget.opt.title))),
			content: SingleChildScrollView(
			child: Column(
				children: [
					Expander(
						header: Text("Produits"),
						content: SizedBox(
							height: MediaQuery.of(context).size.height/3,
						child: ListView.builder(
						itemCount: collectedInputs.length,
						itemBuilder: (context, inputIndex) {
							return Padding(
								padding: const EdgeInsets.only(left: 20),
								child: Column(
									children: [
										ListTile(
											title: Text(collectedInputs[inputIndex].toString()),
										)
									],
								)
							);
						})
						)
					),
					SizedBox(
						height: MediaQuery.of(context).size.height/30,
					), // SizedBox
					Expander(
						header: Text("Stocks"),
							content: SizedBox(
									height: MediaQuery.of(context).size.height/3,
									child: ListView.builder(
											itemCount: collectedStocks.length,
											itemBuilder: (context, inputIndex) {
												return Padding(
														padding: const EdgeInsets.only(left: 20),
														child: Column(
															children: [
																ListTile(
																	title: Text(formatStock(collectedStocks[inputIndex].toString())),
																)
															],
														)
												);
											})
							)
					),
					SizedBox(
						height: MediaQuery.of(context).size.height/30,
					), // SizedBox
					Expander(
						header: Text("Type de transports"),
							content: SizedBox(
									height: MediaQuery.of(context).size.height/3,
									child: ListView.builder(
											itemCount: collectedTypeTransports.length,
											itemBuilder: (context, inputIndex) {
												return Padding(
														padding: const EdgeInsets.only(left: 20),
														child: Column(
															children: [
																ListTile(
																	title: Text(collectedTypeTransports[inputIndex].toString()),
																)
															],
														)
												);
											})
							)
					),
				],
			),
			));
	  }
}
