import 'package:flutter/material.dart';

class ApproveTransfer extends StatefulWidget {
  @override
  _ApproveTransferState createState() => _ApproveTransferState();
}

class _ApproveTransferState extends State<ApproveTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
