import 'package:get/get.dart';
import 'package:happyadmin/controllers/auth.dart';
import 'package:happyadmin/controllers/dashboard.dart';
import 'package:happyadmin/controllers/disburse.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/controllers/normal.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NormalController());
    Get.put(NavController());
    Get.put(AuthController());
    Get.put(DashboardController());
    Get.put(DisburseController());
  }
}
