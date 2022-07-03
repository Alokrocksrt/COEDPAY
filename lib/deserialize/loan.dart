import 'package:cloud_firestore/cloud_firestore.dart';

class DLoan {
  final String id;
  final String userId;
  final double amount;
  final int rate;
  final int tenure;
  final int proccessingFee;
  final bool disbursed;
  final bool repaid;
  final double repayment;
  final Timestamp repaymentDate;
  final Timestamp timestamp;

  DLoan({
    required this.id,
    required this.userId,
    required this.amount,
    required this.rate,
    required this.tenure,
    required this.proccessingFee,
    required this.disbursed,
    required this.repaid,
    required this.repayment,
    required this.repaymentDate,
    required this.timestamp,
  });

  factory DLoan.fromDocument(DocumentSnapshot doc) {
    return DLoan(
      id: doc['id'],
      userId: doc['userId'],
      amount: doc['amount'].toDouble(),
      rate: doc['rate'],
      tenure: doc['tenure'],
      proccessingFee: doc['proccessingFee'],
      disbursed: doc['disbursed'],
      repaid: doc['repaid'],
      repayment: doc['repayment'].toDouble(),
      repaymentDate: doc['repaymentDate'],
      timestamp: doc['timestamp'],
    );
  }
}
