import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:radio_poder_app/models/usuario.dart';

class Auth with ChangeNotifier {
  String? _token;
  Usuario? _usuario;

  Usuario? get usuario {
    if (_usuario != null) {
      return _usuario;
    }
    return null;
  }

  bool get isAuthenticated {
    return _token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  static const Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Future<void> register(
      String nombre, String apellido, String email, String password) async {
    const url = "https://192.168.1.106:45455/api/Usuarios/Register.json";

    try {
      final response = await http.post(Uri.parse(url),
          // headers: headers,
          body: json.encode({
            'nombre': nombre,
            'apellido': apellido,
            'email': email,
            'password': password,
          }));

      if (response.statusCode == 400) {
        throw (response.body);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    const url = "https://192.168.1.106:45455/api/Usuarios/Login";

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers,
          body: json.encode({
            'email': email,
            'password': password,
          }));

      if (response.statusCode == 400) {
        throw (response.body);
      }

      _token = response.body;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  logout() {
    _token = null;
    notifyListeners();
  }

  Future<void> usuarioLogeado() async {
    const url = "https://192.168.1.106:45455/api/Usuarios/UsuarioLogeado";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token!,
      });

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final usuarioCargado = Usuario(
        id: extractedData['id'],
        nombre: extractedData['nombre'],
        apellido: extractedData['apellido'],
        email: extractedData['email'],
        password: extractedData['password'],
      );

      _usuario = usuarioCargado;
      notifyListeners();

      print(usuarioCargado);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
