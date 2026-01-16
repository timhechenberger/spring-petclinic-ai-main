import 'package:flutter/material.dart';

class DashboardActivityCard extends StatelessWidget {
  const DashboardActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Letzte Aktivitäten',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Text('• Neuer Termin erstellt'),
            Text('• Termin bearbeitet'),
            Text('• Tier hinzugefügt'),
            Text('• Benutzer gelöscht'),
            Text('• Tier gelöscht'),
          ],
        ),
      ),
    );
  }
}
