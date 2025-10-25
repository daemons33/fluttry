import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hw/core/storage/secure_storage.dart';
import 'package:hw/core/config/app_config.dart'; // ajusta según tu ruta

class ApiPlan {
  static final SecureStorage storage = SecureStorage();

  static Future<List<dynamic>> getPlanes() async {
    final token = await storage.getToken(); // o como tengas implementado tu storage
    if (token == null || token.isEmpty) {
      throw Exception('No hay token válido');
    }

    final url = Uri.parse('${AppConfig.baseUrl}/planes');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener planes: ${response.statusCode}');
    }
  }

  static Future<dynamic> crearPlan(Map<String, dynamic> data) async {
    final token = await storage.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/planes');
    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear plan: ${response.body}');
    }
  }

  static Future<dynamic> actualizarPlan(int id, Map<String, dynamic> data) async {
    final token = await storage.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/planes/$id');
    final response = await http.put(
      url,
      headers: _headers(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar plan: ${response.body}');
    }
  }

  static Future<void> eliminarPlan(int id) async {
    final token = await storage.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/planes/$id');
    final response = await http.delete(url, headers: _headers(token));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar plan');
    }
  }

  static Map<String, String> _headers(String? token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}

