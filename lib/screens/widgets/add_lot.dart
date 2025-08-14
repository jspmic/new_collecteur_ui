import 'package:new_collecteur_ui/globals.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddLotDialog extends StatefulWidget {

  const AddLotDialog({
    super.key,
  });

  @override
  State<AddLotDialog> createState() => _AddLotDialogState();
}

class _AddLotDialogState extends State<AddLotDialog> {
  bool isAdding = false;
  final TextEditingController nom = TextEditingController();
  int countWidgets = 0;
  Map<int, String> districtName = {};
  List<Row> districtWidgets = [];

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

  void addDistrict(int idWidget) {
  	districtWidgets.add(
		Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: [
				const Text("District:"),
				DropDownButton(
					title: Text(districtName[idWidget].toString()),
					items: districts.isEmpty ? [
						MenuFlyoutItem(text: Text(""), onPressed: (){})
					] : districts.map<MenuFlyoutItem>((_district) {
						return MenuFlyoutItem(text: Text(_district.nom), onPressed: () {
							setState(() {
								districtName[idWidget] = _district.nom;
								print(districtName);
							});
						});
					}).toList(),
				) // DropDownButton
			],
		), // Row
	);
	setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text("Ajouter un lot"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextBox(
            controller: nom,
            placeholder: "Nom du lot(Lot <numero_du_lot>)...",
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
		  SingleChildScrollView(
		  	child: Column(
				children: districtWidgets.map(
					(widg) => widg
				).toList(),
			)
		  ),
          const Divider(),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
		  Button(
			  onPressed: () {
				  countWidgets += 1;
				  districtName[countWidgets] = "District $countWidgets";
				  addDistrict(countWidgets);
			  },
			  child: const Icon(FluentIcons.add_field)
		  )
        ],
      ),
      actions: [
        Button(
          onPressed: () {
          },
          child: isAdding ? ProgressRing() : Text("Ajouter"),
        ),
        Button(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer"),
        ),
      ],
    );
  }
}
