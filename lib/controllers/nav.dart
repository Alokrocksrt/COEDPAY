import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  PageController pageController = PageController();
  int pageIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  handleMenu() {
    if (!scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  changePage(int index) {
    pageIndex = index;
    update();
    pageController.jumpToPage(index);
  }
}
