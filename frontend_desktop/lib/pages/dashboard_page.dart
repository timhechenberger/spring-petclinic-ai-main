import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final List<_KpiData> kpis = const [
    _KpiData('256', 'Tiere insgesamt', Icons.pets),
    _KpiData('112', 'Besitzer', Icons.people),
    _KpiData('10', 'Termine heute', Icons.event),
    _KpiData('12', 'Tierärzte aktiv', Icons.medical_services),
  ];

  final Map<DateTime, List<_AppointmentData>> appointments = {
    DateTime(2026, 2, 27): [
      _AppointmentData('09:00', 'Impfung – Bello', 'Dr. Müller', Colors.green),
      _AppointmentData('11:30', 'Kontrolle – Luna', 'Dr. Weiß', Colors.blue),
      _AppointmentData('14:00', 'Kastration – Guts', 'Dr. Mustermann', Colors.orange),
    ],
    DateTime(2026, 2, 26): [
      _AppointmentData('10:00', 'Zahnreinigung – Max', 'Dr. Schwarz', Colors.purple),
    ],
    DateTime(2026, 3, 3): [
      _AppointmentData('08:30', 'Blutabnahme – Hasi', 'Dr. Grün', Colors.teal),
      _AppointmentData('15:00', 'Nachsorge – Bello', 'Dr. Müller', Colors.green),
    ],
  };

  final Map<DateTime, List<String>> activities = {
    DateTime(2026, 2, 27): [
      'Neuer Termin erstellt',
      'Tier hinzugefügt',
      'Benutzer bearbeitet',
    ],
    DateTime(2026, 2, 26): [
      'Termin bearbeitet',
      'Benutzer gelöscht',
    ],
  };

  DateTime get _dayKey => DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
  List<_AppointmentData> get _dayAppointments => appointments[_dayKey] ?? [];
  List<String> get _dayActivities => activities[_dayKey] ?? [];

  bool _hasEvents(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return appointments[key]?.isNotEmpty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}',
                style: const TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // KPI row
          Row(
            children: [
              for (int i = 0; i < kpis.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < kpis.length - 1 ? 14.0 : 0.0),
                    child: _KpiTile(data: kpis[i]),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          // Main 3-column layout
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar
                Expanded(
                  flex: 5,
                  child: _SectionCard(
                    title: 'Kalender',
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        headerPadding: EdgeInsets.only(bottom: 8),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                        weekendStyle: TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.w500),
                      ),
                      calendarStyle: CalendarStyle(
                        cellMargin: const EdgeInsets.all(6),
                        todayDecoration: BoxDecoration(color: Colors.green.shade200, shape: BoxShape.circle),
                        todayTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                        selectedDecoration: BoxDecoration(color: Colors.green.shade700, shape: BoxShape.circle),
                        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      eventLoader: (day) => _hasEvents(day) ? ['event'] : [],
                      onDaySelected: (sel, foc) => setState(() {
                        _selectedDay = sel;
                        _focusedDay = foc;
                      }),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (events.isEmpty) return const SizedBox.shrink();
                          return Positioned(
                            bottom: 4,
                            child: Container(
                              width: 5, height: 5,
                              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Termine for selected day
                Expanded(
                  flex: 4,
                  child: _SectionCard(
                    title: 'Termine – ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}',
                    child: _dayAppointments.isEmpty
                        ? const _EmptyState(icon: Icons.event_note, text: 'Keine Termine an diesem Tag')
                        : ListView.separated(
                      itemCount: _dayAppointments.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
                      itemBuilder: (_, i) {
                        final a = _dayAppointments[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 4, height: 40,
                                decoration: BoxDecoration(
                                  color: a.color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.time, style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w600)),
                                  Text(a.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                  Text(a.vet, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Activities
                Expanded(
                  flex: 3,
                  child: _SectionCard(
                    title: 'Letzte Aktivitäten',
                    child: _dayActivities.isEmpty
                        ? const _EmptyState(icon: Icons.history, text: 'Keine Aktivitäten')
                        : ListView.builder(
                      itemCount: _dayActivities.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Colors.black45)),
                            Expanded(
                              child: Text(_dayActivities[i], style: const TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
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

class _KpiData {
  final String value, label;
  final IconData icon;
  const _KpiData(this.value, this.label, this.icon);
}

class _AppointmentData {
  final String time, title, vet;
  final Color color;
  const _AppointmentData(this.time, this.title, this.vet, this.color);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final _KpiData data;
  const _KpiTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1)),
              Text(data.label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 34, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.black38)),
        ],
      ),
    );
  }
}