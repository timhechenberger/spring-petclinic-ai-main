import 'package:flutter/material.dart';
import '../core/widgets/figma_widgets.dart';

class VetsPage extends StatefulWidget {
  const VetsPage({super.key});

  @override
  State<VetsPage> createState() => _VetsPageState();
}

class _VetsPageState extends State<VetsPage> {
  int? selectedIndex;
  String search = '';

  final List<Map<String, String>> vets = [
    {'firstname': 'Max', 'lastname': 'Mustermann', 'age': '42', 'specialty': 'Chirurgie'},
    {'firstname': 'Anna', 'lastname': 'Beispiel', 'age': '36', 'specialty': 'Dermatologie'},
    {'firstname': 'Paul', 'lastname': 'Test', 'age': '51', 'specialty': 'Innere Medizin'},
    {'firstname': 'Julia', 'lastname': 'Weiß', 'age': '38', 'specialty': 'Zahnheilkunde'},
    {'firstname': 'Lukas', 'lastname': 'Grün', 'age': '44', 'specialty': 'Radiologie'},
    {'firstname': 'Eva', 'lastname': 'Schwarz', 'age': '39', 'specialty': 'Chirurgie'},
  ];

  List<Map<String, String>> get filtered => search.isEmpty
      ? vets
      : vets.where((v) => v.values.any((val) => val.toLowerCase().contains(search.toLowerCase()))).toList();

  Future<void> _showDialog({Map<String, String>? initial}) async {
    final firstCtrl  = TextEditingController(text: initial?['firstname']);
    final lastCtrl   = TextEditingController(text: initial?['lastname']);
    final ageCtrl    = TextEditingController(text: initial?['age']);
    final specCtrl   = TextEditingController(text: initial?['specialty']);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FigmaDialog(
        title: initial == null ? 'Tierarzt anlegen' : 'Tierarzt bearbeiten',
        confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
        fields: [
          FigmaField(label: 'Vorname', ctrl: firstCtrl),
          FigmaField(label: 'Nachname', ctrl: lastCtrl),
          FigmaField(label: 'Alter', ctrl: ageCtrl),
          FigmaField(label: 'Spezialisierung', ctrl: specCtrl),
        ],
        onConfirm: () => Navigator.pop(context, {
          'firstname': firstCtrl.text,
          'lastname':  lastCtrl.text,
          'age':       ageCtrl.text,
          'specialty': specCtrl.text,
        }),
      ),
    );

    if (result != null) {
      setState(() {
        if (initial != null && selectedIndex != null) {
          vets[selectedIndex!] = result;
        } else {
          vets.add(result);
        }
        selectedIndex = null;
      });
    }
  }

  void _delete() {
    if (selectedIndex == null) return;
    setState(() {
      vets.removeAt(selectedIndex!);
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;

    return FigmaPage(
      title: 'Tierärzte',
      toolbarItems: [
        FigmaSearchField(
          hint: 'Suchen',
          onChanged: (v) => setState(() => search = v),
        ),
        const SizedBox(width: 10),
        FigmaButton(
          label: 'Tierarzt anlegen',
          icon: Icons.add,
          onPressed: () => _showDialog(),
        ),
      ],
      content: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final vet = items[i];
                final globalIdx = vets.indexOf(vet);
                final selected = selectedIndex == globalIdx;

                return GestureDetector(
                  onTap: () => setState(() =>
                  selectedIndex = selected ? null : globalIdx),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFD6EAD8)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF3F7F46)
                            : Colors.grey.shade400,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row – Firstname / Lastname / Age
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                          ),
                          child: Row(
                            children: [
                              _HeaderCell(vet['firstname']!),
                              const SizedBox(width: 8),
                              _HeaderCell(vet['lastname']!),
                              const SizedBox(width: 8),
                              _HeaderCell('${vet['age']} J.'),
                            ],
                          ),
                        ),

                        // Specialty body
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Spezialisierungen',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black45),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    vet['specialty']!,
                                    style: const TextStyle(fontSize: 12),
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
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              FigmaButton(
                label: 'Bearbeiten',
                enabled: selectedIndex != null,
                onPressed: () => _showDialog(initial: vets[selectedIndex!]),
              ),
              const SizedBox(width: 10),
              FigmaButton(
                label: 'Löschen',
                enabled: selectedIndex != null,
                onPressed: _delete,
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}