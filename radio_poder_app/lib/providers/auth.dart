import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:radio_poder_app/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  Usuario? _usuario;
  DateTime? _expirtyDate;
  Timer? _authTimer;

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
    if (_expirtyDate != null &&
        _expirtyDate!.isAfter(DateTime.now()) &&
        _token != null) {
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
      // TODO: devolver el tiempo de expiración del token desde la api
      // No deberia estar hardcodeado
      _expirtyDate = DateTime.now().add(
        const Duration(
          minutes: 60,
        ),
      );

      _autoLogout();
      notifyListeners();
      // Guardando el token (y otros datos) en el dispositivo para que se
      //pueda acceder sin necesidad de logearse
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expirtyDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'].toString();
    _expirtyDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expirtyDate = null;
    _usuario = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expirtyDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> usuarioLogeado() async {
    const url = "https://192.168.1.106:45455/api/Usuarios/UsuarioLogeado";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer " + _token!,
      });

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> editarUsuario(
      String nombre, String apellido, String password) async {
    final url =
        "https://192.168.1.106:45455/api/Usuarios/EditarUsuario/${_usuario!.id}";

    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            "Authorization": "Bearer " + _token!,
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: json.encode({
            'nombre': nombre,
            'apellido': apellido,
            'password': password,
            'id': _usuario!.id,
            'email': _usuario!.email,
          }));

      if (response.statusCode == 400) {
        throw (response.body);
      }

      _usuario = Usuario(
        id: json.decode(response.body)['id'],
        nombre: json.decode(response.body)['nombre'],
        apellido: json.decode(response.body)['apellido'],
        email: json.decode(response.body)['email'],
      );

      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
