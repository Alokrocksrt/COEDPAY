import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/auth.dart';
import 'package:happyadmin/pages/auth/signin.dart';
import 'package:happyadmin/pages/home/home.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final walletRef = FirebaseFirestore.instance.collection('wallet');
final loansRef = FirebaseFirestore.instance.collection('loans');
final contactsRef = FirebaseFirestore.instance.collection('contacts');
final creditsRef = FirebaseFirestore.instance.collection('credits');
final transRef = FirebaseFirestore.instance.collection('transactions');
final notificationsRef = FirebaseFirestore.instance.collection('notifications');
final recentVendorsRef = FirebaseFirestore.instance.collection('recentvendors');
final FirebaseStorage storageRef = FirebaseStorage.instance;

class InitApp extends StatefulWidget {
  @override
  _InitAppState createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(0.seconds, () async {
      if (GetPlatform.isAndroid) {
        await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
      }
    });
    Future.delayed(Duration(seconds: 2), () async {
      await authController.setCurrentUser();
      if (authController.auth.currentUser != null) {
        Get.offAll(() => Home());
      } else {
        Get.offAll(() => SignIn());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
