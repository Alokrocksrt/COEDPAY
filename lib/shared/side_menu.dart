import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/nav.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: GetBuilder<NavController>(
          builder: (controller) {
            return ListView(
              children: [
                DrawerHeader(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/coed-pay.appspot.com/o/logo.png?alt=media&token=8fd241b7-f91b-4bc0-a386-be831e64c67d',
                  ),
                ),
                SizedBox(height: 50),
                DrawerListTile(
                  title: "Dashbord",
                  icon: FlutterRemix.dashboard_2_line,
                  press: () {
                    if (GetPlatform.isMobile) {
                      Get.back();
                    }
                    controller.changePage(0);
                  },
                ),
                DrawerListTile(
                  title: "Disburse",
                  icon: FlutterRemix.send_plane_2_line,
                  press: () {
                    if (GetPlatform.isMobile) {
                      Get.back();
                    }
                    controller.changePage(1);
                  },
                ),
                DrawerListTile(
                  title: "Activate Customers",
                  icon: FlutterRemix.user_smile_line,
                  press: () {
                    if (GetPlatform.isMobile) {
                      Get.back();
                    }
                    controller.changePage(2);
                  },
                ),
                DrawerListTile(
                  title: "Bank Transfers",
                  icon: FlutterRemix.copper_coin_line,
                  press: () {
                    if (GetPlatform.isMobile) {
                      Get.back();
                    }
                    controller.changePage(3);
                  },
                ),
                DrawerListTile(
                  title: "All Customers",
                  icon: FlutterRemix.user_6_line,
                  press: () {
                    if (GetPlatform.isMobile) {
                      Get.back();
                    }
                    controller.changePage(4);
                  },
                ),
                // DrawerListTile(
                //   title: "Documents",
                //   svgSrc: "assets/icons/menu_doc.svg",
                //   press: () {},
                // ),
                // DrawerListTile(
                //   title: "Store",
                //   svgSrc: "assets/icons/menu_store.svg",
                //   press: () {},
                // ),
                // DrawerListTile(
                //   title: "Notification",
                //   svgSrc: "assets/icons/menu_notification.svg",
                //   press: () {},
                // ),
                // DrawerListTile(
                //   title: "Profile",
                //   svgSrc: "assets/icons/menu_profile.svg",
                //   press: () {},
                // ),
                // DrawerListTile(
                //   title: "Settings",
                //   svgSrc: "assets/icons/menu_setting.svg",
                //   press: () {},
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Colors.grey.shade400,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.grey.shade200),
      ),
    );
  }
}
