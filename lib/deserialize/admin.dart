import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String id;
  final String name;
  final String email;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AdminModel.fromDocument(DocumentSnapshot doc) {
    return AdminModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
    );
  }
}
