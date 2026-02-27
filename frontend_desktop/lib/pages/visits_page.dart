import 'package:flutter/material.dart';
import '../core/widgets/figma_widgets.dart';

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
    DateTime(2024, 4, 18): [{'title': 'Operation', 'desc': 'Kastration – Bello'}],
    DateTime(2024, 4, 22): [{'title': 'Kontrolle', 'desc': 'Hase checken'}],
  };

  DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);
  List<Map<String, String>> get dayVisits => visits[_dayKey(selectedDate)] ?? [];

  bool _hasVisits(DateTime d) =>
      visits[_dayKey(d)]?.isNotEmpty ?? false;

  Future<void> _showDialog({Map<String, String>? initial}) async {
    final titleCtrl = TextEditingController(text: initial?['title']);
    final descCtrl  = TextEditingController(text: initial?['desc']);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FigmaDialog(
        title: initial == null ? 'Termin anlegen' : 'Termin bearbeiten',
        confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
        fields: [
          FigmaField(label: 'Titel', ctrl: titleCtrl),
          FigmaField(label: 'Beschreibung', ctrl: descCtrl),
        ],
        onConfirm: () => Navigator.pop(context, {
          'title': titleCtrl.text,
          'desc':  descCtrl.text,
        }),
      ),
    );

    if (result != null) {
      setState(() {
        visits.putIfAbsent(_dayKey(selectedDate), () => []);
        if (initial != null && selectedVisitIndex != null) {
          visits[_dayKey(selectedDate)]![selectedVisitIndex!] = result;
        } else {
          visits[_dayKey(selectedDate)]!.add(result);
        }
        selectedVisitIndex = null;
      });
    }
  }

  void _delete() {
    if (selectedVisitIndex == null) return;
    setState(() {
      dayVisits.removeAt(selectedVisitIndex!);
      selectedVisitIndex = null;
    });
  }

  Future<void> _pickDate() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + toolbar ──────────────────────────────────
          const Text('Termine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),

          Row(
            children: [
              // Date display (read-only, click to pick)
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 15, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FigmaButton(
                label: 'Termin anlegen',
                icon: Icons.add,
                onPressed: () => _showDialog(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Calendar + Visit list ────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar (55 % width)
                Expanded(
                  flex: 55,
                  child: _MonthCalendar(
                    selectedDate: selectedDate,
                    hasVisits: _hasVisits,
                    onSelect: (d) => setState(() {
                      selectedDate = d;
                      selectedVisitIndex = null;
                    }),
                  ),
                ),

                const SizedBox(width: 16),

                // Visit list (45 % width)
                Expanded(
                  flex: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: Text(
                            'Termine am ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),

                        // List
                        Expanded(
                          child: dayVisits.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_note,
                                    size: 32,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 6),
                                Text('Keine Termine',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade400)),
                              ],
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: dayVisits.length,
                            itemBuilder: (_, i) {
                              final v = dayVisits[i];
                              final sel = selectedVisitIndex == i;
                              return GestureDetector(
                                onTap: () => setState(() =>
                                selectedVisitIndex =
                                sel ? null : i),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade50,
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    border: Border.all(
                                      color: sel
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(v['title']!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      const SizedBox(height: 2),
                                      Text(v['desc']!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Footer buttons
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: Row(
                            children: [
                              FigmaButton(
                                label: 'Bearbeiten',
                                enabled: selectedVisitIndex != null,
                                onPressed: () => _showDialog(
                                    initial: dayVisits[selectedVisitIndex!]),
                              ),
                              const SizedBox(width: 10),
                              FigmaButton(
                                label: 'Löschen',
                                enabled: selectedVisitIndex != null,
                                onPressed: _delete,
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
    );
  }
}

// ── Month calendar widget ──────────────────────────────────────────────────────

class _MonthCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final bool Function(DateTime) hasVisits;
  final ValueChanged<DateTime> onSelect;

  const _MonthCalendar({
    required this.selectedDate,
    required this.hasVisits,
    required this.onSelect,
  });

  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  String _monthName(int m) => const [
    'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
    'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
  ][m - 1];

  @override
  Widget build(BuildContext context) {
    final year  = selectedDate.year;
    final month = selectedDate.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    // weekday of first day: Mon=1..Sun=7 → shift to Sun=0
    final firstWeekday = DateTime(year, month, 1).weekday % 7;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          // Month navigation header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () => onSelect(
                      DateTime(year, month - 1, 1)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                Text(
                  '${_monthName(month)} $year',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () => onSelect(
                      DateTime(year, month + 1, 1)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Weekday header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: _weekdays
                  .map((d) => Expanded(
                child: Center(
                  child: Text(d,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45)),
                ),
              ))
                  .toList(),
            ),
          ),

          Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.grey.shade200),

          // Day grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemCount: firstWeekday + daysInMonth,
                itemBuilder: (_, i) {
                  if (i < firstWeekday) return const SizedBox.shrink();

                  final day  = i - firstWeekday + 1;
                  final date = DateTime(year, month, day);
                  final isSel =
                  DateUtils.isSameDay(date, selectedDate);
                  final isToday =
                  DateUtils.isSameDay(date, DateTime.now());
                  final hasDot = hasVisits(date);

                  return GestureDetector(
                    onTap: () => onSelect(date),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSel ? Colors.grey.shade300 : null,
                        border: Border.all(
                          color: isToday
                              ? const Color(0xFF3F7F46)
                              : Colors.grey.shade300,
                          width: isToday ? 1.5 : 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 13,
                              color: isToday
                                  ? const Color(0xFF3F7F46)
                                  : Colors.black87,
                              fontWeight: isSel || isToday
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (hasDot)
                            Positioned(
                              bottom: 4,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
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
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}