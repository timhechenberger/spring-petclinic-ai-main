import 'api_client.dart';

class OwnerService {
  static Future<Map<String, dynamic>> getOwnerById(int ownerId) async {
    final data = await ApiClient.get('/owners/$ownerId');
    return Map<String, dynamic>.from(data);
  }

  static Future<List<Map<String, dynamic>>> getPetsOfOwner(int ownerId) async {
    final owner = await getOwnerById(ownerId);
    final pets = owner['pets'];

    if (pets is! List) {
      return [];
    }

    return pets.map<Map<String, dynamic>>((pet) {
      final map = Map<String, dynamic>.from(pet);

      return {
        'id': map['id'],
        'name': map['name'] ?? '',
        'type': _extractPetType(map),
        'status': 'OK',
        'birthdate': map['birthDate'] ?? '',
        'timeline': _extractTimeline(map),
        'raw': map,
      };
    }).toList();
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

  static List<Map<String, dynamic>> _extractTimeline(Map<String, dynamic> pet) {
    final visits = pet['visits'];

    if (visits is! List) {
      return [];
    }

    return visits.map<Map<String, dynamic>>((visit) {
      final v = Map<String, dynamic>.from(visit);

      return {
        'date': v['date'] ?? '',
        'title': v['description'] ?? 'Besuch',
      };
    }).toList();
  }
}