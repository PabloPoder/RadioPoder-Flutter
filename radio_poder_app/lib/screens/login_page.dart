import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthMode { signup, login }

class LoginPage extends StatefulWidget {
  static const route = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                height: 100,
              ),
              const Text(
                'Radio Poder',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              const AuthCard(),
              // Flexible(
              //   flex: deviceSize.width > 600 ? 2 : 1,
              //   child: const AuthCard(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'nombre': '',
    'apellido': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Ha ocurrido un error!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        try {
          await Provider.of<Auth>(context, listen: false).register(
            _authData['nombre']!,
            _authData['apellido']!,
            _authData['email']!,
            _authData['password']!,
          );
          _authMode = AuthMode.login;
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Usuario creado con exito!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        } catch (e) {}
      }
    } catch (error) {
      var errorMessage = error.toString();
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _authMode == AuthMode.signup ? 500 : 300,
      child: Container(
        // height: _authMode == AuthMode.signup ? 400 : 320,
        // constraints:
        //     BoxConstraints(minHeight: _authMode == AuthMode.signup ? 400 : 320),
        width: deviceSize.width * 0.85,
        padding: const EdgeInsets.only(top: 8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.orangeAccent,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                      hintText: "E-mail",
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Email invalido!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.orangeAccent,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password),
                      hintText: "Contraseña",
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'La contraseña es demasiado corta!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (_authMode == AuthMode.signup)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.orangeAccent,
                          textInputAction: TextInputAction.next,
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.password),
                            hintText: "Confirmar Contraseña",
                          ),
                          obscureText: true,
                          validator: _authMode == AuthMode.signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Las contraseñas no coinciden!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.orangeAccent,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            hintText: "Nombre",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nombre invalido!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['nombre'] = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.orangeAccent,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person),
                            hintText: "Apellido",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Apellido invalido!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['apellido'] = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    color: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_authMode == AuthMode.login
                        ? 'Ingresar'
                        : 'Registrarse'),
                    onPressed: _submit,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8.0),
                    textColor: Colors.white,
                  ),
                const SizedBox(height: 5),
                FlatButton(
                  child: Text(
                    _authMode == AuthMode.login
                        ? 'No tienes cuenta? Crea una ahora!'
                        : 'Ingresar con tu cuenta!',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
