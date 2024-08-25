import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_spilit/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;

  Future<void> setUserData(
      {required String id,
      required String userName,
      required String userEmail,
      String? phoneNumber}) async {
    final userModel = UserModel(
        userId: id,
        userName: userName,
        userEmail: userEmail,
        phoneNumber: phoneNumber);
    await _fireStore.collection('user').doc(id).set(userModel.toJson());
    notifyListeners();
  }
}
