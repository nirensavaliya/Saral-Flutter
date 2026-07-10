import 'package:flutter/material.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';

class Customerviewscreen extends StatelessWidget {
  const Customerviewscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Customer View",showBackButton: false,),
      body: Container(
        color: Colors.green[100],
        child: Text("Customer View Data"),
      ),
    );
  }
}
