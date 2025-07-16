import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/models/options.dart';

class Superviseurs extends StatefulWidget {
  final Option opt;
  const Superviseurs({super.key,
  					required this.opt});

  @override
  State<Superviseurs> createState() => _SuperviseursState();
}

class _SuperviseursState extends State<Superviseurs> {
	@override
	  Widget build(BuildContext context) {
	  	return ScaffoldPage(
			header: PageHeader(title: Center(child: Text(widget.opt.title))),
		);
	  }
}
