import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  // https://localhost:7283/api/Usuarios/Login?email=admin&password=admin

  Future<void> registrarse(String email, String password) async {}

  Future<void> login(String email, String password) async {
    const url = "https://192.168.1.106:45455/api/Usuarios/Login";

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    final response = await http.post(Uri.parse(url),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
        }));

    print(response.body);
  }
}
