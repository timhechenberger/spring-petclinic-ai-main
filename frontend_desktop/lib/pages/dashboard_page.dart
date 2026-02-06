import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/widgets/centered_content.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<String, String> kpis = {
    'Tiere insgesamt': '256',
    'Besitzer': '112',
    'Termine heute': '10',
    'Tierärzte aktiv': '12',
  };

  final Map<DateTime, List<String>> activitiesPerDay = {
    DateTime(2026, 10, 6): [
      'Neuer Termin erstellt',
      'Tier hinzugefügt',
    ],
    DateTime(2026, 10, 7): [
      'Termin bearbeitet',
      'Benutzer gelöscht',
    ],
  };

  List<String> get currentActivities {
    final key = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    return activitiesPerDay[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return CenteredContent(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980), // 🔥 WIE ANDERE PAGES
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Titel
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),

              /// KPIs – gleiche Breite wie Content darunter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: kpis.entries.map((e) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _KpiTile(
                        value: e.value,
                        label: e.key,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              /// Kalender + Aktivitäten (gleiche linke Kante!)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _CalendarCard(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      onDaySelected: (selected, focused) {
                        setState(() {
                          _selectedDay = selected;
                          _focusedDay = focused;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: _ActivityCard(
                      activities: currentActivities,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- KPI TILE ----------------

class _KpiTile extends StatelessWidget {
  final String value;
  final String label;

  const _KpiTile({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// ---------------- KALENDER ----------------

class _CalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const _CalendarCard({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              selectedDayPredicate: (day) =>
                  isSameDay(selectedDay, day),
              onDaySelected: onDaySelected,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.shade200,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- AKTIVITÄTEN ----------------

class _ActivityCard extends StatelessWidget {
  final List<String> activities;

  const _ActivityCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Letzte Aktivitäten',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (activities.isEmpty)
              const Text(
                'Keine Aktivitäten an diesem Tag',
                style: TextStyle(color: Colors.black54),
              )
            else
              ...activities.map(
                    (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $a'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
