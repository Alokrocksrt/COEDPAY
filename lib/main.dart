import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/binding/binding.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/shared/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Coed Pay Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Global.mainColor,
        accentColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: InitApp(),
      initialBinding: InitBinding(),
    );
  }
}
