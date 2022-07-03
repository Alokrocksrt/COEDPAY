import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/deserialize/admin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:happyadmin/controllers/normal.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class AuthController extends GetxController {
  final NormalController normalController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  String postID = Uuid().v4();
  bool isChecking = false;
  late AdminModel currentUser;

  bool get isAuth => auth.currentUser != null;

  @override
  void onInit() {
    super.onInit();
  }

  Future<File> compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    Im.Image? decodeImage = Im.decodeImage(image.readAsBytesSync());
    final compressedImage = File('$path/$postID.jpg')
      ..writeAsBytesSync(
        Im.encodeJpg(decodeImage!, quality: 85),
      );
    return compressedImage;
  }

  Future<String> uploadImage(imageFile) async {
    await storageRef.ref("$postID").putFile(imageFile);
    String imageURL = await storageRef.ref("$postID").getDownloadURL();
    return imageURL;
  }

  void createAccount(
      {required String email,
      required String password,
      required String name,
      required username}) async {
    isChecking = true;
    update();
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.credential != null) {
        await auth.signInWithCredential(userCredential.credential!);
      }
      if (auth.currentUser != null) {
        await auth.currentUser!.sendEmailVerification();
        await usersRef.doc(auth.currentUser!.uid).set({
          'id': auth.currentUser!.uid,
          'pan': '',
          'name': name,
          'email': email,
          'phone': '',
          'username': username,
          'bio': '',
          'photoUrl':
              'https://firebasestorage.googleapis.com/v0/b/tagore-1c45b.appspot.com/o/defaults%2Favatar.png?alt=media&token=237d43f8-1bed-4b38-85c2-97d7a52a3758',
          'verified': false,
          'underVerification': false,
        });

        await auth.currentUser!.updateDisplayName(name);
        await auth.currentUser!.updatePhotoURL(
            'https://firebasestorage.googleapis.com/v0/b/tagore-1c45b.appspot.com/o/defaults%2Favatar.png?alt=media&token=237d43f8-1bed-4b38-85c2-97d7a52a3758');

        await walletRef
            .doc(auth.currentUser!.uid)
            .set({'used': 0, 'limit': 500});
        Get.snackbar(
          'Success',
          'Account created successfully!',
          backgroundColor: Colors.grey,
        );
        Future.delayed(Duration(seconds: 1), () {
          Get.offAll(InitApp());
        });
      }
      isChecking = false;
      update();
    } on FirebaseAuthException catch (e) {
      isChecking = false;
      update();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.snackbar(
          'Error',
          'The password provided is too weak.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.snackbar(
          'Error',
          'The account already exists for that email.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isChecking = false;
      update();
      print(e);
    }
  }

  signIn({required String email, required String password}) async {
    isChecking = true;
    update();
    print('aa');
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        Get.offAll(() => InitApp());
      }
      isChecking = false;
      update();
    } on FirebaseAuthException catch (e) {
      isChecking = false;
      update();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar(
          'Error',
          'No user found for that email.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar(
          'Error',
          'Wrong password provided for that user.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        print(e);
        Get.snackbar(
          'Error',
          'Something happened.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    await auth.signOut();
    Get.offAll(InitApp());
  }

  Future<bool> checkUser({required User user}) async {
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();
    return doc.exists;
  }

  Future<bool> checkEmailVerified() async {
    await auth.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future setCurrentUser() async {
    if (auth.currentUser != null) {
      final User user = auth.currentUser!;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(user.uid)
          .get();

      currentUser = AdminModel.fromDocument(doc);
      update();
      print(currentUser);
      print(currentUser.name);
    }
  }
}
