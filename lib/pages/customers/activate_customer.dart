import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:get/get.dart';
// import 'package:lightbox/lightbox.dart';
// import 'package:lightbox/lightbox_route.dart';
import 'package:happyadmin/controllers/disburse.dart';
import 'package:happyadmin/controllers/normal.dart';
import 'package:happyadmin/deserialize/wallet.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/shared/global.dart';

class ActivateCustomer extends StatefulWidget {
  final String id;

  const ActivateCustomer({required this.id});
  @override
  _ActivateCustomerState createState() => _ActivateCustomerState();
}

class _ActivateCustomerState extends State<ActivateCustomer> {
  final DisburseController disburseController = Get.find();
  final NormalController normalController = Get.find();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(0.seconds, () async {
      await disburseController.fetchUser(widget.id);
    });
  }

  amountSheet() {
    return Get.bottomSheet(
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: Container(
                height: 60,
                width: Get.width,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    normalController.activateUser(
                        widget.id, amountController.text);
                  },
                  child: Text('Approve Amount'),
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
    return GetBuilder<NormalController>(
      builder: (controller) {
        return WidgetHUD(
          showHUD: controller.isSubmitting,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: GetBuilder<DisburseController>(
                builder: (controller) {
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            controller.user.photoUrl),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        controller.user.name,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: Row(
              children: [
                Expanded(
                  child: Container(
                    width: Get.width,
                    height: 60,
                    child: GetBuilder<NormalController>(
                      builder: (controller) {
                        return FlatButton(
                          onPressed: controller.isSubmitting
                              ? null
                              : () {
                                  amountSheet();
                                  // controller.activateUser(widget.id);
                                },
                          child: Text(
                            controller.isSubmitting
                                ? 'Proccessing . . .'
                                : 'Activate',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Global.mainColor,
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: Get.width,
                    height: 60,
                    child: GetBuilder<NormalController>(
                      builder: (controller) {
                        return FlatButton(
                          onPressed: controller.isSubmitting
                              ? null
                              : () {
                                  controller.rejectUser(widget.id);
                                },
                          child: Text(
                            controller.isSubmitting
                                ? 'Proccessing . . .'
                                : 'Reject',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: GetBuilder<DisburseController>(
              builder: (controller) {
                return ListView(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: CachedNetworkImageProvider(
                            controller.user.photoUrl),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      title: Text(
                        'Aadhaar No.',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.aadhaarNo,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   LightBoxRoute(
                            //     builder: (BuildContext context) {
                            //       return LightBox(
                            //         controller.aadhaarFront,
                            //         isUrl: true, // if the array of images are url
                            //       );
                            //     },
                            //     dismissible: false,
                            //   ),
                            // );
                          },
                          child: Container(
                            height: 500,
                            width: Get.width / 2.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    controller.user.aadhaarFront),
                                fit: BoxFit.fill,
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   LightBoxRoute(
                            //     builder: (BuildContext context) {
                            //       return LightBox(
                            //         controller.aadhaarBack,
                            //         isUrl: true, // if the array of images are url
                            //       );
                            //     },
                            //     dismissible: false,
                            //   ),
                            // );
                          },
                          child: Container(
                            height: 500,
                            width: Get.width / 2.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    controller.user.aadhaarBack),
                                fit: BoxFit.fill,
                              ),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      title: Text(
                        'PAN No.',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.pan,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   LightBoxRoute(
                        //     builder: (BuildContext context) {
                        //       return LightBox(
                        //         controller.panFront,
                        //         isUrl: true, // if the array of images are url
                        //       );
                        //     },
                        //     dismissible: false,
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 500,
                        width: Get.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                controller.user.panFront),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Mobile No.',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Address',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        controller.user.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'College',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.collegeName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Stream',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.stream,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Year',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.year,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Bank Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.bankName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'IFSC',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.ifsc,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Account Number',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Global.mainColor,
                        ),
                      ),
                      trailing: Text(
                        controller.user.accountNumber,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
