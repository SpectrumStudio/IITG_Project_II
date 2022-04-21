import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_demo/pages/login.dart';
import 'package:intl/intl.dart';

var name = "";
var age = "";
var sex = "";
var location = "";

class SaveInfo extends StatefulWidget {
  const SaveInfo({Key? key}) : super(key: key);

  @override
  State<SaveInfo> createState() => _SaveInfoState();
}

class _SaveInfoState extends State<SaveInfo> {

  final _formValidKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final sexController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    sexController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formValidKey,
        child: ListView(
          children: 
            [Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, ),
                      child: Text(
                        'Enter the details below',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                //SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      controller: ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Sex',
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      controller: sexController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sex';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      controller: locationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        if(_formValidKey.currentState!.validate()){
                          setState(() {
                           name=nameController.text;
                           age=ageController.text;
                           sex=sexController.text;
                           location=locationController.text;
                        });
                        addData();
                        
                        }  
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 250, 226, 7),
                      ),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> addData() async {
  FirebaseAuth auth=FirebaseAuth.instance;
  String uid=auth.currentUser!.uid.toString();
  DateFormat date= DateFormat("yyyyMMddHHmmss");
  String string=date.format(DateTime.now());

  if (email == "") {
    CollectionReference users = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Malaria');
    users.doc(uid+string).set({
      'username': userName,
      'created': DateTime.now().toString(),
      'uid': uid,
      'fullname': name,
      'age': age,
      'sex': sex,
      'location': location,
      
    });
    
    
  } else if (userName == "") {
    CollectionReference users = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Malaria');
    users.doc(uid+string).set({
      'username': email.substring(0, email.lastIndexOf("@")),
      'created': DateTime.now().toString(),
      'uid': uid,
      'fullname': name,
      'age': age,
      'sex': sex,
      'location': location,
    });
  }
  return;
}