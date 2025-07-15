import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Collecteur Soft',
	  theme: FluentThemeData(
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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
	  return SizedBox();
  }
}
