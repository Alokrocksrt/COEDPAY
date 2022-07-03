import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';
import 'package:lottie/lottie.dart';
import 'package:happyadmin/controllers/dashboard.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/widgets/latest_user_item.dart';
import 'package:happyadmin/widgets/shimmer.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController dashboardController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(0.seconds, () async {
      await dashboardController.fetchCounts();
    });
  }

  latestCustomers() {
    return StreamBuilder(
      stream:
          usersRef.limit(20).orderBy('timestamp', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return latestUserShimmer();
        }
        List<LatestUserItem> userList = [];

        snapshot.data!.docs.forEach((doc) {
          userList.add(LatestUserItem.fromDocument(doc));
        });
        return userList.isEmpty
            ? Container(
                width: Get.width,
                height: 160,
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/animations/empty.json',
                        height: 150,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 35),
                child: Container(
                  height: 200,
                  child: Row(children: userList),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(builder: (controller) {
      return Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          leading: Responsive.isMobile(context)
              ? IconButton(
                  onPressed: () {
                    controller.handleMenu();
                  },
                  icon: Icon(FlutterRemix.menu_2_line),
                )
              : Container(),
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Global.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        drawer: SideMenu(),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Just\nRegistered',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: latestCustomers(),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: GetBuilder<DashboardController>(
                builder: (controller) {
                  return IgnorePointer(
                    child: GridView.builder(
                      shrinkWrap: true,
                      primary: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250),
                      itemCount: controller.dashList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          shadowColor: Colors.black26,
                          color: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 5,
                                  color: Colors.transparent,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 20,
                                    child: Icon(
                                      controller.dashList[index]['icon'],
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.dashList[index]['text'],
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  controller.dashList[index]['count']
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    });
  }
}
