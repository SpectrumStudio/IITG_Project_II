import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Center(
                  child: Card(
                    child: ListTile(
                      //width: MediaQuery.of(context).size.width / 1.2,
                      //height: MediaQuery.of(context).size.height / 6,
                      //child: Text("Username: " + document['Display Name']),
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
                      //isThreeLine: true,
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
