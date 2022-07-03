import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/pages/disburse/confirm_disbursement.dart';
import 'package:happyadmin/shared/global.dart';

class DisburseItem extends StatelessWidget {
  final String id;
  final double amount;
  final String userId;

  const DisburseItem(
      {required this.amount, required this.id, required this.userId});

  factory DisburseItem.fromDocument(DocumentSnapshot doc) {
    return DisburseItem(
      id: doc['id'],
      amount: doc['amount'].toDouble(),
      userId: doc['userId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   onTap: () {
    //     Get.to(() => ConfirmDisbursement(id: id, userId: userId));
    //   },
    //   leading: CircleAvatar(
    //     backgroundColor: Global.mainColor,
    //     radius: 30,
    //     child: Text(
    //       '#',
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   title: Text(
    //     '${Global.currencySymbol}$amount',
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       color: Global.mainColor,
    //     ),
    //   ),
    //   subtitle: Text(
    //     '#' + id,
    //   ),
    // );
    return GestureDetector(
      onTap: () {
        Get.to(() => ConfirmDisbursement(id: id, userId: userId));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Global.mainColor,
                child: Text(
                  '#',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${Global.currencySymbol}$amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Global.mainColor,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '#' + id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
