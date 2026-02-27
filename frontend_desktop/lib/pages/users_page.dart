import 'package:flutter/material.dart';
import '../core/widgets/figma_widgets.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int? selectedIndex;
  String search = '';

  final List<Map<String, String>> users = [
    {'name': 'Guts', 'email': '4332334523', 'address': 'Bruck, Hausweg 14'},
    {'name': 'Tim', 'email': '4332334523', 'address': 'Bruck, Hausweg 14'},
    {'name': 'Der Dünne', 'email': '4332334523', 'address': 'Bruck, Hausweg 14'},
    {'name': 'ChickSep', 'email': '4332334523', 'address': 'Bruck, Hausweg 14'},
    {'name': 'Goofy A', 'email': 'FetterHund@gmail.com', 'address': 'Bruck, Hausweg 14'},
  ];

  List<Map<String, String>> get filtered => search.isEmpty
      ? users
      : users.where((u) => u.values.any((v) => v.toLowerCase().contains(search.toLowerCase()))).toList();

  Future<void> _showDialog({Map<String, String>? initial}) async {
    final nameCtrl = TextEditingController(text: initial?['name']);
    final emailCtrl = TextEditingController(text: initial?['email']);
    final addressCtrl = TextEditingController(text: initial?['address']);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FigmaDialog(
        title: initial == null ? 'Benutzer anlegen' : 'Benutzer bearbeiten',
        confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
        fields: [
          FigmaField(label: 'Name', ctrl: nameCtrl),
          FigmaField(label: 'Email / Telefon', ctrl: emailCtrl),
          FigmaField(label: 'Adresse', ctrl: addressCtrl),
        ],
        onConfirm: () => Navigator.pop(context, {
          'name': nameCtrl.text, 'email': emailCtrl.text, 'address': addressCtrl.text,
        }),
      ),
    );

    if (result != null) {
      setState(() {
        if (initial != null && selectedIndex != null) {
          users[selectedIndex!] = result;
        } else {
          users.add(result);
        }
        selectedIndex = null;
      });
    }
  }

  void _delete() {
    if (selectedIndex == null) return;
    setState(() { users.removeAt(selectedIndex!); selectedIndex = null; });
  }

  @override
  Widget build(BuildContext context) {
    final rows = List.generate(filtered.length, (i) {
      final u = filtered[i];
      final gi = users.indexOf(u);
      return DataRow(
        selected: selectedIndex == gi,
        onSelectChanged: (_) => setState(() => selectedIndex = selectedIndex == gi ? null : gi),
        cells: [
          DataCell(Text(u['name']!)),
          DataCell(Text(u['email']!)),
          DataCell(Text(u['address']!)),
        ],
      );
    });

    return FigmaPage(
      title: 'Benutzer',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => search = v)),
        const SizedBox(width: 10),
        FigmaButton(label: 'Benutzer anlegen', icon: Icons.add, onPressed: () => _showDialog()),
      ],
      content: FigmaTableCard(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email/Tel.')),
          DataColumn(label: Text('Adresse')),
        ],
        rows: rows,
        footerActions: [
          FigmaButton(
            label: 'Bearbeiten',
            enabled: selectedIndex != null,
            onPressed: () => _showDialog(initial: users[selectedIndex!]),
          ),
          const SizedBox(width: 10),
          FigmaButton(label: 'Löschen', enabled: selectedIndex != null, onPressed: _delete),
        ],
      ),
    );
  }
}