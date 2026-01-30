import 'package:flutter/material.dart';
import '../pages/appointments/appointments_page.dart';

class AppointmentDateSelector extends StatelessWidget {
  final AppointmentMode mode;
  final DateTime cursor;
  final ValueChanged<DateTime> onChanged;

  const AppointmentDateSelector({
    super.key,
    required this.mode,
    required this.cursor,
    required this.onChanged,
  });

  void _shift(int dir) {
    if (mode == AppointmentMode.month) {
      final target = DateTime(cursor.year, cursor.month + dir, 1);
      final day = _clampDay(cursor.year, cursor.month + dir, cursor.day);
      onChanged(DateTime(target.year, target.month, day));
      return;
    }

    if (mode == AppointmentMode.year) {
      final year = cursor.year + dir;
      final day = _clampDay(year, cursor.month, cursor.day);
      onChanged(DateTime(year, cursor.month, day));
      return;
    }

    onChanged(cursor.add(Duration(days: dir)));
  }

  @override
  Widget build(BuildContext context) {
    final label = _fmtDate(cursor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _shift(-1),
          icon: const Icon(Icons.chevron_left, size: 26),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        IconButton(
          onPressed: () => _shift(1),
          icon: const Icon(Icons.chevron_right, size: 26),
        ),
      ],
    );
  }

  String _fmtDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }

  int _clampDay(int year, int month, int desiredDay) {
    final firstOfMonth = DateTime(year, month, 1);
    final firstNextMonth = DateTime(firstOfMonth.year, firstOfMonth.month + 1, 1);
    final lastDay = firstNextMonth.subtract(const Duration(days: 1)).day;
    return desiredDay > lastDay ? lastDay : desiredDay;
  }
}
