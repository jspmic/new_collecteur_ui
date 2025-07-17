import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/options.dart';

class AutresChamps extends StatefulWidget {
  final Option opt;
  const AutresChamps({super.key,
  					required this.opt});

  @override
  State<AutresChamps> createState() => _AutresChampsState();
}

class _AutresChampsState extends State<AutresChamps> {
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text(widget.opt.title))),
		);
	  }
}
