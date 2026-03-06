import 'package:flutter/material.dart';
import '../core/api/petclinic_api.dart';
import '../core/widgets/figma_widgets.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});
  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  List<Visit> _visits = [];
  List<Pet> _pets = [];
  bool _loading = true;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  int? _sel;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        PetClinicApi.getVisits(),
        PetClinicApi.getPets(),
      ]);
      _visits = results[0] as List<Visit>;
      _pets   = results[1] as List<Pet>;
    } catch (e) { _error = e.toString(); }
    setState(() => _loading = false);
  }

  String _petName(int? petId) {
    if (petId == null) return '–';
    final p = _pets.firstWhere((p) => p.id == petId,
        orElse: () => Pet(name: '?', birthDate: ''));
    return p.name;
  }

  // Visits for selected day
  List<Visit> get _dayVisits {
    final key = _fmtDate(_selectedDate);
    return _visits.where((v) => v.date.startsWith(key)).toList();
  }

  // Days that have visits (for dot markers)
  bool _hasVisits(DateTime d) {
    final key = _fmtDate(d);
    return _visits.any((v) => v.date.startsWith(key));
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _openDialog({Visit? initial}) async {
    final descCtrl = TextEditingController(text: initial?.description);
    final dateCtrl = TextEditingController(
        text: initial?.date ?? _fmtDate(_selectedDate));
    Pet? selectedPet = initial?.petId != null
        ? _pets.firstWhere((p) => p.id == initial!.petId,
        orElse: () => _pets.first)
        : (_pets.isNotEmpty ? _pets.first : null);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => FigmaDialog(
          title: initial == null ? 'Termin anlegen' : 'Termin bearbeiten',
          confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
          fields: [
            FigmaField(label: 'Datum (YYYY-MM-DD)', ctrl: dateCtrl),
            FigmaField(label: 'Beschreibung', ctrl: descCtrl),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Tier', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                DropdownButtonFormField<Pet>(
                  value: selectedPet,
                  items: _pets.map((p) =>
                      DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: (v) => setS(() => selectedPet = v),
                  decoration: const InputDecoration(
                    filled: true, fillColor: Colors.white, isDense: true,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  ),
                ),
              ]),
            ),
          ],
          onConfirm: () => Navigator.pop(ctx, true),
        ),
      ),
    );
    if (ok != true) return;

    try {
      final visit = Visit(
        id: initial?.id,
        date: dateCtrl.text,
        description: descCtrl.text,
        petId: selectedPet?.id,
      );
      initial == null
          ? await PetClinicApi.createVisit(visit)
          : await PetClinicApi.updateVisit(visit);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  Future<void> _delete() async {
    if (_sel == null) return;
    try {
      await PetClinicApi.deleteVisit(_dayVisits[_sel!].id!);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  void _err(Object e) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red.shade700));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() { _selectedDate = picked; _sel = null; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _ErrorView(message: _error!, onRetry: _load);

    final day = _dayVisits;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Termine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(children: [
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
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.calendar_today, size: 15, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 10),
            FigmaButton(label: 'Termin anlegen', icon: Icons.add,
                onPressed: () => _openDialog()),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Calendar
              Expanded(
                flex: 55,
                child: _MonthCalendar(
                  selectedDate: _selectedDate,
                  hasVisits: _hasVisits,
                  onSelect: (d) => setState(() { _selectedDate = d; _sel = null; }),
                ),
              ),
              const SizedBox(width: 16),
              // Visit list
              Expanded(
                flex: 45,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                      child: Text(
                        'Termine – ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: day.isEmpty
                          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.event_note, size: 32, color: Colors.grey.shade300),
                        const SizedBox(height: 6),
                        Text('Keine Termine',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                      ]))
                          : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: day.length,
                        itemBuilder: (_, i) {
                          final v = day[i];
                          final isSel = _sel == i;
                          return GestureDetector(
                            onTap: () => setState(
                                    () => _sel = isSel ? null : i),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? Colors.grey.shade200
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSel
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(_petName(v.petId),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                    const SizedBox(height: 2),
                                    Text(v.description,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey.shade300))),
                      child: Row(children: [
                        FigmaButton(label: 'Bearbeiten', enabled: _sel != null,
                            onPressed: () => _openDialog(initial: day[_sel!])),
                        const SizedBox(width: 10),
                        FigmaButton(label: 'Löschen', enabled: _sel != null,
                            onPressed: _delete),
                      ]),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Month calendar (same as before) ───────────────────────────────────────────
class _MonthCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final bool Function(DateTime) hasVisits;
  final ValueChanged<DateTime> onSelect;
  const _MonthCalendar({required this.selectedDate, required this.hasVisits, required this.onSelect});

  static const _days = ['S','M','T','W','T','F','S'];
  String _monthName(int m) => const ['Januar','Februar','März','April','Mai','Juni',
    'Juli','August','September','Oktober','November','Dezember'][m-1];

  @override
  Widget build(BuildContext context) {
    final y = selectedDate.year; final mo = selectedDate.month;
    final dim = DateUtils.getDaysInMonth(y, mo);
    final offset = DateTime(y, mo, 1).weekday % 7;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade400)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            IconButton(icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: () => onSelect(DateTime(y, mo-1, 1)),
                padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            const Spacer(),
            Text('${_monthName(mo)} $y',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: () => onSelect(DateTime(y, mo+1, 1)),
                padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: _days.map((d) => Expanded(
              child: Center(child: Text(d, style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black45))))).toList()),
        ),
        Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 6), color: Colors.grey.shade200),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemCount: offset + dim,
              itemBuilder: (_, i) {
                if (i < offset) return const SizedBox.shrink();
                final day = i - offset + 1;
                final date = DateTime(y, mo, day);
                final isSel = DateUtils.isSameDay(date, selectedDate);
                final isToday = DateUtils.isSameDay(date, DateTime.now());
                final hasDot = hasVisits(date);
                return GestureDetector(
                  onTap: () => onSelect(date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSel ? Colors.grey.shade300 : null,
                      border: Border.all(
                        color: isToday ? const Color(0xFF3F7F46) : Colors.grey.shade300,
                        width: isToday ? 1.5 : 1,
                      ),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Text('$day', style: TextStyle(
                        fontSize: 13,
                        color: isToday ? const Color(0xFF3F7F46) : Colors.black87,
                        fontWeight: isSel || isToday ? FontWeight.w600 : FontWeight.normal,
                      )),
                      if (hasDot) Positioned(bottom: 4, child: Container(
                        width: 4, height: 4,
                        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      )),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message; final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey.shade400),
      const SizedBox(height: 12),
      const Text('Verbindung fehlgeschlagen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(message, style: const TextStyle(fontSize: 12, color: Colors.black45), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton.icon(onPressed: onRetry,
          icon: const Icon(Icons.refresh, size: 16), label: const Text('Erneut versuchen'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F7F46),
              foregroundColor: Colors.white, elevation: 0)),
    ]),
  );
}