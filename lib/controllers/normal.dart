import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:happyadmin/deserialize/wallet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:happyadmin/init.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class NormalController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isSubmitting = false;

  // Future<bool> getNotificationAvailablity() async {
  //   QuerySnapshot qs = await notificationsRef
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('notification')
  //       .get();
  //   List<bool> boolList = [];
  //   qs.docs.forEach((doc) {
  //     print('Hello notification: ${doc["read"]}');
  //     boolList.add(doc['read']);
  //   });
  //   if (boolList.contains(false)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // getIOSPermission() {
  //   _firebaseMessaging.requestPermission();
  // }

  // configPushNotfication() async {
  //   final User user = FirebaseAuth.instance.currentUser!;
  //   if (Platform.isIOS) getIOSPermission();
  //   _firebaseMessaging.getToken().then((token) {
  //     usersRef.doc(user.uid).update({"deviceToken": token});
  //   });
  // }

  approveMulti({required List<String> ids, required double amount}) async {
    isSubmitting = true;
    update();
    try {
      for (int i = 0; i < ids.length; i++) {
        await usersRef.doc(ids[i]).update({
          'underVerification': false,
          'verified': true,
        });
        await walletRef.doc(ids[i]).update({
          'limit': amount,
        });
        Get.snackbar(
          'Success',
          'Successfully activated the users',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isSubmitting = false;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error occured! Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isSubmitting = false;
      update();
    }
  }

  rejectMulti({required List<String> ids}) async {
    isSubmitting = true;
    update();
    try {
      for (int i = 0; i < ids.length; i++) {
        await usersRef.doc(ids[i]).update({
          'underVerification': false,
          'verified': false,
          'rejected': true,
        });
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot doc = await transaction.get(walletRef.doc(ids[i]));
          transaction.update(walletRef.doc(ids[i]), {
            'limit': 0,
          });
        });
        Get.snackbar(
          'Success',
          'Successfully rejected the users',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isSubmitting = false;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error occured! Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isSubmitting = false;
      update();
    }
  }

  activateUser(String id, String amount) async {
    isSubmitting = true;
    update();
    await usersRef.doc(id).update({
      'underVerification': false,
      'verified': true,
    });
    await walletRef.doc(id).update({
      'limit': double.parse(amount),
      'used': 0,
    });
    Get.back();
    Get.snackbar(
      'Success',
      'Successfully activated the user',
      backgroundColor: Colors.greenAccent,
    );
    isSubmitting = false;
    update();
  }

  rejectUser(String id) async {
    isSubmitting = true;
    update();
    try {
      await usersRef.doc(id).update({
        'underVerification': false,
        'verified': false,
        'rejected': true,
      });
      await walletRef.doc(id).update({
        'limit': 0,
        'used': 0,
      });
      Get.back();
      Get.snackbar(
        'Success',
        'Successfully rejected the user',
        backgroundColor: Colors.greenAccent,
      );
      isSubmitting = false;
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something happened! Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isSubmitting = true;
      update();
    }
  }

  approveTrans(
      {required String id,
      required String type,
      required String user,
      required double amount}) async {
    isSubmitting = true;
    update();
    try {
      await transRef.doc(id).update({'status': 'approved'});
      if (type == 'payback') {
        DocumentSnapshot doc = await walletRef.doc(user).get();
        Wallet wallet = Wallet.fromDocument(doc);
        await walletRef.doc(user).update({
          'limit': wallet.limit + amount,
          'used': (wallet.used - amount) <= 0 ? 0 : (wallet.used - amount),
        });
      }
      isSubmitting = false;
      update();
      Get.snackbar(
        'Success',
        'Approval of the transaction is successfull.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print(e);
      isSubmitting = false;
      update();
      Get.snackbar(
        'Failed',
        'Approval of the transaction is failed.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  approveAll() async {
    isSubmitting = true;
    update();
    try {
      QuerySnapshot qs = await usersRef.get();
      for (int i = 0; i < qs.docs.length; i++) {
        await usersRef.doc(qs.docs[i]['id']).update({
          'underVerification': false,
          'verified': true,
          'verifiedAt': Timestamp.now(),
        });
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot doc =
              await transaction.get(walletRef.doc(qs.docs[i]['id']));
          transaction.update(walletRef.doc(qs.docs[i]['id']), {
            'limit': doc['requested'],
          });
        });
      }
      isSubmitting = false;
      update();
      Get.snackbar(
        'Success',
        'Yay! Approved all the users.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      isSubmitting = false;
      update();
      Get.snackbar(
        'Error',
        'Unknown error occured! Please  try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
