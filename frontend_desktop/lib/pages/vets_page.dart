import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';

class VetsPage extends StatelessWidget {
  const VetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tierärzte',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),

            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 280,
                  height: 44,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tierarzt suchen...',
                      prefixIcon: const Icon(Icons.search),
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
                    label: const Text('Tierarzt anlegen'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            CenteredCard(
              width: 1000,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.6,
                children: const [
                  _VetCard('Dr. Max Mustermann', 'Chirurgie'),
                  _VetCard('Dr. Anna Müller', 'Dermatologie'),
                  _VetCard('Dr. Peter Maier', 'Innere Medizin'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  final String name;
  final String specialty;

  const _VetCard(this.name, this.specialty);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.medical_services, size: 32),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(specialty, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
