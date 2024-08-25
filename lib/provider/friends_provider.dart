import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_spilit/common/helper/helper.dart';
import 'package:we_spilit/model/friend_model.dart';
import 'package:we_spilit/model/group_model.dart';

class FriendsProvider extends ChangeNotifier {
  List<FriendsModel> friends = [];

  Future<void> setFireStoreFriends({
    required String fName,
    required String lName,
    required String fPhoneNumber,
  }) async {
    final fId = DateTime.now().millisecondsSinceEpoch;
    final friendModel = FriendsModel(
      fId: fId.toString(),
      userId: FirebaseAuth.instance.currentUser!.uid,
      fName: fName,
      lName: lName,
      fPhoneNumber: fPhoneNumber,
    );
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(fId.toString())
        .set(friendModel.toJson());
    await getAllFriends();
  }

  Future<void> setFireStoreExpanse({required FriendsModel friendsModel}) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(friendsModel.fId)
        .update(friendsModel.toJson());
    getAllFriends();
    notifyListeners();
  }

  Future<void> getAllFriends() async {
    final getFriends = await FirebaseFirestore.instance
        .collection('friends')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (getFriends.docs.isNotEmpty) {
      final allFriends = getFriends.docs
          .map(
            (e) => FriendsModel.fromJson(e.data()),
          )
          .toList();
      friends = allFriends;
    } else {
      friends = [];
    }
    notifyListeners();
  }

  List<FriendsModel> getFriend() {
    return friends
        .where(
          (element) => element.isFriendsDelete == false,
        )
        .toList();
  }

  List<FriendsModel> getExpense() {
    return getFriendsExpenses()
        .where(
          (element) => element.isExpenseDelete == false,
        )
        .toList();
  }

  FriendsModel? addSearchData(String searchData) {
    final matchingFriends = friends
        .where(
          (element) =>
              joinString(element.fName.trim().toLowerCase(),
                  element.lName.trim().toLowerCase()) ==
              searchData.trim().toLowerCase(),
        )
        .toList();

    if (matchingFriends.isNotEmpty) {
      return matchingFriends.first;
    } else {
      // Handle the case where no match is found
      return null; // or handle it as appropriate for your app
    }
  }

  List<FriendsModel> getFriendsExpenses() {
    final allExpenseFriends = friends
        .where(
          (element) =>
              element.amount != null &&
              element.description != null &&
              element.members != null,
        )
        .toList();
    return allExpenseFriends;
  }

  Future<void> setFirebaseGroupData(GroupModel groupModel) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupModel.groupId)
        .set(groupModel.toJson());
    notifyListeners();
  }

  Stream<List<GroupModel>?> getGroupData() {
    return FirebaseFirestore.instance.collection('groups').snapshots().asyncMap(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs
              .map(
                (e) => GroupModel.fromJson(e.data()),
              )
              .toList();
        }
        return null;
      },
    );
  }

  Future<void> deleteExpense(String id) async {
    await FirebaseFirestore.instance.collection('friends').doc(id).update({
      'isExpenseDelete': true,
    });
    getAllFriends();
    notifyListeners();
  }

  Future<void> deleteFriends(String id) async {
    await FirebaseFirestore.instance.collection('friends').doc(id).update({
      'isFriendsDelete': true,
    });
    getAllFriends();
    notifyListeners();
  }

  Future<void> deleteGroup(String id) async {
    await FirebaseFirestore.instance.collection('groups').doc(id).delete();
    notifyListeners();
  }
}
