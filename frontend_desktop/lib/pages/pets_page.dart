import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  int? selectedIndex;

  final List<Map<String, String>> pets = [
    {
      'name': 'Fabian',
      'owner': 'BrisenSep',
      'breed': 'Dünner',
      'birth': '15.03.2007',
    },
    {
      'name': 'Guts',
      'owner': 'BrisenSep',
      'breed': 'Dünner',
      'birth': '15.03.2007',
    },
    {
      'name': 'Fabian',
      'owner': 'BrisenSep',
      'breed': 'Dünner',
      'birth': '15.03.2007',
    },
    {
      'name': 'Fabian',
      'owner': 'BrisenSep',
      'breed': 'Dünner',
      'birth': '15.03.2007',
    },
  ];

  void _createPet() {
    debugPrint('Tier anlegen');
  }

  void _editPet() {
    if (selectedIndex == null) return;
    debugPrint('Tier bearbeiten: ${pets[selectedIndex!]['name']}');
  }

  void _deletePet() {
    if (selectedIndex == null) return;
    setState(() {
      pets.removeAt(selectedIndex!);
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CenteredContent(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            /// Titel
            const Text(
              'Tiere',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            /// Suche + Tier hinzufügen (figma-getreu)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
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
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _createPet,
                    icon: const Icon(Icons.add),
                    label: const Text('Tier hinzufügen'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Tabelle + Footer
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.grey.shade600),
                ),
                child: Column(
                  children: [
                    /// Tabelle
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Colors.grey.shade300,
                            ),
                            columnSpacing: 28,
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Besitzer')),
                              DataColumn(label: Text('Rasse')),
                              DataColumn(label: Text('Geburtsdatum')),
                            ],
                            rows: List.generate(pets.length, (i) {
                              final pet = pets[i];
                              return DataRow(
                                selected: selectedIndex == i,
                                onSelectChanged: (_) {
                                  setState(() {
                                    selectedIndex =
                                    selectedIndex == i ? null : i;
                                  });
                                },
                                cells: [
                                  DataCell(Text(pet['name']!)),
                                  DataCell(Text(pet['owner']!)),
                                  DataCell(Text(pet['breed']!)),
                                  DataCell(Text(pet['birth']!)),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),

                    /// Footer – LINKS wie im Figma
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade500),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed:
                              selectedIndex == null ? null : _editPet,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Bearbeiten'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed:
                              selectedIndex == null ? null : _deletePet,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Löschen'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
