import 'api_client.dart';
import 'owner_service.dart';

class VisitService {
  static List<Map<String, dynamic>> extractAppointmentsFromOwner(
      Map<String, dynamic> owner,
      ) {
    final pets = owner['pets'];

    if (pets is! List) {
      return [];
    }

    final List<Map<String, dynamic>> appointments = [];

    for (final pet in pets) {
      final petMap = Map<String, dynamic>.from(pet);
      final petId = petMap['id'];
      final petName = (petMap['name'] ?? '').toString();
      final visits = petMap['visits'];

      if (petId == null || visits is! List) continue;

      for (final visit in visits) {
        final visitMap = Map<String, dynamic>.from(visit);
        final rawDate = (visitMap['date'] ?? '').toString();

        final parsedDate = _tryParseDate(rawDate);
        if (parsedDate == null) continue;

        appointments.add({
          'visitId': visitMap['id'],
          'petId': petId,
          'petName': petName,
          'dateTime': parsedDate,
          'title': (visitMap['description'] ?? 'Termin').toString(),
          'raw': visitMap,
        });
      }
    }

    final now = DateTime.now();

    appointments.removeWhere((item) {
      final dt = item['dateTime'];
      return dt is! DateTime || dt.isBefore(now);
    });

    appointments.sort((a, b) {
      final aDt = a['dateTime'] as DateTime;
      final bDt = b['dateTime'] as DateTime;
      return aDt.compareTo(bDt);
    });

    return appointments;
  }

  static Future<void> addVisit({
    required int ownerId,
    required int petId,
    required DateTime date,
    String description = 'Termin über App erstellt',
  }) async {
    final payload = {
      'date': _toIsoDate(date),
      'description': description,
    };

    await ApiClient.post('/owners/$ownerId/pets/$petId/visits', payload);
  }

  static DateTime? _tryParseDate(String raw) {
    if (raw.isEmpty) return null;

    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  static String _toIsoDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}