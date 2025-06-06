import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> upsertUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (error) {
      throw Exception("Error creating/updating user: $error");
    }
  }

  Future<UserModel?> getUser() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          final res = UserModel.fromJson(doc.data() as Map<String, dynamic>);
          return res;
        } else {
          return null;
        }
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error fetching user data: $error");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (error) {
      throw Exception("Error updating user data: $error");
    }
  }

  Future<void> deleteUser() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).delete();
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error deleting user data: $error");
    }
  }

  Future<void> updateNotificationTime(TimeOfDay time) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'startNotificationTime': timeOfDayToString(time),
        });
      } else {
        throw Exception("User not authenticated");
      }
    } catch (error) {
      throw Exception("Error updating user notification time: $error");
    }
  }
}

String timeOfDayToString(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
