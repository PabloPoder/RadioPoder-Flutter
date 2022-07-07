import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:radio_poder_app/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constantes.dart';

class Auth with ChangeNotifier {
  String? _token;
  Usuario? _usuario;
  DateTime? _expirtyDate;
  Timer? _authTimer;
  bool? _ingresoConGoogle;

  bool get ingresoConGoogle => _ingresoConGoogle ?? false;

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
    const url = apiUrl + "Usuarios/Register";

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers,
          body: json.encode({
            'nombre': nombre,
            'apellido': apellido,
            'email': email,
            'password': password,
          }));

      if (response.statusCode == 400) {
        throw (response.body);
      }

      await login(email, password);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    const url = apiUrl + "Usuarios/Login";

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

      usuarioLogeado();
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
    if (!prefs.containsKey('ingresoConGoogle')) {
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
    _ingresoConGoogle = prefs.getBool('ingresoConGoogle');
    usuarioLogeado();
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
    // Cerramos sesion de google en caso de que se haya logeado con ella.
    googleLogout();

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showIntro', true);
    prefs.remove('userData');
    prefs.remove('ingresoConGoogle');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expirtyDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> usuarioLogeado() async {
    const url = apiUrl + "Usuarios/UsuarioLogeado";

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
    final url = apiUrl + "Usuarios/EditarUsuario/${_usuario!.id}";

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

  Future<void> editarUsuarioGoogle(String nombre, String apellido) async {
    final url = apiUrl + "Usuarios/EditarUsuarioGoogle/${_usuario!.id}";

    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            "Authorization": "Bearer " + _token!,
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: json.encode({
            'nombre': nombre,
            'apellido': apellido,
            'id': _usuario!.id,
            'password': _usuario!.password,
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

  // Google Sign In
  // Variables para acceder a datos y funciones de Google
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _currentUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    User? _usuarioGoogle = FirebaseAuth.instance.currentUser;

    // Revisar si usuario esta registrado en api, de no ser asi registrarlo.
    // Si ya esta registrado, entonces logearlo.
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('ingresoConGoogle', true);
    _ingresoConGoogle = prefs.getBool('ingresoConGoogle');

    await logearloORegistrarlo(_usuarioGoogle);
    notifyListeners();
  }

  Future<void> logearloORegistrarlo(User? _usuarioGoogle) async {
    final url = apiUrl + "Usuarios/GetPorEmail${_usuarioGoogle!.email}";
    print(url);

    try {
      final response = await http.get(Uri.parse(url));

      //Si ya hay un usuario registrado devuelve 200.
      if (response.statusCode == 200) {
        // Si ya esta registrado, entonces logearlo.
        await login(_usuarioGoogle.email!, _usuarioGoogle.uid);
        _ingresoConGoogle = true;
        notifyListeners();
      } else {
        // Registro del usuario en la api
        // Separo el nombre del apellido de _usuarioGoogle.displayName
        List<String> _usuarioGoogleFullName =
            _usuarioGoogle.displayName!.split(" ");

        // Registro el usuario en api.
        // Utilizo el _usuarioGoogle.uid como clave
        await register(_usuarioGoogleFullName[0], _usuarioGoogleFullName[1],
            _usuarioGoogle.email!, _usuarioGoogle.uid);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future googleLogout() async {
    await googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('ingresoConGoogle');
    _ingresoConGoogle = false;
    notifyListeners();
  }
}
