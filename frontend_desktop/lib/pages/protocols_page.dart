import 'package:flutter/material.dart';
import '../core/widgets/figma_widgets.dart';

class ProtocolsPage extends StatefulWidget {
  const ProtocolsPage({super.key});

  @override
  State<ProtocolsPage> createState() => _ProtocolsPageState();
}

class _ProtocolsPageState extends State<ProtocolsPage> {
  String filter = 'Alle';
  String search = '';

  final List<Map<String, String>> protocols = [
    {'date': '10.10.2025 14:32', 'user': 'Dr. Müller', 'action': 'Termin erstellt', 'object': 'Max (Hund)', 'status': 'Kritisch', 'type': 'Termin'},
    {'date': '21.04.2024 09:12', 'user': 'admin', 'action': 'Erstellt', 'object': 'Bello – Impfung', 'status': 'Gut', 'type': 'Termin'},
    {'date': '21.04.2024 09:15', 'user': 'admin', 'action': 'Gelöscht', 'object': 'Tier: Luna', 'status': 'Abgeschlossen', 'type': 'Tier'},
    {'date': '21.04.2024 10:01', 'user': 'admin', 'action': 'Bearbeitet', 'object': 'Benutzer: Max', 'status': 'In Behandlung', 'type': 'Benutzer'},
  ];

  List<Map<String, String>> get filtered => protocols.where((p) {
    final matchFilter = filter == 'Alle' || p['type'] == filter;
    final matchSearch = search.isEmpty || p.values.any((v) => v.toLowerCase().contains(search.toLowerCase()));
    return matchFilter && matchSearch;
  }).toList();

  Color _statusColor(String s) {
    switch (s) {
      case 'Kritisch': return Colors.red;
      case 'In Behandlung': return Colors.orange;
      case 'Abgeschlossen': return Colors.grey;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FigmaPage(
      title: 'Protokolle',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => search = v)),
        const SizedBox(width: 10),
        SizedBox(
          width: 150,
          height: 38,
          child: DropdownButtonFormField<String>(
            value: filter,
            items: const [
              DropdownMenuItem(value: 'Alle', child: Text('Alle', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(value: 'Termin', child: Text('Termine', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(value: 'Tier', child: Text('Tiere', style: TextStyle(fontSize: 13))),
              DropdownMenuItem(value: 'Benutzer', child: Text('Benutzer', style: TextStyle(fontSize: 13))),
            ],
            onChanged: (v) => setState(() => filter = v!),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            ),
          ),
        ),
      ],
      content: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                columnSpacing: 28,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(label: Text('Datum')),
                  DataColumn(label: Text('Benutzer')),
                  DataColumn(label: Text('Aktion')),
                  DataColumn(label: Text('Objekt')),
                  DataColumn(label: Text('Status')),
                ],
                rows: filtered.map((p) => DataRow(cells: [
                  DataCell(Text(p['date']!, style: const TextStyle(fontSize: 12))),
                  DataCell(Text(p['user']!)),
                  DataCell(Text(p['action']!)),
                  DataCell(Text(p['object']!)),
                  DataCell(Text(
                    p['status']!,
                    style: TextStyle(fontWeight: FontWeight.w600, color: _statusColor(p['status']!), fontSize: 13),
                  )),
                ])).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}