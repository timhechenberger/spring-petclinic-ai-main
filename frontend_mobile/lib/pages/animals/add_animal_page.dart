import 'package:flutter/material.dart';

import '../../services/owner_session.dart';
import '../../services/pet_service.dart';

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({super.key});

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final birthCtrl = TextEditingController();

  DateTime? birthDate;
  bool isSaving = false;

  // Achtung:
  // Diese IDs müssen zu deinem Backend passen.
  // Nach deinem Swagger/Response ist cat = 1 belegt.
  // Die restlichen Werte musst du ggf. an deine vorhandenen Pet Types anpassen.
  final List<_PetTypeOption> petTypes = const [
    _PetTypeOption(id: 1, label: 'Katze', apiName: 'cat'),
    _PetTypeOption(id: 2, label: 'Hund', apiName: 'dog'),
    _PetTypeOption(id: 3, label: 'Eidechse', apiName: 'lizard'),
    _PetTypeOption(id: 4, label: 'Schlange', apiName: 'snake'),
    _PetTypeOption(id: 5, label: 'Vogel', apiName: 'bird'),
    _PetTypeOption(id: 6, label: 'Hamster', apiName: 'hamster'),
  ];

  _PetTypeOption? selectedType;

  static const green = Color(0xFF3E7C46);
  static const greyBox = Color(0xFFD9D9D9);
  static const bg = Color(0xFFF6EEF4);

  static const titleStyle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    color: green,
    height: 1.1,
  );

  static const labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    if (petTypes.isNotEmpty) {
      selectedType = petTypes.first;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    birthCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: birthDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthDate = picked;
        birthCtrl.text =
        '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      });
    }
  }

  String _toIsoDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (isSaving) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Geburtsdatum wählen')),
      );
      return;
    }

    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Tierart wählen')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await PetService.addPetToOwner(
        ownerId: OwnerSession.ownerId,
        name: nameCtrl.text.trim(),
        birthDateIso: _toIsoDate(birthDate!),
        typeId: selectedType!.id,
        typeName: selectedType!.apiName,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tier konnte nicht angelegt werden: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  InputDecoration _inputDec() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _backRow() {
    return Row(
      children: [
        IconButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom + 22,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backRow(),
            const SizedBox(height: 2),
            const Text('Tier hinzufügen', style: titleStyle),
            const SizedBox(height: 12),

            Text(
              'Aktueller Owner: ${OwnerSession.ownerId}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: green,
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: greyBox,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameCtrl,
                        enabled: !isSaving,
                        decoration: _inputDec(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text('Art', style: labelStyle),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<_PetTypeOption>(
                        value: selectedType,
                        decoration: _inputDec(),
                        items: petTypes.map((type) {
                          return DropdownMenuItem<_PetTypeOption>(
                            value: type,
                            child: Text(
                              type.label,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: isSaving
                            ? null
                            : (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Pflichtfeld' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text('Geburtsdatum', style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: birthCtrl,
                        readOnly: true,
                        enabled: !isSaving,
                        onTap: _pickDate,
                        decoration: _inputDec().copyWith(
                          suffixIcon: const Icon(Icons.calendar_month),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Center(
              child: SizedBox(
                width: 260,
                height: 44,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Tier hinzufügen',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetTypeOption {
  final int id;
  final String label;
  final String apiName;

  const _PetTypeOption({
    required this.id,
    required this.label,
    required this.apiName,
  });
}