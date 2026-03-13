import 'package:flutter/material.dart';
import '../core/api/petclinic_api.dart';
import '../core/widgets/figma_widgets.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Owner> _owners = [];
  bool _loading = true;
  String? _error;
  int? _sel;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      _owners = await PetClinicApi.getOwners();
    } catch (e) { _error = e.toString(); }
    setState(() => _loading = false);
  }

  List<Owner> get _filtered => _search.isEmpty ? _owners
      : _owners.where((o) => '${o.firstName} ${o.lastName} ${o.telephone} ${o.address}'
      .toLowerCase().contains(_search.toLowerCase())).toList();

  Future<void> _openDialog({Owner? initial}) async {
    final f = TextEditingController(text: initial?.firstName);
    final l = TextEditingController(text: initial?.lastName);
    final t = TextEditingController(text: initial?.telephone);
    final a = TextEditingController(text: initial?.address);
    final c = TextEditingController(text: initial?.city);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => FigmaDialog(
        title: initial == null ? 'Benutzer anlegen' : 'Benutzer bearbeiten',
        confirmLabel: initial == null ? 'Anlegen' : 'Speichern',
        fields: [
          FigmaField(label: 'Vorname', ctrl: f),
          FigmaField(label: 'Nachname', ctrl: l),
          FigmaField(label: 'Telefon', ctrl: t),
          FigmaField(label: 'Adresse', ctrl: a),
          FigmaField(label: 'Stadt', ctrl: c),
        ],
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (ok != true) return;

    try {
      final o = Owner(id: initial?.id, firstName: f.text, lastName: l.text,
          telephone: t.text, address: a.text, city: c.text);
      initial == null ? await PetClinicApi.createOwner(o) : await PetClinicApi.updateOwner(o);
      setState(() => _sel = null);
      await _load();
    } catch (e) { _err(e); }
  }

  Future<void> _delete() async {
    if (_sel == null) return;
    try {
      await PetClinicApi.deleteOwner(_filtered[_sel!].id!);
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
      title: 'Benutzer',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => _search = v)),
        const SizedBox(width: 10),
        FigmaButton(label: 'Benutzer anlegen', icon: Icons.add, onPressed: () => _openDialog()),
      ],
      content: FigmaTableCard(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Telefon')),
          DataColumn(label: Text('Adresse')),
          DataColumn(label: Text('Tiere')),
        ],
        rows: List.generate(list.length, (i) {
          final o = list[i];
          return DataRow(
            selected: _sel == i,
            onSelectChanged: (_) => setState(() => _sel = _sel == i ? null : i),
            cells: [
              DataCell(Text('${o.firstName} ${o.lastName}')),
              DataCell(Text(o.telephone)),
              DataCell(Text('${o.address}, ${o.city}')),
              DataCell(Text('${o.pets.length}')),
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