import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  // Für Android Emulator
  static const String baseUrl = 'http://10.0.2.2:9966/petclinic/api';

  // Für Web / Desktop lokal
  // static const String baseUrl = 'http://localhost:9966/petclinic/api';

  static const Duration _timeout = Duration(seconds: 10);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('[API][GET] $uri');

      final response = await http
          .get(
        uri,
        headers: headers,
      )
          .timeout(_timeout);

      print('[API][GET][${response.statusCode}] $uri');
      return _processResponse(response);
    } on TimeoutException {
      throw Exception('Zeitüberschreitung bei GET $endpoint');
    } on http.ClientException catch (e) {
      throw Exception('Netzwerkfehler bei GET $endpoint: $e');
    } catch (e) {
      throw Exception('Unbekannter Fehler bei GET $endpoint: $e');
    }
  }

  static Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('[API][POST] $uri');
      print('[API][POST][BODY] ${jsonEncode(body)}');

      final response = await http
          .post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(_timeout);

      print('[API][POST][${response.statusCode}] $uri');
      return _processResponse(response);
    } on TimeoutException {
      throw Exception('Zeitüberschreitung bei POST $endpoint');
    } on http.ClientException catch (e) {
      throw Exception('Netzwerkfehler bei POST $endpoint: $e');
    } catch (e) {
      throw Exception('Unbekannter Fehler bei POST $endpoint: $e');
    }
  }

  static Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('[API][PUT] $uri');
      print('[API][PUT][BODY] ${jsonEncode(body)}');

      final response = await http
          .put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(_timeout);

      print('[API][PUT][${response.statusCode}] $uri');
      return _processResponse(response);
    } on TimeoutException {
      throw Exception('Zeitüberschreitung bei PUT $endpoint');
    } on http.ClientException catch (e) {
      throw Exception('Netzwerkfehler bei PUT $endpoint: $e');
    } catch (e) {
      throw Exception('Unbekannter Fehler bei PUT $endpoint: $e');
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('[API][DELETE] $uri');

      final response = await http
          .delete(
        uri,
        headers: headers,
      )
          .timeout(_timeout);

      print('[API][DELETE][${response.statusCode}] $uri');
      return _processResponse(response);
    } on TimeoutException {
      throw Exception('Zeitüberschreitung bei DELETE $endpoint');
    } on http.ClientException catch (e) {
      throw Exception('Netzwerkfehler bei DELETE $endpoint: $e');
    } catch (e) {
      throw Exception('Unbekannter Fehler bei DELETE $endpoint: $e');
    }
  }

  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }

      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    }

    throw Exception(
      'API Error ${response.statusCode}: ${response.body}',
    );
  }
}