import 'dart:async';

import 'package:emotions/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void>createUser(String uid, User user) async {
    await _databaseReference.child('usersData').child(uid).set(user.toMap());
  }

  Future<User?>getUser(String uid) async {
    try {
      final snapshot = await _databaseReference.child('usersData').child(uid).get();
      if (snapshot.exists) {
        return User(
          createdAt: DateTime.parse(snapshot.child('createdAt').value.toString()),
          email: snapshot.child('email').value.toString(),
          linkedPartnerId: snapshot.child('linkedPartnerId').value.toString(),
          currentMood: snapshot.child('currentMood').value.toString(),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void>updateUserMood(String uid, String newMood) async {
    await _databaseReference.child('usersData').child(uid).update({
      'currentMood': newMood,
    });
  }

  Stream<String>getUserMood(String uid) {
    return _databaseReference.child('usersData').child(uid).child('currentMood')
      .onValue
      .map((event) => event.snapshot.value?.toString() ?? 'normal');
  }

  Future<bool>getUserPartner(String uid) async {
    try {
      final snapshot = await _databaseReference.child('usersData').child(uid).child('linkedPartnerId').get();

      if (snapshot.value == '') {
        return false;
      }

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getUserPartnerUid(String uid) async {
    try {
      final snapshot = await _databaseReference.child('usersData').child(uid).child('linkedPartnerId')
        .get();

        if (snapshot.value == '') {
          return '';
        }
      return snapshot.value.toString();
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<String> watchPartnerMood(String partnerUid) {
    print(partnerUid);
    return _databaseReference
        .child('usersData').child(partnerUid).child('currentMood')
        .onValue
        .map((event) {
          final mood = event.snapshot.value;
          return mood?.toString() ?? 'normal';
        })
        .handleError((error, stack) {
          return 'Error';
        });
  }

  Future<void>linkPartner(String uid, String partnerUid) async {
    try {
      final partnerRef = await _databaseReference.child('usersData').child(partnerUid).child('linkedPartnerId').get();

      if (partnerRef.exists && partnerRef.value == '') {
        final userRef = await _databaseReference.child('usersData').child(uid).child('linkedPartnerId').get();
        if (userRef.value == '') {
          await _databaseReference.child('usersData').child(uid).update({
            'linkedPartnerId': partnerUid,
          });
          await _databaseReference.child('usersData').child(partnerUid).update({
            'linkedPartnerId': uid,
          });
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void>unlinkPartner(String uid, String partnerUid) async {
    try {
      //final partnerRef = await _databaseReference.child('usersData').child(partnerUid).child('linkedPartnerId').get();
        await _databaseReference.child('usersData').child(uid).update({
          'linkedPartnerId': '',
        });
        await _databaseReference.child('usersData').child(partnerUid).update({
          'linkedPartnerId': '',
        });
    } catch (e) {
      throw Exception(e);
    }
  }
}