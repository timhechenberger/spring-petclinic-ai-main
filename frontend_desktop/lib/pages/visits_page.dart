import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  DateTime selectedDate = DateTime(2024, 4, 15);
  int? selectedVisitIndex;

  final Map<DateTime, List<Map<String, String>>> visits = {
    DateTime(2024, 4, 15): [
      {'title': 'Termin 1', 'desc': 'Hund verarzten'},
      {'title': 'Termin 2', 'desc': 'Katze impfen'},
    ],
    DateTime(2024, 4, 18): [
      {'title': 'Operation', 'desc': 'Den Dünnen meucheln'},
    ],
    DateTime(2024, 4, 22): [
      {'title': 'Kontrolle', 'desc': 'Hase checken'},
    ],
  };

  List<Map<String, String>> get dayVisits =>
      visits[_dayKey(selectedDate)] ?? [];

  DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _createVisit() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const _VisitFormDialog(),
    );

    if (result != null) {
      setState(() {
        visits.putIfAbsent(_dayKey(selectedDate), () => []);
        visits[_dayKey(selectedDate)]!.add(result);
      });
    }
  }

  Future<void> _editVisit() async {
    if (selectedVisitIndex == null) return;

    final result = await showDialog(
      context: context,
      builder: (_) => _VisitFormDialog(
        initialData: dayVisits[selectedVisitIndex!],
      ),
    );

    if (result != null) {
      setState(() {
        dayVisits[selectedVisitIndex!] = result;
        selectedVisitIndex = null;
      });
    }
  }

  void _deleteVisit() {
    if (selectedVisitIndex == null) return;

    setState(() {
      dayVisits.removeAt(selectedVisitIndex!);
      selectedVisitIndex = null;
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
              'Termine',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            /// Header
            Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 40,
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                          selectedVisitIndex = null;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon:
                        const Icon(Icons.calendar_today, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        isDense: true,
                      ),
                      child: Text(
                        '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _createVisit,
                    icon: const Icon(Icons.add),
                    label: const Text('Termin anlegen'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Content
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _Calendar(
                      selectedDate: selectedDate,
                      onSelect: (d) {
                        setState(() {
                          selectedDate = d;
                          selectedVisitIndex = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.grey.shade500),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Termine am ausgewählten Tag',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              itemCount: dayVisits.length,
                              itemBuilder: (_, i) {
                                final v = dayVisits[i];
                                final selected = selectedVisitIndex == i;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedVisitIndex =
                                      selected ? null : i;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.grey.shade300
                                          : null,
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(v['title']!,
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text(v['desc']!),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: selectedVisitIndex == null
                                      ? null
                                      : _editVisit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                  ),
                                  child: const Text('Bearbeiten'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: selectedVisitIndex == null
                                      ? null
                                      : _deleteVisit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                  ),
                                  child: const Text('Löschen'),
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
          ],
        ),
      ),
    );
  }
}

/// ---------------- VISIT FORM DIALOG ----------------

class _VisitFormDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const _VisitFormDialog({this.initialData});

  @override
  State<_VisitFormDialog> createState() => _VisitFormDialogState();
}

class _VisitFormDialogState extends State<_VisitFormDialog> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    titleCtrl =
        TextEditingController(text: widget.initialData?['title'] ?? '');
    descCtrl =
        TextEditingController(text: widget.initialData?['desc'] ?? '');
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
                isEdit ? 'Termin bearbeiten' : 'Termin anlegen',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _field('Titel', titleCtrl),
              _field('Beschreibung', descCtrl),
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
                        'title': titleCtrl.text,
                        'desc': descCtrl.text,
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

/// ---------------- CALENDAR ----------------

class _Calendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  const _Calendar({required this.selectedDate, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
    DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey.shade500),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((e) => Text(e))
                .toList(),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              itemCount: daysInMonth,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (_, i) {
                final day = i + 1;
                final date = DateTime(
                    selectedDate.year, selectedDate.month, day);
                final isSelected =
                DateUtils.isSameDay(date, selectedDate);

                return InkWell(
                  onTap: () => onSelect(date),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade300
                          : null,
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    child: Text('$day'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
