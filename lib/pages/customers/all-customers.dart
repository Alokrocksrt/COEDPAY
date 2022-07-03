import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:happyadmin/controllers/nav.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/pages/customers/customer-details.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:happyadmin/shared/responsive.dart';
import 'package:happyadmin/shared/side_menu.dart';
import 'package:lottie/lottie.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  // final NormalController normalController = Get.find();
  bool isAvailable = false;
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

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

  String searchKey = '';

  Stream<QuerySnapshot> stream() async* {
    var _stream = usersRef.where('verified', isEqualTo: true).snapshots();
    yield* _stream;
  }

  Stream<QuerySnapshot> searchData(String string) async* {
    var _search = usersRef
        .where('name', isGreaterThanOrEqualTo: string)
        .where('name', isLessThan: string + 'z')
        .snapshots();

    yield* _search;
  }

  StreamBuilder<QuerySnapshot> buidlList() {
    return StreamBuilder(
      stream: (searchKey != null || searchKey != "")
          ? searchData(searchKey)
          : stream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text('Search for someone'),
          );
        }
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: snapshot.data!.docs
              .map(
                (e) => ListTile(
                  onTap: () {
                    Get.to(() => CustomerDetails(doc: e));
                  },
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      e['photoUrl'],
                    ),
                  ),
                  title: Text(e['name']),
                  trailing: Icon(
                    Feather.circle,
                    color:
                        e['verified'] ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              )
              .toList(),
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
            centerTitle: true,
            title: Text(
              'Customers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
          body: ListView(
            children: [
              StreamBuilder(
                stream:
                    usersRef.orderBy('timestamp', descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // List<DUser> userList = [];
                  // snapshot.data!.docs.forEach((doc) {
                  //   userList.add(DUser.fromDocument(doc));
                  // });
                  // print(userList.first.photoUrl);

                  return snapshot.data!.docs.length <= 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/animations/empty.json'),
                            Text(
                              'No customers found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: Get.width,
                          height: Get.height,
                          child: GridView.builder(
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (snapshot.data!.docs[index]['verified']) {
                                    Get.to(() => CustomerDetails(
                                        doc: snapshot.data!.docs[index]));
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'You cannot view user without verification, to activate customer go to Axtivate Customers page.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
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
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  snapshot.data!.docs[index]
                                                      ['photoUrl']),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                                      ['verified'] ==
                                                  true
                                              ? 'Verified'
                                              : 'Not Verified',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: snapshot.data!.docs[index]
                                                        ['verified'] ==
                                                    true
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
