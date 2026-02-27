import 'package:flutter/material.dart';
import '../core/widgets/figma_widgets.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  int? selectedIndex;
  String search = '';

  final List<Map<String, String>> pets = [
    {'name': 'Fabian', 'owner': 'BrisenSep', 'breed': 'Dünner', 'birth': '15.03.2007'},
    {'name': 'Guts', 'owner': 'BrisenSep', 'breed': 'Dünner', 'birth': '15.03.2007'},
    {'name': 'Luna', 'owner': 'Anna S.', 'breed': 'Husky', 'birth': '11.11.2020'},
    {'name': 'Bello', 'owner': 'ChickSep', 'breed': 'Labrador', 'birth': '01.04.2022'},
  ];

  List<Map<String, String>> get filtered => search.isEmpty
      ? pets
      : pets.where((p) => p.values.any((v) => v.toLowerCase().contains(search.toLowerCase()))).toList();

  Future<void> _showDialog({Map<String, String>? initial}) async {
    final nameCtrl = TextEditingController(text: initial?['name']);
    final ownerCtrl = TextEditingController(text: initial?['owner']);
    final breedCtrl = TextEditingController(text: initial?['breed']);
    final birthCtrl = TextEditingController(text: initial?['birth']);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FigmaDialog(
        title: initial == null ? 'Tier anlegen' : 'Tier bearbeiten',
        confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
        fields: [
          FigmaField(label: 'Name', ctrl: nameCtrl),
          FigmaField(label: 'Besitzer', ctrl: ownerCtrl),
          FigmaField(label: 'Rasse', ctrl: breedCtrl),
          FigmaField(label: 'Geburtsdatum', ctrl: birthCtrl),
        ],
        onConfirm: () => Navigator.pop(context, {
          'name': nameCtrl.text, 'owner': ownerCtrl.text,
          'breed': breedCtrl.text, 'birth': birthCtrl.text,
        }),
      ),
    );

    if (result != null) {
      setState(() {
        if (initial != null && selectedIndex != null) {
          pets[selectedIndex!] = result;
        } else {
          pets.add(result);
        }
        selectedIndex = null;
      });
    }
  }

  void _delete() {
    if (selectedIndex == null) return;
    setState(() { pets.removeAt(selectedIndex!); selectedIndex = null; });
  }

  @override
  Widget build(BuildContext context) {
    final rows = List.generate(filtered.length, (i) {
      final p = filtered[i];
      final gi = pets.indexOf(p);
      return DataRow(
        selected: selectedIndex == gi,
        onSelectChanged: (_) => setState(() => selectedIndex = selectedIndex == gi ? null : gi),
        cells: [
          DataCell(Text(p['name']!)),
          DataCell(Text(p['owner']!)),
          DataCell(Text(p['breed']!)),
          DataCell(Text(p['birth']!)),
        ],
      );
    });

    return FigmaPage(
      title: 'Tiere',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => search = v)),
        const SizedBox(width: 10),
        FigmaButton(label: 'Tier hinzufügen', icon: Icons.add, onPressed: () => _showDialog()),
      ],
      content: FigmaTableCard(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Besitzer')),
          DataColumn(label: Text('Rasse')),
          DataColumn(label: Text('Geburtsdatum')),
        ],
        rows: rows,
        footerActions: [
          FigmaButton(
            label: 'Bearbeiten',
            enabled: selectedIndex != null,
            onPressed: () => _showDialog(initial: pets[selectedIndex!]),
          ),
          const SizedBox(width: 10),
          FigmaButton(label: 'Löschen', enabled: selectedIndex != null, onPressed: _delete),
        ],
      ),
    );
  }
}