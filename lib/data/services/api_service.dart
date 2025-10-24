import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hw/core/storage/secure_storage.dart';
import 'package:hw/core/config/app_config.dart';

class ApiService {
  //static final String baseUrl = AppConfig.baseUrl; // o tu IP local
  static final _storage = SecureStorage();
  // print(${AppConfig.baseUrl});

  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      String deviceId, // 🔹 nuevo parámetro
      ) async {
    final url = Uri.parse('${AppConfig.baseUrl}/signin');
    print (url);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correoelectronico': email,
        'contrasenia': password,
        'deviceId': deviceId, // 🔹 lo mandamos al backend
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Login correcto (${response.statusCode})');

      final cookie = response.headers['set-cookie'];
      String? token;

      if (cookie != null && cookie.contains('token=')) {
        final tokenMatch = RegExp(r'token=([^;]+)').firstMatch(cookie);
        token = tokenMatch?.group(1);
        if (token != null && token.isNotEmpty) {
          await _storage.saveToken(token);
        } else {
          print('⚠️ No se encontró token en la cookie');
        }
      }

      final body = jsonDecode(response.body);
      if (token != null) body['token'] = token;
      return body;
    } else {
      throw Exception('Error: ${response.body}');
    }
  }


  static Future<String> getToken() async {
    final token = await _storage.getToken(); // ✅ usar getToken()
    return token ?? ''; // 🔹 evitar null
  }
  //
  static Future<void> clearToken() async {
    await _storage.deleteToken(); // ✅ usar deleteToken()
  }

  static Future<dynamic> getTramites() async {
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado');

    final url = Uri.parse('$AppConfig.baseUrl/tramitessp');
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
    final url = Uri.parse('${AppConfig.baseUrl}/signout');
    print (url);
    await http.post(url, headers: {'Authorization': 'Bearer $token'});
    await clearToken();
  }
}

