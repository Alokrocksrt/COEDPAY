import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/disburse.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/widgets/disburse_confirm_item.dart';

class ConfirmDisbursement extends StatefulWidget {
  final String id;
  final String userId;
  const ConfirmDisbursement({required this.id, required this.userId});

  @override
  _ConfirmDisbursementState createState() => _ConfirmDisbursementState();
}

class _ConfirmDisbursementState extends State<ConfirmDisbursement> {
  final DisburseController disburseController = Get.find();

  confirmDisburse() {
    return FutureBuilder(
      future: loansRef.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        ConfirmDisburseItem con =
            ConfirmDisburseItem.fromDocument(snapshot.data!);
        return con;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '#' + widget.id,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: Get.width,
        child: GetBuilder<DisburseController>(
          builder: (controller) {
            return RaisedButton(
              onPressed: controller.isProccesing
                  ? null
                  : () {
                      controller.maskAsDisbursed(id: widget.id);
                    },
              child: Text(
                controller.isProccesing
                    ? 'Proccessing . . .'
                    : 'Mark as Disbursed',
              ),
              color: Global.mainColor,
              textColor: Colors.white,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: confirmDisburse(),
    );
  }
}
