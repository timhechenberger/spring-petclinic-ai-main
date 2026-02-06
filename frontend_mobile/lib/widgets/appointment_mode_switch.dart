import 'package:flutter/material.dart';
import '../pages/appointments/appointments_page.dart';

class AppointmentModeSwitch extends StatelessWidget {
  final AppointmentMode mode;
  final ValueChanged<AppointmentMode> onChanged;

  const AppointmentModeSwitch({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget seg(String text, AppointmentMode m, {required bool left, required bool right}) {
      final active = mode == m;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(m),
          child: Container(
            height: 44, // <- dicker
            decoration: BoxDecoration(
              color: active ? const Color(0xFF6BC46B) : const Color(0xFF9ED89E),
              borderRadius: BorderRadius.horizontal(
                left: left ? const Radius.circular(22) : Radius.zero,
                right: right ? const Radius.circular(22) : Radius.zero,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        seg('Tag', AppointmentMode.day, left: true, right: false),
        seg('Monat', AppointmentMode.month, left: false, right: false),
        seg('Jahr', AppointmentMode.year, left: false, right: true),
      ],
    );
  }
}
