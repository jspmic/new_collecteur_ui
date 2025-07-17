import 'package:fluent_ui/fluent_ui.dart';

class Annonces extends StatefulWidget {
  const Annonces({super.key});

  @override
  State<Annonces> createState() => _AnnoncesState();
}

class _AnnoncesState extends State<Annonces> {
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text("Annonces"))),
		);
	  }
}
