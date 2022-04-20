import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker_demo/pages/login.dart';
import 'package:intl/intl.dart';

Future<void> addData() async {
  FirebaseAuth auth=FirebaseAuth.instance;
  String uid=auth.currentUser!.uid.toString();
  DateFormat date= DateFormat("yyyyMMddHHmmss");
  String string=date.format(DateTime.now());

  if (email == "") {
    CollectionReference users = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Malaria');
    users.doc(uid+string).set({
      'Display Name': userName,
      'Time': DateTime.now(),
      'uid': uid,
    });
    
    
  } else if (userName == "") {
    CollectionReference users = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Malaria');
    users.doc(uid+string).set({
      'Display Name': email.substring(0, email.lastIndexOf("@")),
      'Time': DateTime.now(),
      'uid': uid,
    });
  }
  return;
}

Future<void> fetchData() async{

  

  return;
}
