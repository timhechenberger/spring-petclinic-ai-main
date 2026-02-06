import 'package:flutter/material.dart';

class AppointmentListItem extends StatelessWidget {
  final int index;
  final DateTime dateTime;

  const AppointmentListItem({
    super.key,
    required this.index,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final date =
        '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            width: 78,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
