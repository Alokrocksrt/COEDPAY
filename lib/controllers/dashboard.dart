import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/auth.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';

class DashboardController extends GetxController {
  final AuthController authController = Get.find();
  List<dynamic> dashList = [];

  getLoanUsers() async {
    QuerySnapshot qs = await loansRef.get();
    List<DocumentSnapshot> userList = [];
    qs.docs.forEach((doc) {
      userList.add(doc);
    });
    return userList;
  }

  Future<List<DocumentSnapshot>> getLoans() async {
    QuerySnapshot qs = await loansRef.get();
    List<DocumentSnapshot> docList = qs.docs.map((doc) => doc).toList();
    return docList;
  }

  fetchCounts() async {
    // Get user count
    QuerySnapshot qs = await usersRef.get();
    int userCount = qs.docs.length > 0
        ? qs.docs.length
        : qs.docs.length == null || qs.docs.length < 0
            ? 0
            : 0;

    // Get total loan count
    List<DocumentSnapshot> loanList = [];
    List<DocumentSnapshot> docList = await getLoans();
    for (DocumentSnapshot doc in docList) {
      loanList.add(doc);
    }

    int disbursedCount =
        loanList.where((doc) => doc['disbursed'] == true).toList().length;

    int repaidCount =
        loanList.where((doc) => doc['repaid'] == true).toList().length;

    List<dynamic> h = [];

    h.add({
      'icon': Feather.user,
      'text': 'Customers',
      'count': userCount,
    });
    h.add({
      'icon': Feather.anchor,
      'text': 'Loans',
      'count': loanList.length,
    });
    h.add({
      'icon': Feather.arrow_up_right,
      'text': 'Disbursed',
      'count': disbursedCount,
    });
    h.add({
      'icon': Feather.arrow_down_left,
      'text': 'Repaid',
      'count': repaidCount,
    });
    dashList = h;
    update();
  }
}
