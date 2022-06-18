import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_poder_app/providers/auth.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
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
            ));
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState!.save();

    try {
      await Provider.of<Auth>(context, listen: false).editarUsuario(
        _editData['nombre']!,
        _editData['apellido']!,
        _editData['password']!,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  _showEditModal(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Editar Perfil',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Nombre',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Nombre invalido!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editData['nombre'] = value!;
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Apellido',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Apellido invalido!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editData['apellido'] = value!;
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Contraseña',
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Contraseña invalida!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editData['password'] = value!;
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Confirmar contraseña',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('Guardar',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: _submit,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Auth>(context, listen: false).usuarioLogeado(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapshot.error != null) {
          //TODO:
          // var usuario = Provider.of<Auth>(context, listen: false).usuario;
          // return usuario == null ? : ;
          //
          // Mostrar el ultimo dato guardado en usuaurio en caso de que la api no este funcionando?
          // Es bueno para la optimizacion de la app?

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Ups! Ha ocurrido un error.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Vuelve a intertarlo más tarde.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        } else {
          return Consumer<Auth>(
            builder: (ctx, auth, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  child: Text(
                                    auth.usuario!.nombre.substring(0, 1) +
                                        auth.usuario!.apellido.substring(0, 1),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors.pinkAccent,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  auth.usuario!.nombre +
                                      " " +
                                      auth.usuario!.apellido,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(auth.usuario!.email),
                                const SizedBox(height: 16),
                                RaisedButton(
                                  color: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Editar Perfil'),
                                  onPressed: () => _showEditModal(context),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 8.0),
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const _MyCard(
                          titulo: "Torneos Ganados:",
                          data: 10,
                          icon: Icons.stars_rounded),
                      const _MyCard(
                          titulo: "Participaciones activas:",
                          data: 5,
                          icon: Icons.view_list_rounded),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _MyCard extends StatelessWidget {
  final String titulo;
  final int data;
  final IconData icon;

  const _MyCard(
      {Key? key, required this.titulo, required this.data, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.orangeAccent),
              Text(
                titulo,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                data.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}