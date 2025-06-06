import 'package:equipo5/services/auth_service.dart';
import 'package:equipo5/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/multi_componentes.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../provider/storage_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserService userService = UserService();
  final AuthService auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  UserModel? _user;
  String _name = '';
  String _imageUrl = '';
  TimeOfDay _startNotificationTime = TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      UserModel? user = await userService.getUser();
      if (user != null) {
        setState(() {
          _user = user;
          _name = user.name;
          _imageUrl = user.photoUrl;
        });
      }
    } catch (error) {
      throw Exception("Error loading user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
    if (storageProvider.startNotificationTime != null) {
      _startNotificationTime = storageProvider.startNotificationTime!;
    }
    return Scaffold(
      appBar: const AppBarMenuOthers(title: "Configuraciones"),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/icons/settings_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ajusta tus preferencias y configuraciones aquí.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  // Manejo de cuenta
                  ExpansionTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Cuenta'),
                    subtitle: const Text('Manejo de tu cuenta'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Nombre'),
                                initialValue: _name,
                                onSaved: (value) => _name = value!,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'URL de la imagen'),
                                initialValue: _imageUrl,
                                onSaved: (value) => {
                                  _imageUrl = value!,
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    storageProvider.setNameAndUrl(_name,
                                        _imageUrl, storageProvider.email!);
                                    _updateUserData();
                                  }
                                },
                                child: const Text('Guardar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Notificaciones
                  ExpansionTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificación'),
                    subtitle: const Text('Manejo de configuraciones'),
                    children: [
                      ListTile(
                        title: const Text('Horario de Notificación'),
                        subtitle: Text(
                            'Desde ${_startNotificationTime.format(context)}'),
                        onTap: () {
                          _selectTimeRange(context);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar Sesión'),
                    onTap: () {
                      storageProvider.clearData();
                      auth.signOut(context);
                      context.pushNamed('loginPage');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTimeRange(BuildContext context) async {
    final storageProvider =
        Provider.of<StorageProvider>(context, listen: false);
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: _startNotificationTime,
    );
    if (startTime != null && startTime != _startNotificationTime) {
      setState(() {
        _startNotificationTime = startTime;
        storageProvider.setStartNotificationTime(_startNotificationTime);
        userService.updateNotificationTime(_startNotificationTime);
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_user != null) {
      _user!.name = _name;
      _user!.photoUrl = _imageUrl;

      try {
        await userService.updateUser(_user!);
        // Puedes mostrar un mensaje de éxito o hacer otra acción
      } catch (error) {
        throw Exception("Error updating user data: $error");
      }
    }
  }
}
