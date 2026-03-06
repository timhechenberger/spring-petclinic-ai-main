import 'dart:convert';
import 'package:http/http.dart' as http;

const String _base = 'http://localhost:9966/petclinic/api';

// ── Generic helpers ────────────────────────────────────────────────────────────

Future<dynamic> _get(String path) async {
  final res = await http.get(Uri.parse('$_base$path'));
  if (res.statusCode == 200) return jsonDecode(res.body);
  throw Exception('GET $path failed: ${res.statusCode}');
}

Future<dynamic> _post(String path, Map<String, dynamic> body) async {
  final res = await http.post(
    Uri.parse('$_base$path'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
  if (res.statusCode == 200 || res.statusCode == 201) return jsonDecode(res.body);
  throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
}

Future<dynamic> _put(String path, Map<String, dynamic> body) async {
  final res = await http.put(
    Uri.parse('$_base$path'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
  if (res.statusCode == 200 || res.statusCode == 204) {
    return res.body.isNotEmpty ? jsonDecode(res.body) : null;
  }
  throw Exception('PUT $path failed: ${res.statusCode} ${res.body}');
}

Future<void> _delete(String path) async {
  final res = await http.delete(Uri.parse('$_base$path'));
  if (res.statusCode != 200 && res.statusCode != 204) {
    throw Exception('DELETE $path failed: ${res.statusCode}');
  }
}

// ── Models ─────────────────────────────────────────────────────────────────────

class Owner {
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String telephone;
  final List<Pet> pets;

  Owner({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.telephone,
    this.pets = const [],
  });

  factory Owner.fromJson(Map<String, dynamic> j) => Owner(
    id: j['id'],
    firstName: j['firstName'] ?? '',
    lastName: j['lastName'] ?? '',
    address: j['address'] ?? '',
    city: j['city'] ?? '',
    telephone: j['telephone'] ?? '',
    pets: (j['pets'] as List? ?? []).map((p) => Pet.fromJson(p)).toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'address': address,
    'city': city,
    'telephone': telephone,
  };
}

class PetType {
  final int? id;
  final String name;
  PetType({this.id, required this.name});
  factory PetType.fromJson(Map<String, dynamic> j) =>
      PetType(id: j['id'], name: j['name'] ?? '');
  Map<String, dynamic> toJson() => {if (id != null) 'id': id, 'name': name};
}

class Pet {
  final int? id;
  final String name;
  final String birthDate;
  final PetType? type;
  final int? ownerId;
  final List<Visit> visits;

  Pet({
    this.id,
    required this.name,
    required this.birthDate,
    this.type,
    this.ownerId,
    this.visits = const [],
  });

  factory Pet.fromJson(Map<String, dynamic> j) => Pet(
    id: j['id'],
    name: j['name'] ?? '',
    birthDate: j['birthDate'] ?? '',
    type: j['type'] != null ? PetType.fromJson(j['type']) : null,
    ownerId: j['ownerId'],
    visits: (j['visits'] as List? ?? []).map((v) => Visit.fromJson(v)).toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'name': name,
    'birthDate': birthDate,
    if (type != null) 'type': type!.toJson(),
    if (ownerId != null) 'ownerId': ownerId,
  };
}

class Specialty {
  final int? id;
  final String name;
  Specialty({this.id, required this.name});
  factory Specialty.fromJson(Map<String, dynamic> j) =>
      Specialty(id: j['id'], name: j['name'] ?? '');
  Map<String, dynamic> toJson() => {if (id != null) 'id': id, 'name': name};
}

class Vet {
  final int? id;
  final String firstName;
  final String lastName;
  final List<Specialty> specialties;

  Vet({
    this.id,
    required this.firstName,
    required this.lastName,
    this.specialties = const [],
  });

  factory Vet.fromJson(Map<String, dynamic> j) => Vet(
    id: j['id'],
    firstName: j['firstName'] ?? '',
    lastName: j['lastName'] ?? '',
    specialties: (j['specialties'] as List? ?? [])
        .map((s) => Specialty.fromJson(s))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'specialties': specialties.map((s) => s.toJson()).toList(),
  };

  String get fullName => 'Dr. $firstName $lastName';
  String get specialtyNames =>
      specialties.isEmpty ? '–' : specialties.map((s) => s.name).join(', ');
}

class Visit {
  final int? id;
  final String date;
  final String description;
  final int? petId;

  Visit({
    this.id,
    required this.date,
    required this.description,
    this.petId,
  });

  factory Visit.fromJson(Map<String, dynamic> j) => Visit(
    id: j['id'],
    date: j['date'] ?? '',
    description: j['description'] ?? '',
    petId: j['petId'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'date': date,
    'description': description,
    if (petId != null) 'petId': petId,
  };
}

// ── API calls ──────────────────────────────────────────────────────────────────

class PetClinicApi {
  // Owners
  static Future<List<Owner>> getOwners() async {
    final data = await _get('/owners');
    return (data as List).map((j) => Owner.fromJson(j)).toList();
  }

  static Future<Owner> createOwner(Owner o) async {
    final data = await _post('/owners', o.toJson());
    return Owner.fromJson(data);
  }

  static Future<Owner> updateOwner(Owner o) async {
    final data = await _put('/owners/${o.id}', o.toJson());
    return data != null ? Owner.fromJson(data) : o;
  }

  static Future<void> deleteOwner(int id) => _delete('/owners/$id');

  // Pets
  static Future<List<Pet>> getPets() async {
    final data = await _get('/pets');
    return (data as List).map((j) => Pet.fromJson(j)).toList();
  }

  static Future<List<PetType>> getPetTypes() async {
    final data = await _get('/pettypes');
    return (data as List).map((j) => PetType.fromJson(j)).toList();
  }

  static Future<Pet> createPet(Pet p) async {
    final data = await _post('/pets', p.toJson());
    return Pet.fromJson(data);
  }

  static Future<Pet> updatePet(Pet p) async {
    final data = await _put('/pets/${p.id}', p.toJson());
    return data != null ? Pet.fromJson(data) : p;
  }

  static Future<void> deletePet(int id) => _delete('/pets/$id');

  // Vets
  static Future<List<Vet>> getVets() async {
    final data = await _get('/vets');
    return (data as List).map((j) => Vet.fromJson(j)).toList();
  }

  static Future<List<Specialty>> getSpecialties() async {
    final data = await _get('/specialties');
    return (data as List).map((j) => Specialty.fromJson(j)).toList();
  }

  static Future<Vet> createVet(Vet v) async {
    final data = await _post('/vets', v.toJson());
    return Vet.fromJson(data);
  }

  static Future<Vet> updateVet(Vet v) async {
    final data = await _put('/vets/${v.id}', v.toJson());
    return data != null ? Vet.fromJson(data) : v;
  }

  static Future<void> deleteVet(int id) => _delete('/vets/$id');

  // Visits
  static Future<List<Visit>> getVisits() async {
    final data = await _get('/visits');
    return (data as List).map((j) => Visit.fromJson(j)).toList();
  }

  static Future<Visit> createVisit(Visit v) async {
    final data = await _post('/visits', v.toJson());
    return Visit.fromJson(data);
  }

  static Future<Visit> updateVisit(Visit v) async {
    final data = await _put('/visits/${v.id}', v.toJson());
    return data != null ? Visit.fromJson(data) : v;
  }

  static Future<void> deleteVisit(int id) => _delete('/visits/$id');
}