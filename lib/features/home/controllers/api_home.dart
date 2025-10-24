import '../../../core/storage/secure_storage.dart';
import '../../../core/config/app_config.dart';
import 'package:http/http.dart' as http;
import '../../../data/services/api_service.dart';
import 'dart:convert';

class HomeController {
  static final SecureStorage storage = SecureStorage();

  /// Trae los trámites usando el token guardado
  static Future<List<dynamic>> getUsuarios() async {
    final token = await storage.getToken();  // ✅ token aquí, no en la página
    if (token == null || token.isEmpty) {
      throw Exception('No hay token válido');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/usuarios');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // o parsearlo a modelos
    } else {
      throw Exception('Error al obtener trámites: ${response.statusCode}');
    }
  }
}
