import 'package:flutter/material.dart';
import '../core/api/petclinic_api.dart';
import '../core/widgets/figma_widgets.dart';

class ProtocolsPage extends StatefulWidget {
  const ProtocolsPage({super.key});
  @override
  State<ProtocolsPage> createState() => _ProtocolsPageState();
}

class _ProtocolsPageState extends State<ProtocolsPage> {
  List<Visit> _visits = [];
  List<Pet> _pets = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        PetClinicApi.getVisits(),
        PetClinicApi.getPets(),
      ]);
      _visits = results[0] as List<Visit>;
      _pets   = results[1] as List<Pet>;
    } catch (e) { _error = e.toString(); }
    setState(() => _loading = false);
  }

  String _petName(int? id) {
    if (id == null) return '–';
    final p = _pets.firstWhere((p) => p.id == id,
        orElse: () => Pet(name: '?', birthDate: ''));
    return p.name;
  }

  List<Visit> get _filtered => _search.isEmpty ? _visits
      : _visits.where((v) =>
      '${_petName(v.petId)} ${v.description} ${v.date}'
          .toLowerCase().contains(_search.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _ErrorView(message: _error!, onRetry: _load);

    final list = _filtered;
    return FigmaPage(
      title: 'Protokolle',
      toolbarItems: [
        FigmaSearchField(hint: 'Suchen', onChanged: (v) => setState(() => _search = v)),
      ],
      content: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                columnSpacing: 28,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(label: Text('Datum')),
                  DataColumn(label: Text('Tier')),
                  DataColumn(label: Text('Beschreibung')),
                ],
                rows: list.map((v) => DataRow(cells: [
                  DataCell(Text(v.date, style: const TextStyle(fontSize: 12))),
                  DataCell(Text(_petName(v.petId))),
                  DataCell(Text(v.description)),
                ])).toList(),
              ),
            ),
          ),
        ),
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