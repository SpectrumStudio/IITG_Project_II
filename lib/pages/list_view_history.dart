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
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Malaria").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (!snapshot.hasData) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NoData()));
              }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
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
            );
          }),
    );
  }
}
