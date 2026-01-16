import 'package:flutter/material.dart';
import '../core/widgets/sidebar.dart';

class AdminShell extends StatelessWidget {
  final Widget content;
  final int index;
  final ValueChanged<int> onSelect;

  const AdminShell({
    super.key,
    required this.content,
    required this.index,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: index,
            onSelect: onSelect,
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F7F4),
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
