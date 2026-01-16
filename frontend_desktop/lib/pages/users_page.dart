import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Benutzer',
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
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Benutzer anlegen'),
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
                    DataColumn(label: Text('E-Mail')),
                    DataColumn(label: Text('Rolle')),
                    DataColumn(label: Text('Aktionen')),
                  ],
                  rows: List.generate(5, (i) {
                    return DataRow(cells: [
                      DataCell(Text('#$i')),
                      const DataCell(Text('Max Mustermann')),
                      const DataCell(Text('max@test.de')),
                      const DataCell(Text('ADMIN')),
                      DataCell(Row(
                        children: const [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Icon(Icons.delete),
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
