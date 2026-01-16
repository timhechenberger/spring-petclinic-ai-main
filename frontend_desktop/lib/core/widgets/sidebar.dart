import 'package:flutter/material.dart';
import '../navigation/menu_item.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final items = const [
    MenuItemData('Dashboard', Icons.dashboard),
    MenuItemData('Benutzer', Icons.people),
    MenuItemData('Tiere', Icons.pets),
    MenuItemData('Termine', Icons.event),
    MenuItemData('Tierärzte', Icons.medical_services),
    MenuItemData('Protokolle', Icons.receipt_long),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.green.shade800,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            'ADMIN\nDashboard',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            items.length,
                (i) => ListTile(
              leading: Icon(items[i].icon, color: Colors.white),
              title: Text(items[i].label,
                  style: const TextStyle(color: Colors.white)),
              selected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
          )
        ],
      ),
    );
  }
}
