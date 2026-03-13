import 'package:flutter/material.dart';

enum SidebarMode { login, admin }

class AdminShell extends StatelessWidget {
  final int index;
  final Widget content;
  final ValueChanged<int>? onSelect;
  final VoidCallback? onLogout;
  final SidebarMode mode;

  const AdminShell({
    super.key,
    required this.index,
    required this.content,
    required this.mode,
    this.onSelect,
    this.onLogout,
  });

  bool get isAdmin => mode == SidebarMode.admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: const Color(0xFF3F7F46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Brand header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (isAdmin) ...[
            _NavItem(icon: Icons.dashboard, label: 'Dashboard', active: index == 0, onTap: () => onSelect!(0)),
            _NavItem(icon: Icons.people, label: 'Benutzer', active: index == 1, onTap: () => onSelect!(1)),
            _NavItem(icon: Icons.medical_services, label: 'Tierärzte', active: index == 4, onTap: () => onSelect!(4)),
            _NavItem(icon: Icons.pets, label: 'Tiere', active: index == 2, onTap: () => onSelect!(2)),
            _NavItem(icon: Icons.event, label: 'Termine', active: index == 3, onTap: () => onSelect!(3)),
            _NavItem(icon: Icons.list_alt, label: 'Protokolle', active: index == 5, onTap: () => onSelect!(5)),
          ],

          const Spacer(),

          // Logo block
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pets, color: Color(0xFF3F7F46), size: 28),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PetCare', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF3F7F46))),
                          Text('Admin', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout, color: Colors.white70, size: 16),
                      label: const Text('Logout', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.black.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}