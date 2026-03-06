import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/api/petclinic_api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // API data
  int _petCount = 0;
  int _ownerCount = 0;
  int _vetCount = 0;
  List<Visit> _visits = [];
  List<Pet> _pets = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        PetClinicApi.getPets(),
        PetClinicApi.getOwners(),
        PetClinicApi.getVets(),
        PetClinicApi.getVisits(),
      ]);
      setState(() {
        _pets       = results[0] as List<Pet>;
        final owners = results[1] as List<Owner>;
        final vets   = results[2] as List<Vet>;
        _visits      = results[3] as List<Visit>;
        _petCount    = _pets.length;
        _ownerCount  = owners.length;
        _vetCount    = vets.length;
        _loading     = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<Visit> get _todayVisits {
    final key = _fmtDate(DateTime.now());
    return _visits.where((v) => v.date.startsWith(key)).toList();
  }

  List<Visit> get _selectedDayVisits {
    final key = _fmtDate(_selectedDay);
    return _visits.where((v) => v.date.startsWith(key)).toList();
  }

  bool _hasVisits(DateTime d) =>
      _visits.any((v) => v.date.startsWith(_fmtDate(d)));

  String _petName(int? id) {
    if (id == null) return '–';
    final p = _pets.firstWhere((p) => p.id == id,
        orElse: () => Pet(name: '?', birthDate: ''));
    return p.name;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final kpis = [
      _KpiData('$_petCount',   'Tiere insgesamt',  Icons.pets),
      _KpiData('$_ownerCount', 'Besitzer',          Icons.people),
      _KpiData('${_todayVisits.length}', 'Termine heute', Icons.event),
      _KpiData('$_vetCount',   'Tierärzte aktiv',   Icons.medical_services),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}',
                style: const TextStyle(fontSize: 13, color: Colors.black45)),
          ]),

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

          Expanded(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      titleCentered: true, formatButtonVisible: false,
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
                    eventLoader: (day) => _hasVisits(day) ? ['e'] : [],
                    onDaySelected: (sel, foc) => setState(() {
                      _selectedDay = sel; _focusedDay = foc;
                    }),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (_, day, events) {
                        if (events.isEmpty) return const SizedBox.shrink();
                        return Positioned(bottom: 4, child: Container(
                          width: 5, height: 5,
                          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                        ));
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Visits for selected day
              Expanded(
                flex: 4,
                child: _SectionCard(
                  title: 'Termine – ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}',
                  child: _selectedDayVisits.isEmpty
                      ? _EmptyState(icon: Icons.event_note, text: 'Keine Termine an diesem Tag')
                      : ListView.separated(
                    itemCount: _selectedDayVisits.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
                    itemBuilder: (_, i) {
                      final v = _selectedDayVisits[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          Container(width: 4, height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 10),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(_petName(v.petId),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            Text(v.description,
                                style: const TextStyle(fontSize: 11, color: Colors.black45)),
                          ]),
                        ]),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Recent visits (last 5)
              Expanded(
                flex: 3,
                child: _SectionCard(
                  title: 'Letzte Aktivitäten',
                  child: _visits.isEmpty
                      ? _EmptyState(icon: Icons.history, text: 'Keine Aktivitäten')
                      : ListView.builder(
                    itemCount: _visits.take(5).length,
                    itemBuilder: (_, i) {
                      final v = _visits[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('• ', style: TextStyle(color: Colors.black45)),
                          Expanded(child: Text(
                            '${_petName(v.petId)}: ${v.description}',
                            style: const TextStyle(fontSize: 13),
                          )),
                        ]),
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _KpiData { final String value, label; final IconData icon;
const _KpiData(this.value, this.label, this.icon); }

class _SectionCard extends StatelessWidget {
  final String title; final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      Container(height: 1, color: Colors.grey.shade300),
      Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 10), child: child)),
    ]),
  );
}

class _KpiTile extends StatelessWidget {
  final _KpiData data; const _KpiTile({required this.data});
  @override
  Widget build(BuildContext context) => Container(
    height: 72,
    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400)),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(data.icon, size: 20, color: Colors.grey.shade600),
      const SizedBox(width: 12),
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(data.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1)),
        Text(data.label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ]),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon; final String text;
  const _EmptyState({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 34, color: Colors.grey.shade400),
    const SizedBox(height: 8),
    Text(text, style: const TextStyle(fontSize: 13, color: Colors.black38)),
  ]));
}