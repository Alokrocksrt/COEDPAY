import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/controllers/normal.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/pages/customers/activate_customer.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';
import 'package:lottie/lottie.dart';
// import 'package:backdrop_modal_route/backdrop_modal_route.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final NormalController normalController = Get.find();
  bool isAvailable = false;
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'browser';
    _sortAscending = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_willSearch) {
        if (_latestTick != null && timer.tick > _latestTick!) {
          _willSearch = true;
        }
      }
      if (_willSearch) {
        _willSearch = false;
        _latestTick = null;
        setState(() {
          if (_filterTexts != null && _filterTexts!.isNotEmpty) {
            _filterTexts = _filterTexts;
            print('filterTexts = $_filterTexts');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  // pushBackDrop({required DocumentSnapshot doc}) async {
  //   DUser user = DUser.fromDocument(doc);
  //   await Navigator.push(
  //     context,
  //     BackdropModalRoute<void>(
  //       overlayContentBuilder: (context) {
  //         return SingleChildScrollView(
  //           child: Container(
  //             alignment: Alignment.center,
  //             padding: const EdgeInsets.all(24),
  //             child: ListView(
  //               shrinkWrap: true,
  //               children: [
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //                 Center(
  //                   child: CircleAvatar(
  //                     radius: 100,
  //                     backgroundImage:
  //                         CachedNetworkImageProvider(user.photoUrl),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'Aadhaar No.',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.aadhaarNo,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         // Navigator.push(
  //                         //   context,
  //                         //   LightBoxRoute(
  //                         //     builder: (BuildContext context) {
  //                         //       return LightBox(
  //                         //         aadhaarFront,
  //                         //         isUrl: true, // if the array of images are url
  //                         //       );
  //                         //     },
  //                         //     dismissible: false,
  //                         //   ),
  //                         // );
  //                       },
  //                       child: Container(
  //                         height: 130,
  //                         width: Get.width / 2.2,
  //                         decoration: BoxDecoration(
  //                           image: DecorationImage(
  //                             image:
  //                                 CachedNetworkImageProvider(user.aadhaarFront),
  //                             fit: BoxFit.fill,
  //                           ),
  //                           border: Border.all(
  //                             width: 1,
  //                             color: Colors.grey,
  //                           ),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         // Navigator.push(
  //                         //   context,
  //                         //   LightBoxRoute(
  //                         //     builder: (BuildContext context) {
  //                         //       return LightBox(
  //                         //         aadhaarBack,
  //                         //         isUrl: true, // if the array of images are url
  //                         //       );
  //                         //     },
  //                         //     dismissible: false,
  //                         //   ),
  //                         // );
  //                       },
  //                       child: Container(
  //                         height: 130,
  //                         width: Get.width / 2.2,
  //                         decoration: BoxDecoration(
  //                           image: DecorationImage(
  //                             image:
  //                                 CachedNetworkImageProvider(user.aadhaarBack),
  //                             fit: BoxFit.fill,
  //                           ),
  //                           border: Border.all(
  //                             width: 1,
  //                             color: Colors.grey,
  //                           ),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'PAN No.',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.pan,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     // Navigator.push(
  //                     //   context,
  //                     //   LightBoxRoute(
  //                     //     builder: (BuildContext context) {
  //                     //       return LightBox(
  //                     //         panFront,
  //                     //         isUrl: true, // if the array of images are url
  //                     //       );
  //                     //     },
  //                     //     dismissible: false,
  //                     //   ),
  //                     // );
  //                   },
  //                   child: Container(
  //                     height: 150,
  //                     width: Get.width,
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                         image: CachedNetworkImageProvider(user.panFront),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'Mobile No.',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.phone,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'Address',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.address,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'Bank Name',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.bankName,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'IFSC',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.ifsc,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     'Account Number',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w800,
  //                       color: Global.mainColor,
  //                     ),
  //                   ),
  //                   trailing: Text(
  //                     user.accountNumber,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 90,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  customers() {
    return StreamBuilder(
      stream: usersRef
          .where('verified', isEqualTo: false)
          .where('underVerification', isEqualTo: true)
          .where('rejected', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DUser> userList = [];
        snapshot.data!.docs.forEach((doc) {
          userList.add(DUser.fromDocument(doc));
        });

        return userList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Lottie.asset('assets/animations/empty.json'),
                    Text(
                      'No customers to activate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: Get.width,
                height: Get.height,
                child: SingleChildScrollView(
                  child: WebDataTable(
                    header: Text(''),
                    actions: [
                      if (_selectedRowKeys.isNotEmpty)
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextButton(
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Enter Amount',
                                content: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: TextField(
                                    controller: amountController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0',
                                    ),
                                  ),
                                ),
                                textConfirm: 'Approve Selected Users',
                                onConfirm: () {
                                  Get.back();
                                  normalController.approveMulti(
                                    ids: _selectedRowKeys,
                                    amount: double.parse(amountController.text),
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                          ),
                        ),
                      if (_selectedRowKeys.isNotEmpty)
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: TextButton(
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              normalController.rejectMulti(
                                  ids: _selectedRowKeys);
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                          ),
                        ),
                      Container(
                        width: 300,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            _filterTexts = text.trim().split(' ');
                            _willSearch = false;
                            _latestTick = _timer?.tick;
                          },
                        ),
                      ),
                    ],
                    source: WebDataTableSource(
                      sortColumnName: _sortColumnName,
                      sortAscending: _sortAscending,
                      filterTexts: _filterTexts,
                      columns: [
                        WebDataColumn(
                          name: '#',
                          label: const Text('#'),
                          dataCell: (value) => DataCell(Text('$value')),
                        ),
                        WebDataColumn(
                          name: 'name',
                          label: const Text('Name'),
                          dataCell: (value) => DataCell(Text('$value')),
                        ),
                        WebDataColumn(
                          name: 'address',
                          label: const Text('Address'),
                          dataCell: (value) => DataCell(Text('$value')),
                        ),
                        WebDataColumn(
                          name: 'pan',
                          label: const Text('PAN'),
                          dataCell: (value) =>
                              DataCell(Text('$value'.capitalize.toString())),
                        ),
                        WebDataColumn(
                          name: 'phone',
                          label: const Text('Phone No.'),
                          dataCell: (value) => DataCell(Text('$value')),
                        ),
                        WebDataColumn(
                          name: 'time',
                          label: const Text('Time'),
                          dataCell: (value) => DataCell(
                            Text(
                              Jiffy(value).fromNow(),
                            ),
                          ),
                        ),
                      ],
                      rows: List<Map<String, dynamic>>.generate(
                        snapshot.data!.docs.length,
                        (index) {
                          Timestamp time =
                              snapshot.data!.docs[index]['timestamp'];
                          return {
                            '#': index + 1,
                            'id': userList[index].id,
                            'name': userList[index].name,
                            'address': userList[index].address,
                            'pan': userList[index].pan,
                            'phone': userList[index].phone,
                            'photoUrl': userList[index].photoUrl,
                            'time': time.toDate(),
                          };
                        },
                      ),
                      selectedRowKeys: _selectedRowKeys,
                      onTapRow: (rows, index) {
                        print(
                            'onTapRow(): index = $index, row = ${rows[index]}');
                        // pushBackDrop(doc: snapshot.data!.docs[index]);
                        Get.to(() => ActivateCustomer(id: userList[index].id));
                      },
                      onSelectRows: (keys) {
                        print(
                            'onSelectRows(): count = ${keys.length} keys = $keys');
                        setState(() {
                          _selectedRowKeys = keys;
                        });
                      },
                      primaryKeyName: 'id',
                    ),
                    horizontalMargin: 100,
                    onPageChanged: (offset) {
                      print('onPageChanged(): offset = $offset');
                    },
                    onSort: (columnName, ascending) {
                      print(
                          'onSort(): columnName = $columnName, ascending = $ascending');
                      setState(() {
                        _sortColumnName = columnName;
                        _sortAscending = ascending;
                      });
                    },
                    onRowsPerPageChanged: (rowsPerPage) {
                      print(
                          'onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
                      setState(() {
                        if (rowsPerPage != null) {
                          _rowsPerPage = rowsPerPage;
                        }
                      });
                    },
                    rowsPerPage: _rowsPerPage,
                  ),
                ),
              );
      },
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
                  'Activate Customers',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
                centerTitle: false,
                actions: [
                  Visibility(
                    visible: isAvailable,
                    child: TextButton(
                      onPressed: () {
                        controller.approveAll();
                      },
                      child: Text('Approve All'),
                    ),
                  ),
                ],
              ),
              body: customers(),
            ),
          );
        },
      );
    });
  }
}
