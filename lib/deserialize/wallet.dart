import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final double limit;
  final double used;

  Wallet({
    required this.limit,
    required this.used,
  });

  factory Wallet.fromDocument(DocumentSnapshot doc) {
    return Wallet(
      limit: doc['limit'].toDouble() ?? 0,
      used: doc['used'].toDouble() ?? 0,
    );
  }
}
