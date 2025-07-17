import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:new_collecteur_ui/api/superviseur_api.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/models/superviseur.dart';
import 'package:window_manager/window_manager.dart';
import 'custom_widgets.dart';
import 'models/options.dart';
import 'models/options_to_screen.dart';
import 'screens/mouvements.dart';
import 'screens/superviseurs.dart';
import 'screens/districts_collines.dart';
import 'screens/autres_champs.dart';
import 'screens/annonces.dart';

void main() async {
	await dotenv.load(fileName: ".env");
	bool loadingSuperviseurs = await getSuperviseurs();
	if (!loadingSuperviseurs) {
		superviseursList = [Superviseur(id: 0, nom_utilisateur: "")];
	}
	WidgetsFlutterBinding.ensureInitialized();
	await windowManager.ensureInitialized();
	windowManager.waitUntilReadyToShow().then((_) async {
		await windowManager.setTitle("Collecteur Soft");
		await windowManager.setTitleBarStyle(TitleBarStyle.normal);
		await windowManager.setBackgroundColor(Colors.transparent);
		await windowManager.center();
		await windowManager.show();
		await windowManager.setSkipTaskbar(false);
	});

	runApp(const MyApp());
}

List<Option> opts = [
	Option(title: "Mouvements", icon: FluentIcons.document),
	Option(title: "Districts et Collines", icon: FluentIcons.mountain_climbing),
	Option(title: "Autres champs", icon: FluentIcons.add_field),
	Option(title: "Superviseurs", icon: FluentIcons.contact_info),
	Option(title: "Annonces", icon: FluentIcons.info),
];

List<OptionsToScreen> opScreens = [
	OptionsToScreen(opt: opts[0], screen: Mouvements()),
	OptionsToScreen(opt: opts[1], screen: DistrictsCollines()),
	OptionsToScreen(opt: opts[2], screen: AutresChamps(opt: opts[2])),
	OptionsToScreen(opt: opts[3], screen: Superviseurs()),
	OptionsToScreen(opt: opts[4], screen: Annonces()),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Collecteur Soft',
	  theme: FluentThemeData(
		  brightness: Brightness.light,
		  accentColor: Colors.green
	  ),
	  darkTheme: FluentThemeData(
		  brightness: Brightness.dark,
		  accentColor: Colors.green
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
  String? dateDebut;
  String? dateFin;
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


  @override
  Widget build(BuildContext context) {
	  return NavigationView(
	  	pane: NavigationPane(
			selected: index,
			onChanged: (i) => setState(() {
						  index = i;
						}),
			displayMode: PaneDisplayMode.compact,
			items: opScreens.map<NavigationPaneItem>((option){
				return PaneItem(
					icon: Icon(option.opt.icon),
					body: option.screen,
					title: Text(option.opt.title),
					trailing: Icon(FluentIcons.chevron_right)
				);
			}).toList()
		),
	  );
  }
}
