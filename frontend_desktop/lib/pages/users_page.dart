import 'package:flutter/material.dart';
import '../core/widgets/UserFormDialog.dart';
import '../core/widgets/centered_content.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int? selectedIndex;

  final List<Map<String, String>> users = [
    {
      'name': 'Guts',
      'email': '4332334523',
      'address': 'Bruck, Hausweg 14',
    },
    {
      'name': 'Tim',
      'email': '4332334523',
      'address': 'Bruck, Hausweg 14',
    },
    {
      'name': 'Der Dünne',
      'email': '4332334523',
      'address': 'Bruck, Hausweg 14',
    },
    {
      'name': 'ChickSep',
      'email': '4332334523',
      'address': 'Bruck, Hausweg 14',
    },
    {
      'name': 'Goofy A',
      'email': 'FetterHund@gmail.com',
      'address': 'Bruck, Hausweg 14',
    },
  ];

  Future<void> _createUser() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const UserFormDialog(),
    );

    if (result != null) {
      setState(() {
        users.add(result);
      });
    }
  }

  Future<void> _editUser() async {
    if (selectedIndex == null) return;

    final result = await showDialog(
      context: context,
      builder: (_) => UserFormDialog(
        initialData: users[selectedIndex!],
      ),
    );

    if (result != null) {
      setState(() {
        users[selectedIndex!] = result;
      });
    }
  }

  void _deleteUser() {
    if (selectedIndex == null) return;

    setState(() {
      users.removeAt(selectedIndex!);
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
              'Benutzer',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            /// Suche + Anlegen (nebeneinander)
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
                        fillColor: Colors.grey.shade200,
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
                    onPressed: _createUser,
                    icon: const Icon(Icons.add),
                    label: const Text('Benutzer anlegen'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade200,
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
                  side: BorderSide(color: Colors.grey.shade500),
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
                            columnSpacing: 32,
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email/Tel.')),
                              DataColumn(label: Text('Adresse')),
                            ],
                            rows: List.generate(users.length, (i) {
                              final user = users[i];
                              return DataRow(
                                selected: selectedIndex == i,
                                onSelectChanged: (_) {
                                  setState(() {
                                    selectedIndex =
                                    selectedIndex == i ? null : i;
                                  });
                                },
                                cells: [
                                  DataCell(Text(user['name']!)),
                                  DataCell(Text(user['email']!)),
                                  DataCell(Text(user['address']!)),
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
                          top: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed:
                              selectedIndex == null ? null : _editUser,
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
                              selectedIndex == null ? null : _deleteUser,
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
