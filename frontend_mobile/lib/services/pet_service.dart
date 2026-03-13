import 'api_client.dart';

class PetService {
  static Future<Map<String, dynamic>> getPetById(int petId) async {
    final data = await ApiClient.get('/pets/$petId');
    final pet = Map<String, dynamic>.from(data);

    return {
      'id': pet['id'],
      'name': pet['name'] ?? '',
      'type': _extractPetType(pet),
      'status': 'OK',
      'birthdate': pet['birthDate'] ?? '',
      'timeline': _extractTimelineFromVisits(pet),
      'raw': pet,
    };
  }

  static Future<List<Map<String, dynamic>>> getPetTimeline(int petId) async {
    final data = await ApiClient.get('/pets/$petId/timeline');

    if (data is! List) {
      return [];
    }

    final timeline = data.map<Map<String, dynamic>>((entry) {
      final map = Map<String, dynamic>.from(entry);

      return {
        'id': map['id'],
        'date': map['eventDate'] ?? '',
        'type': map['type'] ?? '',
        'title': map['title'] ?? 'Eintrag',
      };
    }).toList();

    timeline.sort((a, b) {
      final aDate = (a['date'] ?? '').toString();
      final bDate = (b['date'] ?? '').toString();
      return bDate.compareTo(aDate);
    });

    return timeline;
  }

  static String _extractPetType(Map<String, dynamic> pet) {
    final type = pet['type'];

    if (type is Map<String, dynamic>) {
      return (type['name'] ?? '').toString();
    }

    if (type is String) {
      return type;
    }

    return '';
  }

  static List<Map<String, dynamic>> _extractTimelineFromVisits(
      Map<String, dynamic> pet,
      ) {
    final visits = pet['visits'];

    if (visits is! List) {
      return [];
    }

    final mapped = visits.map<Map<String, dynamic>>((visit) {
      final v = Map<String, dynamic>.from(visit);

      return {
        'id': v['id'],
        'date': v['date'] ?? '',
        'title': v['description'] ?? 'Besuch',
      };
    }).toList();

    mapped.sort((a, b) {
      final aDate = (a['date'] ?? '').toString();
      final bDate = (b['date'] ?? '').toString();
      return bDate.compareTo(aDate);
    });

    return mapped;
  }

  static Future<Map<String, dynamic>> addPetToOwner({
    required int ownerId,
    required String name,
    required String birthDateIso,
    required int typeId,
    required String typeName,
  }) async {
    final payload = {
      'name': name,
      'birthDate': birthDateIso,
      'type': {
        'id': typeId,
        'name': typeName,
      },
    };

    final data = await ApiClient.post('/owners/$ownerId/pets', payload);
    final pet = Map<String, dynamic>.from(data);

    return {
      'id': pet['id'],
      'name': pet['name'] ?? '',
      'type': _extractPetType(pet),
      'status': 'OK',
      'birthdate': pet['birthDate'] ?? '',
      'timeline': _extractTimelineFromVisits(pet),
      'raw': pet,
    };
  }
}