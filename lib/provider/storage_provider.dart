import 'package:equipo5/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class StorageProvider with ChangeNotifier {
  String? _name;
  String? _photoUrl;
  String? _email;
  TimeOfDay? _startNotificationTime;
  final UserService _userService = UserService();

  String? get name => _name;
  String? get photoUrl => _photoUrl;
  String? get email => _email;
  TimeOfDay? get startNotificationTime => _startNotificationTime;
  void setNameAndUrl(String name, String photoUrl, String email) {
    _name = name;
    _photoUrl = photoUrl;
    _email = email;

    notifyListeners();
  }

  void setStartNotificationTime(TimeOfDay time) {
    _startNotificationTime = time;
    notifyListeners();
  }

  Future<void> saveUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String name = user.displayName ?? 'No Name';
      String photoUrl = user.photoURL ?? 'No Photo';
      String email = user.email ?? 'No Email';
      TimeOfDay _startNotificationTime = TimeOfDay.now();

      UserModel userModel = UserModel(
        id: userId,
        name: name,
        email: email,
        photoUrl: photoUrl,
        startNotificationTime: _startNotificationTime,
      );

      // Intenta obtener el usuario por correo electrónico
      UserModel? existingUser = await _userService.getUser();
      if (existingUser != null) {
        setNameAndUrl(
            existingUser.name, existingUser.photoUrl, existingUser.email);
        // Si el usuario ya existe, actualiza la hora de notificación y si la hora de notificación es nula, establece la hora de notificación en 9:00 a.m.
        if (existingUser.startNotificationTime == null) {
          await _userService.upsertUser(userModel);
        }
      } else {
        // Si el usuario no existe, agrégalo
        await _userService.upsertUser(userModel);
      }

      setNameAndUrl(name, photoUrl, email);
      notifyListeners();
    }
  }

  Future<void> clearData() async {
    _name = null;
    _photoUrl = null;
    _email = null;
    notifyListeners();
  }
}
