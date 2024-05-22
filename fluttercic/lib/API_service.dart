import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttercic/solicitud_model.dart'; // Importa el archivo con la definición de SolicitudModel
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final String baseUrl;

  APIService({required this.baseUrl});

  Future<String?> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionToken');
  }

  Future<void> setSessionToken(String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sessionToken', sessionToken);
  }

  Future<void> removeSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('sessionToken');
  }

  Future<String> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/loginMovil');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final sessionToken = responseData['token'];
      await setSessionToken(sessionToken);
      return sessionToken;
    } else {
      throw Exception('Error de inicio de sesión');
    }
  }

  Future<void> createSolicitud(SolicitudModel solicitud) async {
    final sessionToken = await getSessionToken();

    if (sessionToken == null) {
      throw Exception('Sesión no iniciada');
    }

    final url = Uri.parse('$baseUrl/solicitudesAppMovil');
    final body = solicitud.toJson();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<SolicitudModel>> obtenerHistorialSolicitudes() async { // Corregido el tipo de retorno
    final sessionToken = await getSessionToken();

    if (sessionToken == null) {
      throw Exception('Sesión no iniciada');
    }

    final url = Uri.parse('$baseUrl/historialsolicitudesAppMovil');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $sessionToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => SolicitudModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener el historial');
    }
  }
}
