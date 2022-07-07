import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarPerfilPage extends StatefulWidget {
  static const route = "/editar_perfil";

  const EditarPerfilPage({Key? key}) : super(key: key);

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Auth>(context, listen: false).usuario;
    final ingresoConGoogle =
        Provider.of<Auth>(context, listen: false).ingresoConGoogle;

    final GlobalKey<FormState> _formKey = GlobalKey();

    final Map<String, String> _editData = {
      'nombre': '',
      'apellido': '',
      'password': '',
    };

    final TextEditingController _passwordController = TextEditingController();

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
        ),
      );
    }

    Future<void> _submit() async {
      FocusManager.instance.primaryFocus?.unfocus();

      if (!_formKey.currentState!.validate()) {
        // Invalid!
        return;
      }

      _formKey.currentState!.save();

      try {
        ingresoConGoogle
            ? await Provider.of<Auth>(context, listen: false)
                .editarUsuarioGoogle(
                _editData['nombre']!,
                _editData['apellido']!,
              )
            : await Provider.of<Auth>(context, listen: false).editarUsuario(
                _editData['nombre']!,
                _editData['apellido']!,
                _editData['password']!,
              );
        Navigator.of(context).pop();
      } catch (e) {
        _showErrorDialog(e.toString());
      }

      _formKey.currentState!.reset();
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'E D I T A R   P E R F I L',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.orangeAccent,
                        textInputAction: TextInputAction.next,
                        initialValue: usuario!.nombre,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nombre',
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Nombre inválido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editData['nombre'] = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.orangeAccent,
                        textInputAction: TextInputAction.next,
                        initialValue: usuario.apellido,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Apellido',
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Apellido inválido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editData['apellido'] = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ingresoConGoogle
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: Colors.orangeAccent,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contraseña',
                              ),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Contraseña inválida';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editData['password'] = value!;
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    ingresoConGoogle
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: Colors.orangeAccent,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirmar contraseña',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Las contraseñas no coinciden';
                                }
                                return null;
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Guardar'),
                      onPressed: _submit,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
