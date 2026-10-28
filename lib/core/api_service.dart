import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Reemplazar con la IP/Domain local o de red de tu servidor MySQL/API
  static const String baseUrl = 'http://192.168.1.100/ecocomunidad_api'; 

  // Headers globales
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Ejemplo de petición GET genérica
  static Future<List<dynamic>> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Ejemplo de petición POST genérica
  static Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}