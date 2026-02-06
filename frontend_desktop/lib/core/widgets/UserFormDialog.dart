import 'package:flutter/material.dart';

class UserFormDialog extends StatefulWidget {
  final Map<String, String>? initialData;

  const UserFormDialog({super.key, this.initialData});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    emailCtrl =
        TextEditingController(text: widget.initialData?['email'] ?? '');
    addressCtrl =
        TextEditingController(text: widget.initialData?['address'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Benutzer bearbeiten' : 'Benutzer anlegen',
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              _field('Name', nameCtrl),
              _field('Email / Tel.', emailCtrl),
              _field('Adresse', addressCtrl),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'name': nameCtrl.text,
                        'email': emailCtrl.text,
                        'address': addressCtrl.text,
                      });
                    },
                    child: Text(isEdit ? 'Speichern' : 'Anlegen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
