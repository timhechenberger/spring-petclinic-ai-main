import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';

class PetCareAdminApp extends StatelessWidget {
  const PetCareAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare Admin',
      theme: AppTheme.light,
      home: const AdminRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
