import 'package:flutter/material.dart';
import '../core/api/petclinic_api.dart';
import '../core/widgets/figma_widgets.dart';

class VetsPage extends StatefulWidget {
  const VetsPage({super.key});
  @override
  State<VetsPage> createState() => _VetsPageState();
}

class _VetsPageState extends State<VetsPage> {
  List<Vet> _vets = [];
  List<Specialty> _specialties = [];
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
        PetClinicApi.getVets(),
        PetClinicApi.getSpecialties(),
      ]);
      _vets        = results[0] as List<Vet>;
      _specialties = results[1] as List<Specialty>;
    } catch (e) { _error = e.toString(); }
    setState(() => _loading = false);
  }

  List<Vet> get _filtered => _search.isEmpty ? _vets
      : _vets.where((v) => '${v.firstName} ${v.lastName} ${v.specialtyNames}'
      .toLowerCase().contains(_search.toLowerCase())).toList();

  Future<void> _openDialog({Vet? initial}) async {
    final firstCtrl = TextEditingController(text: initial?.firstName);
    final lastCtrl  = TextEditingController(text: initial?.lastName);
    final selected  = <Specialty>{...?initial?.specialties};

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => FigmaDialog(
          title: initial == null ? 'Tierarzt anlegen' : 'Tierarzt bearbeiten',
          confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
          fields: [
            FigmaField(label: 'Vorname', ctrl: firstCtrl),
            FigmaField(label: 'Nachname', ctrl: lastCtrl),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Spezialisierungen', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8, runSpacing: 6,
                  children: _specialties.map((s) {
                    final isSelected = selected.any((x) => x.id == s.id);
                    return FilterChip(
                      label: Text(s.name, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (v) => setS(() {
                        if (v) selected.add(s);
                        else selected.removeWhere((x) => x.id == s.id);
                      }),
                      selectedColor: const Color(0xFFD6EAD8),
                      checkmarkColor: const Color(0xFF3F7F46),
                    );
                  }).toList(),
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
      final vet = Vet(
        id: initial?.id,
        firstName: firstCtrl.text,
        lastName: lastCtrl.text,
        specialties: selected.toList(),
      );
      initial == null
          ? await PetClinicApi.createVet(vet)
          : await PetClinicApi.updateVet(vet);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  Future<void> _delete() async {
    if (_sel == null) return;
    try {
      await PetClinicApi.deleteVet(_filtered[_sel!].id!);
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
      title: 'Tierärzte',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => _search = v)),
        const SizedBox(width: 10),
        FigmaButton(label: 'Tierarzt anlegen', icon: Icons.add, onPressed: () => _openDialog()),
      ],
      content: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 12,
                mainAxisSpacing: 12, childAspectRatio: 2.2,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final vet = list[i];
                final globalIdx = _vets.indexWhere((v) => v.id == vet.id);
                final isSel = _sel == globalIdx;

                return GestureDetector(
                  onTap: () => setState(() => _sel = isSel ? null : globalIdx),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFFD6EAD8) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSel ? const Color(0xFF3F7F46) : Colors.grey.shade400,
                        width: isSel ? 2 : 1,
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                        ),
                        child: Row(children: [
                          Text(vet.firstName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Text(vet.lastName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                      // Specialties
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Spezialisierungen',
                                style: TextStyle(fontSize: 10, color: Colors.black45)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(vet.specialtyNames,
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            FigmaButton(label: 'Bearbeiten', enabled: _sel != null,
                onPressed: () => _openDialog(initial: _vets[_sel!])),
            const SizedBox(width: 10),
            FigmaButton(label: 'Löschen', enabled: _sel != null, onPressed: _delete),
          ]),
          const SizedBox(height: 4),
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