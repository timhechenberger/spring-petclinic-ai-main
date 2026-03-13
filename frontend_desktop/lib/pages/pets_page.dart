import 'package:flutter/material.dart';
import '../core/api/petclinic_api.dart';
import '../core/widgets/figma_widgets.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});
  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  List<Pet> _pets = [];
  List<Owner> _owners = [];
  List<PetType> _types = [];
  bool _loading = true;
  String? _error;
  int? _sel;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        PetClinicApi.getPets(),
        PetClinicApi.getOwners(),
        PetClinicApi.getPetTypes(),
      ]);
      _pets   = results[0] as List<Pet>;
      _owners = results[1] as List<Owner>;
      _types  = results[2] as List<PetType>;
    } catch (e) { _error = e.toString(); }
    setState(() => _loading = false);
  }

  List<Pet> get _filtered => _search.isEmpty ? _pets
      : _pets.where((p) => '${p.name} ${p.type?.name ?? ''}'
      .toLowerCase().contains(_search.toLowerCase())).toList();

  String _ownerName(int? ownerId) {
    if (ownerId == null) return '–';
    final o = _owners.firstWhere((o) => o.id == ownerId,
        orElse: () => Owner(firstName: '?', lastName: '?', address: '', city: '', telephone: ''));
    return '${o.firstName} ${o.lastName}';
  }

  Future<void> _openDialog({Pet? initial}) async {
    final nameCtrl  = TextEditingController(text: initial?.name);
    final birthCtrl = TextEditingController(text: initial?.birthDate);
    PetType? selectedType = initial?.type ?? (_types.isNotEmpty ? _types.first : null);
    Owner?   selectedOwner = initial?.ownerId != null
        ? _owners.firstWhere((o) => o.id == initial!.ownerId,
        orElse: () => _owners.first)
        : (_owners.isNotEmpty ? _owners.first : null);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => FigmaDialog(
          title: initial == null ? 'Tier anlegen' : 'Tier bearbeiten',
          confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
          fields: [
            FigmaField(label: 'Name', ctrl: nameCtrl),
            FigmaField(label: 'Geburtsdatum (YYYY-MM-DD)', ctrl: birthCtrl),
            // Type dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Tierart', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                DropdownButtonFormField<PetType>(
                  value: selectedType,
                  items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                  onChanged: (v) => setS(() => selectedType = v),
                  decoration: const InputDecoration(
                    filled: true, fillColor: Colors.white, isDense: true,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  ),
                ),
              ]),
            ),
            // Owner dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Besitzer', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                DropdownButtonFormField<Owner>(
                  value: selectedOwner,
                  items: _owners.map((o) => DropdownMenuItem(
                      value: o, child: Text('${o.firstName} ${o.lastName}'))).toList(),
                  onChanged: (v) => setS(() => selectedOwner = v),
                  decoration: const InputDecoration(
                    filled: true, fillColor: Colors.white, isDense: true,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFBDBDBD))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  ),
                ),
              ]),
            ),
          ],
          onConfirm: () => Navigator.pop(ctx, true),
        ),
      ),
    );
    if (ok != true) return;

    try {
      final pet = Pet(
        id: initial?.id,
        name: nameCtrl.text,
        birthDate: birthCtrl.text,
        type: selectedType,
        ownerId: selectedOwner?.id,
      );
      initial == null
          ? await PetClinicApi.createPet(pet)
          : await PetClinicApi.updatePet(pet);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  Future<void> _delete() async {
    if (_sel == null) return;
    try {
      await PetClinicApi.deletePet(_filtered[_sel!].id!);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  void _err(Object e) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red.shade700));

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _ErrorView(message: _error!, onRetry: _load);

    final list = _filtered;
    return FigmaPage(
      title: 'Tiere',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => _search = v)),
        const SizedBox(width: 10),
        FigmaButton(label: 'Tier hinzufügen', icon: Icons.add, onPressed: () => _openDialog()),
      ],
      content: FigmaTableCard(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Tierart')),
          DataColumn(label: Text('Besitzer')),
          DataColumn(label: Text('Geburtsdatum')),
        ],
        rows: List.generate(list.length, (i) {
          final p = list[i];
          return DataRow(
            selected: _sel == i,
            onSelectChanged: (_) => setState(() => _sel = _sel == i ? null : i),
            cells: [
              DataCell(Text(p.name)),
              DataCell(Text(p.type?.name ?? '–')),
              DataCell(Text(_ownerName(p.ownerId))),
              DataCell(Text(p.birthDate)),
            ],
          );
        }),
        footerActions: [
          FigmaButton(label: 'Bearbeiten', enabled: _sel != null,
              onPressed: () => _openDialog(initial: list[_sel!])),
          const SizedBox(width: 10),
          FigmaButton(label: 'Löschen', enabled: _sel != null, onPressed: _delete),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message; final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey.shade400),
      const SizedBox(height: 12),
      const Text('Verbindung fehlgeschlagen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(message, style: const TextStyle(fontSize: 12, color: Colors.black45), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      ElevatedButton.icon(onPressed: onRetry,
          icon: const Icon(Icons.refresh, size: 16), label: const Text('Erneut versuchen'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F7F46),
              foregroundColor: Colors.white, elevation: 0)),
    ]),
  );
}