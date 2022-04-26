import 'dart:core';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/pages/login.dart';
import 'package:image_picker_demo/pages/mlPage.dart';
import 'package:image_picker_demo/pages/testList.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

var name = "";
//var age = "";
var sex = "";
var location = "";
enum SingingCharacter { Male, Female, Others }
var _currentHorizontalIntValue = 10;

class SaveInfo extends StatefulWidget {
  const SaveInfo({Key? key}) : super(key: key);

  @override
  State<SaveInfo> createState() => _SaveInfoState();
}

class _SaveInfoState extends State<SaveInfo> {
  final _formValidKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  //final sexController = TextEditingController();
  final locationController = TextEditingController();

  //SingingCharacter? gender = SingingCharacter.Male;
  SingingCharacter? gender;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    //sexController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //left: 20,
          //right: 20,
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
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8.0,
              sigmaY: 8.0,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.white.withOpacity(0.3),
                  )),
              child: Form(
                key: _formValidKey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'User Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15),
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
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle: TextStyle(fontSize: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15),
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
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Age',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          // child: Padding(
                          //   padding: const EdgeInsets.only(left: 12, right: 12),
                          //   child: TextFormField(
                          //     autofocus: false,
                          //     keyboardType: TextInputType.number,
                          //     decoration: InputDecoration(
                          //       labelText: 'Age',
                          //       labelStyle: TextStyle(fontSize: 20.0),
                          //       border: OutlineInputBorder(),
                          //       errorStyle:
                          //           TextStyle(color: Colors.redAccent, fontSize: 15),
                          //     ),
                          //     controller: ageController,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Please enter your age';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                          child: NumberPicker(
                            value: _currentHorizontalIntValue,
                            minValue: 10,
                            maxValue: 120,
                            step: 1,
                            itemHeight: 50,
                            axis: Axis.horizontal,
                            onChanged: (value) => setState(() {
                              _currentHorizontalIntValue = value;
                              //age = _currentHorizontalIntValue.toString();
                            }),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black26),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(fontSize: 18),
                              ),
                              ListTile(
                                title: const Text('Male'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.Male,
                                  groupValue: gender,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      gender = value;
                                      sex = "Male";
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Female'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.Female,
                                  groupValue: gender,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      gender = value;
                                      sex = "Female";
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Others'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.Others,
                                  groupValue: gender,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      gender = value;
                                      sex = "Others";
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            children: [
                              Text(
                                  "R: " +
                                      redPar +
                                      " G: " +
                                      greenPar +
                                      " B: " +
                                      bluePar +
                                      " I: " +
                                      intensityPar,
                                  style: TextStyle(fontSize: 17)),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Pred Value: " + predValue,
                                  style: TextStyle(fontSize: 17))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formValidKey.currentState!.validate()) {
                                    setState(() {
                                      name = nameController.text;
                                      //age = ageController.text;
                                      //sex = sexController.text;
                                      location = locationController.text;
                                    });
                                    addData(context);
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'SUBMIT',
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

Future<void> addData(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  DateFormat date = DateFormat("yyyyMMddHHmmss");
  String string = date.format(DateTime.now());

  if (email == "") {
    CollectionReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Malaria');
    users
        .doc(uid + string)
        .set({
          'username': userName,
          'created': DateTime.now().toString(),
          'uid': uid,
          'fullname': name,
          'age': _currentHorizontalIntValue.toString(),
          'sex': sex,
          'location': location,
          'r_value': redPar,
          'g_value': greenPar,
          'b_value': bluePar,
          'i_value': intensityPar,
          'pred_value': predValue,
        })
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Details saved successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a, b) => TestList(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                      (route) => false),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        )
        .catchError(
          (error) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Details not saved! Retry'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
    ;
  } else if (userName == "") {
    CollectionReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Malaria');
    users
        .doc(uid + string)
        .set({
          'username': email.substring(0, email.lastIndexOf("@")),
          'created': DateTime.now().toString(),
          'uid': uid,
          'fullname': name,
          'age': _currentHorizontalIntValue.toString(),
          'sex': sex,
          'location': location,
        })
        .then((value) => print("Details added successfully"))
        .catchError((error) => print("Failed to add details: $error"));
    ;
  }
  return;
}
