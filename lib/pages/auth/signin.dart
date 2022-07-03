import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:get/get.dart';
import 'package:happyadmin/controllers/auth.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/widgets/button.dart';

// TODO: Improve signin flow

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return WidgetHUD(
          showHUD: controller.isChecking,
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: Container(
                height: 600,
                width: 500,
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 4,
                          ),
                          child: Text(
                            'Signin manage customers, transfers and all.',
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'MontMed',
                            ),
                            hintText: 'example@email.com',
                            hintStyle: TextStyle(
                              fontFamily: 'MontMed',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'MontMed',
                            ),
                            hintText: '●●●●●●●●',
                            hintStyle: TextStyle(
                              fontFamily: 'MontMed',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        fullButton(
                          title: controller.isChecking ? 'Logging in' : 'Login',
                          onPressed: controller.isChecking
                              ? () => null
                              : () {
                                  controller.signIn(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                },
                          color: Global.mainColor,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
