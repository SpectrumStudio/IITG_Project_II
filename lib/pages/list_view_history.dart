import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_demo/pages/Nodata.dart';
import 'package:image_picker_demo/pages/login.dart';

class ListViewHistory extends StatefulWidget {
  @override
  State<ListViewHistory> createState() => _ListViewHistoryState();
}

class _ListViewHistoryState extends State<ListViewHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Malaria").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (!snapshot.hasData) {
            return Container(
              child: Center(child: Text("Document does not exist")),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return SingleChildScrollView(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Center(
                    child: Card(
                      child: (document['Display Name'] == userName)
                          ? ListTile(
                              title: Text(document['Display Name']),
                              subtitle: Text(document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid'] +
                                  "\n" +
                                  document['uid']),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            );
        });
  }
}
