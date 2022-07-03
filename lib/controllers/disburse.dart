import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';

class DisburseController extends GetxController {
  late DUser user;
  bool isProccesing = false;
  List<String> aadhaarFront = [];
  List<String> aadhaarBack = [];
  List<String> panFront = [];

  fetchUser(String id) async {
    DocumentSnapshot doc = await usersRef.doc(id).get();
    user = DUser.fromDocument(doc);
    List<String> a = [];
    List<String> b = [];
    List<String> c = [];
    a.add(user.aadhaarFront);
    b.add(user.aadhaarBack);
    c.add(user.panFront);
    aadhaarFront = a;
    aadhaarBack = b;
    panFront = c;
    update();
  }

  maskAsDisbursed({required String id}) async {
    isProccesing = true;
    update();
    await loansRef.doc(id).update({
      'disbursed': true,
    });
    Get.snackbar(
      'Success',
      'Successfully marked as disbursed',
      backgroundColor: Colors.greenAccent,
    );
    isProccesing = false;
    update();
  }
}
