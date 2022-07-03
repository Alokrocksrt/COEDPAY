import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/pages/disburse/confirm_disbursement.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';
import 'package:happyadmin/widgets/disburse_item.dart';
import 'package:lottie/lottie.dart';

class Disburse extends StatefulWidget {
  @override
  _DisburseState createState() => _DisburseState();
}

class _DisburseState extends State<Disburse> {
  disburse() {
    return StreamBuilder(
      stream: loansRef.where('disbursed', isEqualTo: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DisburseItem> docList = [];
        snapshot.data!.docs.forEach((doc) {
          docList.add(DisburseItem.fromDocument(doc));
        });
        return docList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Lottie.asset('assets/animations/empty.json'),
                    Text(
                      'No disburse requests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ConfirmDisbursement(
                            id: snapshot.data!.docs[index]['id'],
                            userId: snapshot.data!.docs[index]['userId']),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      color: index.isEven
                          ? Colors.white
                          : Global.mainColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Global.mainColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
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
                              '${Global.currencySymbol}${snapshot.data!.docs[index]['amount'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Global.mainColor,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '#' + snapshot.data!.docs[index]['id'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          drawer: SideMenu(),
          appBar: AppBar(
            title: Text(
              'Disburse',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Global.mainColor,
                fontSize: 25,
              ),
            ),
            leading: Responsive.isMobile(context)
                ? IconButton(
                    onPressed: () {
                      controller.handleMenu();
                    },
                    icon: Icon(FlutterRemix.menu_2_line),
                  )
                : Container(),
          ),
          body: disburse(),
        );
      },
    );
  }
}
