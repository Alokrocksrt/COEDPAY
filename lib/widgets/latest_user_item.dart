import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LatestUserItem extends StatelessWidget {
  final String id;
  final String pan;
  final String name;
  final String email;
  final String photoUrl;
  final String phone;
  final bool verified;
  final bool underVerification;

  LatestUserItem({
    required this.id,
    required this.pan,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.phone,
    required this.verified,
    required this.underVerification,
  });

  factory LatestUserItem.fromDocument(DocumentSnapshot doc) {
    return LatestUserItem(
      id: doc['id'],
      pan: doc['pan'],
      name: doc['name'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      phone: doc['phoneNo'],
      verified: doc['verified'],
      underVerification: doc['underVerification'],
    );
  }

  String getFirstName() {
    int index = name.lastIndexOf(" ");
    if (index > -1) {
      return name.substring(0, index);
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    String firstName = getFirstName();
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Container(
        height: 160,
        width: 120,
        child: Card(
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 20,
                  shadowColor: Colors.black38,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(photoUrl),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    firstName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 19,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    verified
                        ? 'Verified'
                        : !verified && underVerification
                            ? 'Proccessing'
                            : 'Inactive',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: verified
                          ? Colors.lightGreen
                          : !verified && underVerification
                              ? Colors.yellow
                              : Colors.redAccent,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
