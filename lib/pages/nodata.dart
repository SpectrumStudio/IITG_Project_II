import 'package:flutter/material.dart';

class NoData extends StatefulWidget {
 @override
  State<NoData> createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
         child: Center(
           child: Text('No Data available'),
           
         ),
       ),
    );
  }
}