import 'package:fluent_ui/fluent_ui.dart';
import 'package:new_collecteur_ui/globals.dart';
import 'package:new_collecteur_ui/screens/widgets/add_lot.dart';

class DistrictsCollines extends StatefulWidget {
  const DistrictsCollines({super.key});
  @override
  State<DistrictsCollines> createState() => _DistrictsCollinesState();
}

class _DistrictsCollinesState extends State<DistrictsCollines> {
  String lotSelected = "";
  final Set<int> expandedLots = {};
  final Map<int, Set<int>> expandedDistricts = {};

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
		  title: Text("Districts et Collines"),
		  commandBar: CommandBar(
			  primaryItems: [
				CommandBarButton(
					onPressed: () async{
						await showDialog(context: context,
							builder: (_) => AddLotDialog()
						);
						setState(() {});
					},
					icon: Icon(FluentIcons.add),
					label: const Text("Ajouter un lot")
				)
			  ]
		  ),
	  ),
      content: ListView.builder(
        itemCount: lots.length,
        itemBuilder: (context, lotIndex) {
          final lot = lots[lotIndex];
          final isExpanded = expandedLots.contains(lotIndex);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: TextBox(
				  enabled: false,
                  placeholder: lot.nom,
                  onChanged: (value) {
                    setState(() {
                      lot.nom = value;
                    });
                  },
                ),
                trailing: IconButton(
                  icon: Icon(isExpanded ? FluentIcons.chevron_up : FluentIcons.chevron_down),
                  onPressed: () {
                    setState(() {
                      if (isExpanded) {
                        expandedLots.remove(lotIndex);
                      } else {
                        expandedLots.add(lotIndex);
                      }
                    });
                  },
                ),
              ),
              if (isExpanded)
                ...lot.districts.asMap().entries.map((entry) {
                  final districtIndex = entry.key;
                  final district = entry.value;
                  final isDistrictExpanded = expandedDistricts[lotIndex]?.contains(districtIndex) ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        ListTile(
                          title: TextBox(
							enabled: false,
                            placeholder: district.nom,
                            onChanged: (value) {
                              setState(() {
                                district.nom = value;
                              });
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(isDistrictExpanded ? FluentIcons.chevron_up : FluentIcons.chevron_down),
                            onPressed: () {
                              setState(() {
                                expandedDistricts[lotIndex] ??= {};
                                if (isDistrictExpanded) {
                                  expandedDistricts[lotIndex]!.remove(districtIndex);
                                } else {
                                  expandedDistricts[lotIndex]!.add(districtIndex);
                                }
                              });
                            },
                          ),
                        ),
                        if (isDistrictExpanded)
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: district.collines.map((colline) {
                                return TextBox(
								  enabled: false,
                                  placeholder: colline,
                                  onChanged: (value) {
                                    // Set new colline value
                                  },
                                );
                              }).toList(),
                            ),
                          )
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

