import 'package:flutter/material.dart';

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({super.key});

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final birthCtrl = TextEditingController();

  DateTime? birthDate;

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
  void dispose() {
    nameCtrl.dispose();
    typeCtrl.dispose();
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
        "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      });
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte Geburtsdatum wählen")),
      );
      return;
    }

    final newAnimal = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "name": nameCtrl.text.trim(),
      "type": typeCtrl.text.trim(),
      "status": "OK",
      "birthdate": birthCtrl.text.trim(),
      "timeline": [
        {"date": "Jetzt", "title": "Tier angelegt"}
      ],
    };

    Navigator.pop(context, newAnimal);
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
          onPressed: () => Navigator.pop(context),
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
            const Text("Tier hinzufügen", style: titleStyle),
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
                      const Text("Name", style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: _inputDec(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Pflichtfeld" : null,
                      ),
                      const SizedBox(height: 20),

                      const Text("Art", style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: typeCtrl,
                        decoration: _inputDec(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Pflichtfeld" : null,
                      ),
                      const SizedBox(height: 20),

                      const Text("Geburtsdatum", style: labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: birthCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: _inputDec().copyWith(
                          suffixIcon: const Icon(Icons.calendar_month),
                        ),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Tier hinzufügen",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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
