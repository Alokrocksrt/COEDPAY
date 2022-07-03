import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/controllers/normal.dart';
import 'package:happyadmin/pages/banktransfers/banktransfers.dart';
import 'package:happyadmin/pages/customers/all-customers.dart';
import 'package:happyadmin/pages/customers/customers.dart';
import 'package:happyadmin/pages/dashboard/dashboard.dart';
import 'package:happyadmin/pages/disburse/disburse.dart';
import 'package:happyadmin/pages/menu/menu.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NormalController normalController = Get.find();
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 15,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Expanded(
      //         child: IconButton(
      //           icon: Icon(
      //             Feather.home,
      //             color: pageIndex == 0 ? Global.mainColor : Colors.black87,
      //           ),
      //           onPressed: () => pageController.jumpToPage(0),
      //         ),
      //       ),
      //       Expanded(
      //         child: IconButton(
      //           icon: Icon(
      //             Feather.triangle,
      //             color: pageIndex == 1 ? Global.mainColor : Colors.black87,
      //           ),
      //           onPressed: () => pageController.jumpToPage(1),
      //         ),
      //       ),
      //       Expanded(
      //         child: IconButton(
      //           icon: Icon(
      //             Feather.user,
      //             color: pageIndex == 2 ? Global.mainColor : Colors.black87,
      //           ),
      //           onPressed: () => pageController.jumpToPage(2),
      //         ),
      //       ),
      //       Expanded(
      //         child: IconButton(
      //           icon: Icon(
      //             Feather.menu,
      //             color: pageIndex == 3 ? Global.mainColor : Colors.black87,
      //           ),
      //           onPressed: () => pageController.jumpToPage(3),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) Expanded(child: SideMenu()),
          Expanded(
            flex: 5,
            child: GetBuilder<NavController>(
              builder: (controller) {
                return PageView(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Dashboard(),
                    Disburse(),
                    Customers(),
                    BankTransfers(),
                    AllCustomers(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
