import 'package:flutter/material.dart';
import '../pages/appointments/appointments_page.dart';
import 'appointment_list_item.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentList({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFC9C9C9),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    '#',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Datum',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: 78,
                  child: Text(
                    'Uhrzeit',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return AppointmentListItem(
                    index: index + 1,
                    dateTime: appointments[index].dateTime,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
