import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';

class ProtocolsPage extends StatelessWidget {
  const ProtocolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Protokolle',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),

            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 280,
                  height: 44,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Suchen...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 44,
                  child: DropdownButtonFormField<String>(
                    value: 'Alle',
                    items: const [
                      DropdownMenuItem(value: 'Alle', child: Text('Alle')),
                      DropdownMenuItem(value: 'Termin', child: Text('Termine')),
                      DropdownMenuItem(value: 'Tier', child: Text('Tiere')),
                      DropdownMenuItem(value: 'Benutzer', child: Text('Benutzer')),
                    ],
                    onChanged: (_) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            CenteredCard(
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Datum')),
                    DataColumn(label: Text('Benutzer')),
                    DataColumn(label: Text('Aktion')),
                    DataColumn(label: Text('Objekt')),
                    DataColumn(label: Text('Details')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('21.04.2024 09:12')),
                      DataCell(Text('admin')),
                      DataCell(Text('Erstellt')),
                      DataCell(Text('Termin')),
                      DataCell(Text('Bello – Impfung')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
