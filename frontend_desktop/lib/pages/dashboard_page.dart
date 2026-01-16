import 'package:flutter/material.dart';
import '../core/widgets/centered_content.dart';
import '../core/widgets/centered_card.dart';
import '../core/widgets/dashboard_stat_card.dart';
import '../core/widgets/dashboard_calendar_card.dart';
import '../core/widgets/dashboard_activity_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CenteredContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: const [
                DashboardStatCard(value: '256', label: 'Tiere insgesamt'),
                DashboardStatCard(value: '112', label: 'Besitzer'),
                DashboardStatCard(value: '10', label: 'Termine heute'),
                DashboardStatCard(value: '12', label: 'Tierärzte aktiv'),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CenteredCard(width: 380, child: DashboardCalendarCard()),
                SizedBox(width: 32),
                CenteredCard(width: 380, child: DashboardActivityCard()),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
