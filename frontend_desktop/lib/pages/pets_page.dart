import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tiere',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),

            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 280,
                  height: 44,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tier suchen...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Tier anlegen'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            CenteredCard(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Art')),
                    DataColumn(label: Text('Besitzer')),
                    DataColumn(label: Text('Geburtsdatum')),
                    DataColumn(label: Text('Aktionen')),
                  ],
                  rows: List.generate(6, (i) {
                    return DataRow(cells: [
                      DataCell(Text('#$i')),
                      const DataCell(Text('Bello')),
                      const DataCell(Text('Hund')),
                      const DataCell(Text('Max Mustermann')),
                      const DataCell(Text('12.04.2020')),
                      DataCell(Row(
                        children: const [
                          Icon(Icons.visibility),
                          SizedBox(width: 8),
                          Icon(Icons.edit),
                        ],
                      )),
                    ]);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
