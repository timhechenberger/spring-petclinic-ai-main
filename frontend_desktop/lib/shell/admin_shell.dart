import 'package:flutter/material.dart';

enum SidebarMode {
  login,
  admin,
}

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
      width: 240,
      color: const Color(0xFF3F7F46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'ADMIN\nDashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Navigation nur im Admin-Modus
          if (isAdmin) ...[
            _NavItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              active: index == 0,
              onTap: () => onSelect!(0),
            ),
            _NavItem(
              icon: Icons.people,
              label: 'Benutzer',
              active: index == 1,
              onTap: () => onSelect!(1),
            ),
            _NavItem(
              icon: Icons.medical_services,
              label: 'Tierärzte',
              active: index == 4,
              onTap: () => onSelect!(4),
            ),
            _NavItem(
              icon: Icons.pets,
              label: 'Tiere',
              active: index == 2,
              onTap: () => onSelect!(2),
            ),
            _NavItem(
              icon: Icons.event,
              label: 'Termine',
              active: index == 3,
              onTap: () => onSelect!(3),
            ),
            _NavItem(
              icon: Icons.list_alt,
              label: 'Protokolle',
              active: index == 5,
              onTap: () => onSelect!(5),
            ),
          ],

          const Spacer(),

          // 🐾 LOGO-BLOCK (zentriert & integriert)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/petcare_logo.png',
                    width: 110,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 12),

                // 🚪 Logout UNTER dem Logo
                if (isAdmin)
                  TextButton.icon(
                    onPressed: onLogout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
          active ? Colors.black.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
