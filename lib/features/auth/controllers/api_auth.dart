import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hw/core/storage/secure_storage.dart';
import 'package:hw/core/config/app_config.dart';

class ApiAuthController {
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


}
