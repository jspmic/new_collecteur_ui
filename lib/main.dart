import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await windowManager.ensureInitialized();
	windowManager.waitUntilReadyToShow().then((_) async {
		await windowManager.setTitle("Collecteur Soft");
		await windowManager.setTitleBarStyle(TitleBarStyle.normal);
		await windowManager.setBackgroundColor(Colors.transparent);
		await windowManager.setMinimumSize(const Size(755, 545));
		await windowManager.center();
		await windowManager.show();
		await windowManager.setSkipTaskbar(false);
	});

	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Collecteur Soft',
	  theme: FluentThemeData(
		  brightness: Brightness.light,
		  accentColor: SystemTheme.accentColor.accent.toAccentColor()
	  ),
	  darkTheme: FluentThemeData(
		  brightness: Brightness.dark,
		  accentColor: SystemTheme.accentColor.accent.toAccentColor()
	  ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener{
  int index = 0;

  @override
  void initState() {
	windowManager.addListener(this);
  	super.initState();
  }

  @override
  void dispose() {
	windowManager.removeListener(this);
  	super.dispose();
  }

  @override
  void onWindowClose() async {
	bool isPreventClose = await windowManager.isPreventClose();
	if (isPreventClose) {
		showDialog(context: context, builder: (_) {
			return ContentDialog(
				title: const Text("Confirmation"),
				content: const Text("Voulez-vous fermer l'application?"),
				actions: [
					FilledButton(child: const Text("Oui"),
					onPressed: () {
						Navigator.pop(context);
						windowManager.destroy();
					}),
					FilledButton(child: const Text("Non"),
					onPressed: () {
						Navigator.pop(context);
					})
				],
			);
		}
		);
	}
  	super.onWindowClose();
  }

  Widget _Item1() {
  	return Text("Add");
  }
  Widget _Item2() {
  	return Text("Subtract");
  }

  @override
  Widget build(BuildContext context) {
	  return NavigationView(
	  	pane: NavigationPane(
			selected: index,
			onChanged: (i) => setState(() {
						  index = i;
						}),
			displayMode: PaneDisplayMode.compact,
			items: [
				PaneItem(
					icon: Icon(FluentIcons.document), 
					title: Text("Mouvements"),
					body: _Item1()
				),
				PaneItem(
					icon: Icon(FluentIcons.mountain_climbing), 
					title: Text("Districts et Collines"),
					body: _Item2()
				),
				PaneItem(
					icon: Icon(FluentIcons.add_field), 
					title: Text("Autres champs"),
					body: _Item2()
				),
				PaneItem(
					icon: Icon(FluentIcons.add_friend), 
					title: Text("Superviseurs"),
					body: _Item2()
				),
			]
		),
	  );
  }
}
