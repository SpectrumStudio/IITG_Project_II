import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/pages/Nodata.dart';
import 'package:image_picker_demo/pages/login.dart';
import 'package:image_picker_demo/pages/saveinfo.dart';

class ListViewHistory extends StatefulWidget {
  @override
  State<ListViewHistory> createState() => _ListViewHistoryState();
}

class _ListViewHistoryState extends State<ListViewHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: null,
      body: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            left: 130,
            top: Get.height * 0.17,
            child: Container(
              //height: MediaQuery.of(context).size.height,
              //width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/flask.png'),
                  //fit: BoxFit.fill,
                ),
                //shape: BoxShape.circle,
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('Malaria')
                .orderBy('created', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // if (snapshot.hasError) {
              //   return Text('Something went wrong');
              // } if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // } else
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isNotEmpty) {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Center(
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 24.0,
                                spreadRadius: 16.0,
                                color: Colors.black.withOpacity(0.12))
                          ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 8.0,
                                sigmaY: 8.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.white.withOpacity(0.3),
                                    )),
                                child: ListTile(
                                  title: Text(
                                    'Username: ' + data['username'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Column(children: [
                                    Text(
                                      // 'Id: ' +
                                      //     data['uid'] +
                                      //     "\n" +
                                          'Full Name: ' +
                                          data['fullname'] +
                                          "\n" +
                                          'Age: ' +
                                          data['age'] +
                                          "\n" +
                                          'Sex: ' +
                                          data['sex'] +
                                          "\n" +
                                          'Location: ' +
                                          data['location'] +
                                          "\n" +
                                          'Created on: ' +
                                          data['created'] +
                                          "\n" +
                                          'Red Value: ' +
                                          data['r_value'] +
                                          "\n" +
                                          'Green Value: ' +
                                          data['g_value'] +
                                          "\n" +
                                          'Blue Value: ' +
                                          data['b_value'] +
                                          "\n" +
                                          'Intensity Value: ' +
                                          data['i_value'] +
                                          "\n" +
                                          'Predicted Result: ' +
                                          data['pred_value'],
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    //SizedBox(height: 15),
                                    // Icon(
                                    //   Icons.circle,
                                    //   size: 35,
                                    //   color: Color.fromARGB(
                                    //       255,
                                    //       double.parse(data['r_value']).toInt(),
                                    //       double.parse(data['g_value']).toInt(),
                                    //       double.parse(data['b_value'])
                                    //           .toInt()),
                                    // )
                                  ]),
                                  leading: Icon(
                                      Icons.circle,
                                      size: 40,
                                      color: Color.fromARGB(
                                          255,
                                          double.parse(data['r_value']).toInt(),
                                          double.parse(data['g_value']).toInt(),
                                          double.parse(data['b_value'])
                                              .toInt()),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ]),
                    );
                  }).toList(),
                );
              }

              return Container(
                child: Center(
                  child: Text(
                    'No Details available',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
