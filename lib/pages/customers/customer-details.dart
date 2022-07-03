import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happyadmin/deserialize/user.dart';
import 'package:happyadmin/init.dart';
import 'package:happyadmin/shared/global.dart';
import 'package:lottie/lottie.dart';

class CustomerDetails extends StatefulWidget {
  final DocumentSnapshot doc;
  CustomerDetails({required this.doc});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late DUser user;
  List<String> aadhaarFront = [];
  List<String> aadhaarBack = [];
  List<String> panFront = [];

  @override
  void initState() {
    super.initState();
    user = DUser.fromDocument(widget.doc);
    setState(() {});
    aadhaarFront.add(user.aadhaarFront);
    aadhaarBack.add(user.aadhaarBack);
    panFront.add(user.panFront);
  }

  profileTab() {
    return ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: CircleAvatar(
            radius: 100,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
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
            user.aadhaarNo,
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
                //         aadhaarFront,
                //         isUrl: true, // if the array of images are url
                //       );
                //     },
                //     dismissible: false,
                //   ),
                // );
              },
              child: Container(
                height: 350,
                width: Get.width / 2.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user.aadhaarFront),
                    fit: BoxFit.contain,
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
                //         aadhaarBack,
                //         isUrl: true, // if the array of images are url
                //       );
                //     },
                //     dismissible: false,
                //   ),
                // );
              },
              child: Container(
                height: 350,
                width: Get.width / 2.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user.aadhaarBack),
                    fit: BoxFit.contain,
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
            user.pan,
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
            //         panFront,
            //         isUrl: true, // if the array of images are url
            //       );
            //     },
            //     dismissible: false,
            //   ),
            // );
          },
          child: Container(
            height: 350,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(user.panFront),
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
            user.phone,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Address',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Global.mainColor,
            ),
          ),
          trailing: Text(
            user.address,
            overflow: TextOverflow.ellipsis,
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
            user.collegeName,
            overflow: TextOverflow.ellipsis,
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
            user.stream,
            overflow: TextOverflow.ellipsis,
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
            user.year,
            overflow: TextOverflow.ellipsis,
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
            user.bankName,
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
            user.ifsc,
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
            user.accountNumber,
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
  }

  String getInitials(name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  contactsTab() {
    return StreamBuilder(
      stream: contactsRef.doc(user.id).collection('contacts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return snapshot.data!.docs.length < 1
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Lottie.asset('assets/animations/empty.json'),
                    Text(
                      'No contacts found',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      radius: 25,
                      child:
                          Text(getInitials(snapshot.data!.docs[index]['name'])),
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs[index]['phone'],
                        ),
                        Text(
                          snapshot.data!.docs[index]['address'],
                        ),
                      ],
                    ),
                    // trailing: Icon(
                    //   Feather.check_circle,
                    //   color: Colors.greenAccent,
                    // ),
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              user.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: profileTab(),
    );
  }
}
