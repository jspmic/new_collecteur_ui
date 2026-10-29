import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class Modifications extends StatefulWidget {
  const Modifications({super.key});

  @override
  State<Modifications> createState() => _ModificationsState();
}

class _ModificationsState extends State<Modifications> with WindowListener {

  void popItUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: const Text("Modifications"),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}