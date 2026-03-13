import 'package:flutter/material.dart';
import '../../services/owner_session.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const green = Color(0xFF4E8750);
  static const bg = Color(0xFFF6EEF4);
  static const greyBox = Color(0xFFD9D9D9);
  static const innerGrey = Color(0xFFCFCACA);

  late final TextEditingController _ownerIdController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _ownerIdController = TextEditingController(
      text: OwnerSession.ownerId.toString(),
    );
  }

  @override
  void dispose() {
    _ownerIdController.dispose();
    super.dispose();
  }

  void _saveOwner() {
    final text = _ownerIdController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _errorText = 'Bitte eine Owner-ID eingeben';
      });
      return;
    }

    final parsed = int.tryParse(text);

    if (parsed == null || parsed <= 0) {
      setState(() {
        _errorText = 'Bitte eine gültige positive Zahl eingeben';
      });
      return;
    }

    OwnerSession.setOwnerId(parsed);

    setState(() {
      _errorText = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Owner wurde auf ID $parsed gesetzt'),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard({
    required Widget child,
    double minHeight = 86,
  }) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: greyBox,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _buildInnerItem(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: innerGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: OwnerSession.currentOwnerId,
      builder: (context, currentOwnerId, child) {
        return Container(
          color: bg,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: green,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Aktueller Owner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: greyBox,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Aktive Owner-ID: $currentOwnerId',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ownerIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Neue Owner-ID',
                      hintText: 'z. B. 1',
                      errorText: _errorText,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: green, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _saveOwner,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Owner wechseln',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildSectionTitle('Anstehende Termine'),
                  _buildPlaceholderCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInnerItem('1        22.03.2026        12:46'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSectionTitle('Tiere'),
                  _buildPlaceholderCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInnerItem(
                          'Aktuelle Tiere werden über die Owner-ID geladen',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}