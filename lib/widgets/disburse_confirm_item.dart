import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/disburse.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/shared/global.dart';

class ConfirmDisburseItem extends StatelessWidget {
  final String id;
  final String userId;
  final double amount;
  final int rate;
  final int tenure;
  final int proccessingFee;
  final bool disbursed;
  final bool repaid;
  final double repayment;
  final Timestamp repaymentDate;
  final Timestamp timestamp;

  ConfirmDisburseItem({
    required this.id,
    required this.userId,
    required this.amount,
    required this.rate,
    required this.tenure,
    required this.proccessingFee,
    required this.disbursed,
    required this.repaid,
    required this.repayment,
    required this.repaymentDate,
    required this.timestamp,
  });

  factory ConfirmDisburseItem.fromDocument(DocumentSnapshot doc) {
    return ConfirmDisburseItem(
      id: doc['id'],
      userId: doc['userId'],
      amount: doc['amount'].toDouble(),
      rate: doc['rate'],
      tenure: doc['tenure'],
      proccessingFee: doc['proccessingFee'],
      disbursed: doc['disbursed'],
      repaid: doc['repaid'],
      repayment: doc['repayment'].toDouble(),
      repaymentDate: doc['repaymentDate'],
      timestamp: doc['timestamp'],
    );
  }

  final DisburseController controller = Get.find();

  getUser() async {
    await controller.fetchUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Column(
      children: [
        ListTile(
          title: Text(
            'ID:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            '#' + id,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Amount:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            '${Global.currencySymbol}$amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
        ),
        GetBuilder<DisburseController>(
          builder: (controller) {
            return ListTile(
              title: Text(
                'Name:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                controller.user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        GetBuilder<DisburseController>(
          builder: (controller) {
            return ListTile(
              title: Text(
                'Bank:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                controller.user.bankName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        GetBuilder<DisburseController>(
          builder: (controller) {
            return ListTile(
              title: Text(
                'IFSC:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                controller.user.ifsc,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        GetBuilder<DisburseController>(
          builder: (controller) {
            return ListTile(
              title: Text(
                'Account Number:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                controller.user.accountNumber,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
