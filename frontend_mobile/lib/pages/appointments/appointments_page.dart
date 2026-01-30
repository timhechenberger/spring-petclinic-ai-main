import 'package:flutter/material.dart';
import '../../widgets/appointment_list.dart';
import '../../widgets/appointment_mode_switch.dart';
import '../../widgets/appointment_date_selector.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

enum AppointmentMode { day, month, year }

class Appointment {
  final DateTime dateTime;
  Appointment(this.dateTime);
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final List<Appointment> appointments = [
    Appointment(DateTime(2025, 2, 21, 14, 21)),
    Appointment(DateTime(2026, 3, 22, 12, 46)),
    Appointment(DateTime(2030, 9, 22, 7, 3)),
  ];

  AppointmentMode mode = AppointmentMode.day;
  DateTime cursor = DateTime(2025, 9, 22);

  void addAppointment(DateTime dt) {
    setState(() {
      appointments.add(Appointment(dt));
    });
  }

  Future<void> _onAddPressed() async {
    final now = TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (pickedTime == null) return;

    final dt = DateTime(
      cursor.year,
      cursor.month,
      cursor.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    addAppointment(dt);
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
            const Text(
              'Anstehende Termine',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: AppointmentList(appointments: appointments),
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
                onPressed: _onAddPressed,
                child: const Text(
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
