import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';

class VisitsPage extends StatelessWidget {
  const VisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Termine',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),

            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 44,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Datum auswählen',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Termin anlegen'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            CenteredCard(
              width: 1100,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('(Kalender kommt hier rein)'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Termine am ausgewählten Tag'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
