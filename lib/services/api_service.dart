import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // o tu IP local
  static const storage = FlutterSecureStorage();



  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correoelectronico': email, 'contrasenia': password}),
    );

    if (response.statusCode == 200) {
      print('✅ Login correcto (${response.statusCode})');

      // Buscar el token en los headers
      final cookie = response.headers['set-cookie'];
      String? token;

      if (cookie != null && cookie.contains('token=')) {
        // Extraemos el valor de token
        final tokenMatch = RegExp(r'token=([^;]+)').firstMatch(cookie);
        token = tokenMatch?.group(1);
        print('🎟️ Token extraído: $token');
        await storage.write(key: 'token', value: token);
      }

      final body = jsonDecode(response.body);
      if (token != null) {
        body['token'] = token; // Añadimos el token al body para usarlo
      }

      return body;
    } else {
      print('❌ Error al iniciar sesión (${response.statusCode})');
      throw Exception('Error: ${response.body}');
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> clearToken() async {
    await storage.delete(key: 'token');
  }

  static Future<dynamic> getTramites() async {
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado');

    final url = Uri.parse('$baseUrl/tramitessp');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Token inválido o expirado');
    } else {
      throw Exception('Error al obtener trámites: ${response.statusCode}');
    }
  }

  static Future<void> signOut() async {
    final token = await getToken();
    if (token == null) return;
    final url = Uri.parse('$baseUrl/signout');
    await http.post(url, headers: {'Authorization': 'Bearer $token'});
    await clearToken();
  }
}

