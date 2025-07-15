import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/options.dart';

class Mouvements extends StatefulWidget {
  final Option opt;
  const Mouvements({super.key,
  					required this.opt});

  @override
  State<Mouvements> createState() => _MouvementsState();
}

class _MouvementsState extends State<Mouvements> {
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text(widget.opt.title))),
		);
	  }
}
