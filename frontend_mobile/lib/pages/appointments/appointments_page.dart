import 'package:flutter/material.dart';

import '../../services/owner_session.dart';
import '../../widgets/appointment_date_selector.dart';
import '../../widgets/appointment_list.dart';
import '../../widgets/appointment_mode_switch.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

enum AppointmentMode { day, month, year }

class Appointment {
  final int? visitId;
  final int petId;
  final String petName;
  final String title;
  final DateTime dateTime;

  Appointment({
    required this.visitId,
    required this.petId,
    required this.petName,
    required this.title,
    required this.dateTime,
  });
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late List<Appointment> appointments;

  AppointmentMode mode = AppointmentMode.day;
  DateTime cursor = DateTime(2026, 3, 22);

  bool isAdding = false;

  final List<Map<String, dynamic>> ownerPets = [
    {'id': 1, 'name': 'Leo'},
    {'id': 2, 'name': 'Mimi'},
    {'id': 3, 'name': 'Bello'},
  ];

  @override
  void initState() {
    super.initState();

    appointments = [
      Appointment(
        visitId: 1,
        petId: 1,
        petName: 'Leo',
        title: 'Impfung',
        dateTime: DateTime(2026, 3, 22, 12, 46),
      ),
      Appointment(
        visitId: 2,
        petId: 2,
        petName: 'Mimi',
        title: 'Kontrolle',
        dateTime: DateTime(2026, 3, 22, 14, 30),
      ),
      Appointment(
        visitId: 3,
        petId: 3,
        petName: 'Bello',
        title: 'Nachuntersuchung',
        dateTime: DateTime(2026, 4, 3, 9, 15),
      ),
      Appointment(
        visitId: 4,
        petId: 1,
        petName: 'Leo',
        title: 'Zahncheck',
        dateTime: DateTime(2026, 8, 11, 11, 0),
      ),
      Appointment(
        visitId: 5,
        petId: 2,
        petName: 'Mimi',
        title: 'Jahreskontrolle',
        dateTime: DateTime(2027, 1, 19, 8, 45),
      ),
    ];
  }

  Future<void> _onAddPressed() async {
    if (isAdding) return;

    if (ownerPets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keine Tiere vorhanden'),
        ),
      );
      return;
    }

    final selectedPet = await _showPetSelectionDialog();
    if (selectedPet == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final newDate = DateTime(
      cursor.year,
      cursor.month,
      cursor.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      isAdding = true;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    setState(() {
      appointments.add(
        Appointment(
          visitId: DateTime.now().millisecondsSinceEpoch,
          petId: selectedPet['id'] as int,
          petName: (selectedPet['name'] ?? '').toString(),
          title: 'Neuer Termin',
          dateTime: newDate,
        ),
      );

      appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      isAdding = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Termin für ${selectedPet['name']} hinzugefügt',
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showPetSelectionDialog() async {
    Map<String, dynamic>? tempSelected =
    ownerPets.isNotEmpty ? ownerPets.first : null;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Tier auswählen'),
              content: DropdownButtonFormField<Map<String, dynamic>>(
                value: tempSelected,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ownerPets.map((pet) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: pet,
                    child: Text((pet['name'] ?? '').toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setLocalState(() {
                    tempSelected = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempSelected),
                  child: const Text('Weiter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Appointment> get _filteredAppointments {
    final source = [...appointments]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    switch (mode) {
      case AppointmentMode.day:
        return source.where((a) {
          return a.dateTime.year == cursor.year &&
              a.dateTime.month == cursor.month &&
              a.dateTime.day == cursor.day;
        }).toList();

      case AppointmentMode.month:
        return source.where((a) {
          return a.dateTime.year == cursor.year &&
              a.dateTime.month == cursor.month;
        }).toList();

      case AppointmentMode.year:
        return source.where((a) {
          return a.dateTime.year == cursor.year;
        }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            const Text(
              'Termine',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4A7B4B),
                fontSize: 46,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Anstehende Termine (Owner ${OwnerSession.ownerId})',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: AppointmentList(appointments: _filteredAppointments),
            ),

            const SizedBox(height: 18),

            AppointmentModeSwitch(
              mode: mode,
              onChanged: (m) => setState(() => mode = m),
            ),

            const SizedBox(height: 12),

            AppointmentDateSelector(
              mode: mode,
              cursor: cursor,
              onChanged: (c) => setState(() => cursor = c),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7B4B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 4,
                ),
                onPressed: isAdding ? null : _onAddPressed,
                child: isAdding
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Termin hinzufügen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}