import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/lot.dart';

class DistrictsCollines extends StatefulWidget {
  const DistrictsCollines({super.key});

  @override
  State<DistrictsCollines> createState() => _DistrictsCollinesState();
}

class _DistrictsCollinesState extends State<DistrictsCollines> {
	String lotSelected = "";
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(
				title: const Text("Districts et Collines")
			),
			content: Container(
				child:
					ListView.builder(
						shrinkWrap: true,
						itemCount: lots.length,
						itemBuilder: (context, index) {
							final lot = lots[index];
							return Expander(
								leading: Icon(FluentIcons.document),
								trailing: const Text("Lot"),
								header: SizedBox(
									width: MediaQuery.of(context).size.width/4,
									child: 
										TextBox(
											placeholder: lotSelected == "" ? lot.nom : lotSelected,
											onChanged: (value){
												Lot copyLot = lot;
												copyLot.nom = value;
												lotsChanged[index] = copyLot;
												if (lotsChanged[index]!.nom.isEmpty) {
													lotsChanged.remove(index);
												}
												print("$lotsChanged");
											},
										)
								),
								content: ListView.builder(
									shrinkWrap: true,
									itemCount: lot.districts.length,
									itemBuilder: (context, index2) {
										final district = lot.districts[index2];
										return SingleChildScrollView(child: Expander(
											leading: Icon(FluentIcons.edit_mirrored),
											trailing: const Text("District"),
											header: SizedBox(
												child: TextBox(placeholder: district)
											),
											content: ListView.builder(
												shrinkWrap: true,
												itemCount: districts[district]!.collines.length,
												itemBuilder: (context, index3) {
													final colline = districts[district]!.collines[index3];
													return TextBox(placeholder: colline);
												},
											), // builder-content
										));
									},
								), // builder-content
								onStateChanged: (open) {
									lotSelected = lot.nom;
									print(lotSelected);
								}
							); // Expander
						}
					), // ListView
			) // Center
		);
	  }
}
