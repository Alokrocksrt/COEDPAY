import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/controllers/normal.dart';
import 'package:happyadmin/init.dart';
import 'package:get/get.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';
import 'package:lottie/lottie.dart';

class BankTransfers extends StatefulWidget {
  @override
  _BankTransfersState createState() => _BankTransfersState();
}

class _BankTransfersState extends State<BankTransfers> {
  final NormalController normalController = Get.find();

  approveSheet(
      {required String id,
      required String image,
      required String type,
      required String user,
      required double amount}) {
    return Get.bottomSheet(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: Container(
                height: 60,
                width: Get.width,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    normalController.approveTrans(
                        id: id, type: type, user: user, amount: amount);
                  },
                  child: Text('Approve'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Global.mainColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(builder: (controller1) {
      return GetBuilder<NormalController>(
        builder: (controller) {
          return WidgetHUD(
            showHUD: controller.isSubmitting,
            builder: (context) => Scaffold(
              key: controller1.scaffoldKey,
              drawer: SideMenu(),
              appBar: AppBar(
                title: Text(
                  'Bank Transfers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                leading: Responsive.isMobile(context)
                    ? IconButton(
                        onPressed: () {
                          controller1.handleMenu();
                        },
                        icon: Icon(FlutterRemix.menu_2_line),
                      )
                    : Container(),
              ),
              body: StreamBuilder(
                stream: transRef
                    .where('method', isEqualTo: 'bank')
                    .where('status', isEqualTo: 'created')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return snapshot.data!.docs.length <= 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/animations/empty.json'),
                              Text(
                                'No transaction to approve',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Global.mainColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: index.isOdd
                                    ? Global.mainColor.withOpacity(0.1)
                                    : Colors.white,
                                child: ListTile(
                                  onTap: () {
                                    approveSheet(
                                      id: snapshot.data!.docs[index]['id'],
                                      image: snapshot.data!.docs[index]
                                          ['imageUrl'],
                                      type: 'repayment',
                                      user: snapshot.data!.docs[index]
                                          ['userId'],
                                      amount: snapshot.data!.docs[index]
                                          ['repaymentAmount'],
                                    );
                                  },
                                  title: Text(
                                    'Repayment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.docs[index]['id'],
                                    style: TextStyle(),
                                  ),
                                  trailing: Text(
                                    Global.currencySymbol +
                                        snapshot.data!.docs[index]['loanAmount']
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
