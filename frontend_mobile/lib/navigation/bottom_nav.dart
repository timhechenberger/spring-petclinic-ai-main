import 'package:flutter/material.dart';

import '../pages/animals/animals_page.dart';
import '../pages/appointments/appointments_page.dart';
import '../pages/support/support_page.dart';
import '../pages/profile/profile_page.dart';


const _bgGreen = Color(0xFF579B5C);
const _activeBlue = Color(0xFF232E64);
const _inactiveWhite = Colors.white;

// Gewünschte “sichtbare” Höhe der Bar OHNE SafeArea-Bottom
const double _barContentHeight = 150;

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _index = 0;

  final _pages = const [
    AnimalsPage(),
    AppointmentsPage(),
    SupportPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // IndexedStack (Tabs behalten ihren State)
    // https://docs.flutter.dev/ui/widgets/basic/IndexedStack-class.html
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),

      // BottomAppBar (freie Kontrolle über Höhe & Layout)
      // https://docs.flutter.dev/ui/widgets/material/BottomAppBar-class.html
      bottomNavigationBar: BottomAppBar(
        color: _bgGreen,
        padding: EdgeInsets.zero,
        child: Builder(
          builder: (context) {
            final bottomInset = MediaQuery.of(context).padding.bottom;
            final totalHeight = _barContentHeight + bottomInset;

            return SizedBox(
              height: totalHeight,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      label: 'Tiere',
                      icon: Icons.bug_report,
                      selected: _index == 0,
                      onTap: () => setState(() => _index = 0),
                    ),
                    _NavItem(
                      label: 'Termine',
                      icon: Icons.calendar_month,
                      selected: _index == 1,
                      onTap: () => setState(() => _index = 1),
                    ),
                    _NavItem(
                      label: 'Support',
                      icon: Icons.settings,
                      selected: _index == 2,
                      onTap: () => setState(() => _index = 2),
                    ),
                    _NavItem(
                      label: 'Profil',
                      icon: Icons.person,
                      selected: _index == 3,
                      onTap: () => setState(() => _index = 3),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _activeBlue : _inactiveWhite;

    // InkWell (Touch + Ripple)
    // https://docs.flutter.dev/ui/widgets/material/InkWell-class.html
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 72),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // kein starres Padding mehr
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
