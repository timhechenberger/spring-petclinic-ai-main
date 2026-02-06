import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';

class VetsPage extends StatefulWidget {
  const VetsPage({super.key});

  @override
  State<VetsPage> createState() => _VetsPageState();
}

class _VetsPageState extends State<VetsPage> {
  int? selectedIndex;

  final List<Map<String, String>> vets = [
    {
      'name': 'Dr. Max Mustermann',
      'specialty': 'Chirurgie',
    },
    {
      'name': 'Dr. Anna Beispiel',
      'specialty': 'Dermatologie',
    },
    {
      'name': 'Dr. Paul Test',
      'specialty': 'Innere Medizin',
    },
    {
      'name': 'Dr. Julia Weiß',
      'specialty': 'Zahnheilkunde',
    },
    {
      'name': 'Dr. Lukas Grün',
      'specialty': 'Radiologie',
    },
    {
      'name': 'Dr. Eva Schwarz',
      'specialty': 'Chirurgie',
    },
  ];

  Future<void> _createVet() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const _VetFormDialog(),
    );

    if (result != null) {
      setState(() => vets.add(result));
    }
  }

  Future<void> _editVet() async {
    if (selectedIndex == null) return;

    final result = await showDialog(
      context: context,
      builder: (_) =>
          _VetFormDialog(initialData: vets[selectedIndex!]),
    );

    if (result != null) {
      setState(() {
        vets[selectedIndex!] = result;
        selectedIndex = null;
      });
    }
  }

  void _deleteVet() {
    if (selectedIndex == null) return;
    setState(() {
      vets.removeAt(selectedIndex!);
      selectedIndex = null;
    });
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
              'Tierärzte',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            /// Suche + Anlegen
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tierarzt suchen...',
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
                    onPressed: _createVet,
                    icon: const Icon(Icons.add),
                    label: const Text('Tierarzt anlegen'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Grid
            Expanded(
              child: GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.4,
                ),
                itemCount: vets.length,
                itemBuilder: (_, i) {
                  final vet = vets[i];
                  final selected = selectedIndex == i;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = selected ? null : i;
                      });
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selected
                              ? Colors.black
                              : Colors.grey.shade400,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.medical_services, size: 28),
                            const SizedBox(height: 12),
                            Text(
                              vet['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vet['specialty']!,
                              style: TextStyle(
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Footer Buttons – links wie Figma
            Row(
              children: [
                ElevatedButton(
                  onPressed:
                  selectedIndex == null ? null : _editVet,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Bearbeiten'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                  selectedIndex == null ? null : _deleteVet,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Löschen'),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// ---------------- VET FORM DIALOG ----------------

class _VetFormDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const _VetFormDialog({this.initialData});

  @override
  State<_VetFormDialog> createState() => _VetFormDialogState();
}

class _VetFormDialogState extends State<_VetFormDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController specialtyCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    specialtyCtrl =
        TextEditingController(text: widget.initialData?['specialty'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Tierarzt bearbeiten' : 'Tierarzt anlegen',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _field('Name', nameCtrl),
              _field('Spezialisierung', specialtyCtrl),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'name': nameCtrl.text,
                        'specialty': specialtyCtrl.text,
                      });
                    },
                    child: Text(isEdit ? 'Speichern' : 'Anlegen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
