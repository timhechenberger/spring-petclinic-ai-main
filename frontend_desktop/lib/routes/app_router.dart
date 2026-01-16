import 'package:flutter/material.dart';
import '../shell/admin_shell.dart';
import '../pages/dashboard_page.dart';
import '../pages/users_page.dart';
import '../pages/pets_page.dart';
import '../pages/visits_page.dart';
import '../pages/vets_page.dart';
import '../pages/protocols_page.dart';


class AdminRouter extends StatefulWidget {
  const AdminRouter({super.key});

  @override
  State<AdminRouter> createState() => _AdminRouterState();
}

class _AdminRouterState extends State<AdminRouter> {
  int index = 0;

  final pages = const [
    DashboardPage(),
    UsersPage(),
    PetsPage(),
    VisitsPage(),
    VetsPage(),
    ProtocolsPage(),
    Center(child: Text('Benutzer')),
    Center(child: Text('Tiere')),
    Center(child: Text('Termine')),
    Center(child: Text('Tierärzte')),
    Center(child: Text('Protokolle')),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      index: index,
      content: pages[index],
      onSelect: (i) => setState(() => index = i),
    );
  }
}
