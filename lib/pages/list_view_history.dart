import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      floatingActionButton: null,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Malaria')
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Center(
                  child: Card(
                    child: ListTile(
                      title: Text('Username: ' + data['username'],style: TextStyle(fontSize: 20),),
                      subtitle: Text('Id: ' + data['uid'] +
                          "\n" +
                          'Full Name: '+data['fullname'] +
                          "\n" +
                          'Age: '+data['age'] +
                          "\n" +
                          'Sex: '+data['sex'] +
                          "\n" +
                          'Location: '+data['location'] +
                          "\n" +
                          'Created on: '+data['created'] +
                          "\n" +
                          data['uid'] +
                          "\n" +
                          data['uid'] +
                          "\n" +
                          data['uid'],style: TextStyle(fontSize: 18,),),
                    ),
                  ),
                );
              }).toList(),
            );
          }

          return Container(
            child: Center(
              child: Text('No Details available',style: TextStyle(fontSize: 20),),
            ),
          );
        },
      ),
    );
  }
}
