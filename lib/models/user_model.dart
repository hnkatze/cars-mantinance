import 'package:flutter/material.dart';

class UserModel {
  final String id;
  String name;
  String email;
  String photoUrl;
  TimeOfDay? startNotificationTime;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.startNotificationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'startNotificationTime': startNotificationTime != null
          ? '${startNotificationTime!.hour.toString().padLeft(2, '0')}:${startNotificationTime!.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      startNotificationTime: json['startNotificationTime'] != null
          ? _stringToTimeOfDay(json['startNotificationTime'])
          : null,
    );
  }

  static TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
