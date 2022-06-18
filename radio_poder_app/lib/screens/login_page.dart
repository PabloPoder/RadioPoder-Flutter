import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class LoginPage extends StatelessWidget {
  static const route = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "HeadphonesLogo",
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                ),
              ),
              const Text(
                'Bienvenido!',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Radio Poder',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: const AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final Map<String, String> _authDataRegister = {
    'nombre': '',
    'apellido': '',
    'email': '',
    'password': '',
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
                FlatButton(
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
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).register(
          _authData['nombre']!,
          _authData['apellido']!,
          _authData['email']!,
          _authData['password']!,
        );
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
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: _authMode == AuthMode.Signup ? 400 : 320,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 400 : 320),
      width: deviceSize.width * 0.85,
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: TextFormField(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: TextFormField(
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
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_authMode == AuthMode.Signup)
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
                        textInputAction: TextInputAction.next,
                        enabled: _authMode == AuthMode.Signup,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.password),
                          hintText: "Confirmar Contraseña",
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Las contraseñas no coinciden!';
                                }
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
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        enabled: _authMode == AuthMode.Signup,
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
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        enabled: _authMode == AuthMode.Signup,
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
                  child: Text(
                      _authMode == AuthMode.Login ? 'Ingresar' : 'Registrarse'),
                  onPressed: _submit,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  textColor: Colors.white,
                ),
              SizedBox(height: 5),
              FlatButton(
                child: Text(
                  _authMode == AuthMode.Login
                      ? 'No tienes cuenta? Crea una ahora!'
                      : 'Ingresar con tu cuenta!',
                  textAlign: TextAlign.center,
                ),
                onPressed: _switchAuthMode,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
