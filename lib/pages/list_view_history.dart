import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_demo/pages/Nodata.dart';
import 'package:image_picker_demo/pages/firebase.dart';
import 'package:image_picker_demo/pages/login.dart';

class ListViewHistory extends StatefulWidget {
  @override
  State<ListViewHistory> createState() => _ListViewHistoryState();
}

class _ListViewHistoryState extends State<ListViewHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Malaria').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (snapshot.hasError) {
            //   return Text('Something went wrong');
            // } if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Center(
                    child: Card(
                      child: (data["uid"] == uid)
                          ? ListTile(
                              title: Text('Name: '+data['Display Name']),
                              subtitle: Text('Id: '+data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid'] +
                                  "\n" +
                                  data['uid']),
                            )
                          : null,
                    ),
                  );

                }).toList(),
              );
          }),
    );
  }
}
