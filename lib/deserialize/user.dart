import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DUser {
  final String id;
  final String pan;
  final String name;
  final String address;
  final String email;
  final String photoUrl;
  final String phone;
  // final String? type;
  final bool verified;
  final bool underVerification;
  final String bankName;
  final String ifsc;
  final String accountNumber;
  final String aadhaarNo;
  final String aadhaarFront;
  final String aadhaarBack;
  final String panFront;
  final String collegeName;
  final String stream;
  final String year;

  DUser({
    required this.id,
    required this.pan,
    required this.name,
    required this.address,
    required this.email,
    required this.photoUrl,
    required this.phone,
    // required this.type,
    required this.verified,
    required this.underVerification,
    required this.bankName,
    required this.ifsc,
    required this.accountNumber,
    required this.aadhaarNo,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.panFront,
    required this.collegeName,
    required this.stream,
    required this.year,
  });

  factory DUser.fromDocument(DocumentSnapshot doc) {
    return DUser(
      id: doc['id'],
      pan: doc['pan'],
      name: doc['name'],
      address: doc['address'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      phone: doc['phoneNo'],
      verified: doc['verified'],
      underVerification: doc['underVerification'],
      bankName: doc['bankName'] ?? '',
      ifsc: doc['ifsc'],
      accountNumber: doc['accountNumber'],
      aadhaarNo: doc['aadhaarNo'],
      aadhaarFront: doc['aadhaarFrontURL'],
      aadhaarBack: doc['aadhaarBackURL'],
      panFront: doc['panURL'],
      collegeName: doc.get('collegeName'),
      stream: doc.get('stream'),
      year: doc.get('year'),
    );
  }
}
