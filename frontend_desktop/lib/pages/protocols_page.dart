import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';

class ProtocolsPage extends StatefulWidget {
  const ProtocolsPage({super.key});

  @override
  State<ProtocolsPage> createState() => _ProtocolsPageState();
}

class _ProtocolsPageState extends State<ProtocolsPage> {
  String filter = 'Alle';
  String search = '';

  final List<Map<String, String>> protocols = [
    {
      'date': '10.10.2025 14:32',
      'user': 'Dr. Müller',
      'action': 'Termin erstellt',
      'object': 'Max (Hund)',
      'status': 'Kritisch',
      'type': 'Termin',
    },
    {
      'date': '21.04.2024 09:12',
      'user': 'admin',
      'action': 'Erstellt',
      'object': 'Bello – Impfung',
      'status': 'Gut',
      'type': 'Termin',
    },
    {
      'date': '21.04.2024 09:15',
      'user': 'admin',
      'action': 'Gelöscht',
      'object': 'Tier: Luna',
      'status': 'Abgeschlossen',
      'type': 'Tier',
    },
    {
      'date': '21.04.2024 10:01',
      'user': 'admin',
      'action': 'Bearbeitet',
      'object': 'Benutzer: Max',
      'status': 'In Behandlung',
      'type': 'Benutzer',
    },
  ];

  List<Map<String, String>> get filteredProtocols {
    return protocols.where((p) {
      final matchesFilter =
          filter == 'Alle' || p['type'] == filter;
      final matchesSearch = search.isEmpty ||
          p.values.any(
                (v) => v.toLowerCase().contains(search.toLowerCase()),
          );
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Kritisch':
        return Colors.red;
      case 'In Behandlung':
        return Colors.orange;
      case 'Abgeschlossen':
        return Colors.grey;
      case 'Gut':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenteredContent(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Text(
              'Protokolle',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            /// Suche + Filter
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (v) => setState(() => search = v),
                      decoration: InputDecoration(
                        hintText: 'Suchen',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 160,
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    value: filter,
                    items: const [
                      DropdownMenuItem(
                          value: 'Alle', child: Text('Alle')),
                      DropdownMenuItem(
                          value: 'Termin', child: Text('Termine')),
                      DropdownMenuItem(
                          value: 'Tier', child: Text('Tiere')),
                      DropdownMenuItem(
                          value: 'Benutzer', child: Text('Benutzer')),
                    ],
                    onChanged: (v) =>
                        setState(() => filter = v!),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Grauer Container + volle Tabellenbreite
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity, // ✅ FIX: volle Breite
                      child: DataTable(
                        headingRowColor:
                        MaterialStateProperty.all(
                            Colors.grey.shade200),
                        columnSpacing: 32,
                        columns: const [
                          DataColumn(label: Text('Datum')),
                          DataColumn(label: Text('Benutzer')),
                          DataColumn(label: Text('Aktion')),
                          DataColumn(label: Text('Objekt')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: filteredProtocols.map((p) {
                          final status = p['status']!;
                          return DataRow(cells: [
                            DataCell(Text(p['date']!)),
                            DataCell(Text(p['user']!)),
                            DataCell(Text(p['action']!)),
                            DataCell(Text(p['object']!)),
                            DataCell(
                              Text(
                                status,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor(status),
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
