import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker_demo/pages/homePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_demo/pages/login.dart';

DateTime currentBackPressTime =
    DateTime.now().subtract(const Duration(days: 3));

class TestList extends StatefulWidget {
  const TestList({Key? key}) : super(key: key);

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     signout();
      //   },
      //   backgroundColor: Color.fromARGB(255, 3, 253, 212),
      //   child: FaIcon(
      //     FontAwesomeIcons.arrowRightFromBracket,
      //     size: 35.0,
      //   ),
      // ),
      body: Stack(children: [
        Positioned(
          left: 30,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () {
              signout();
            },
            backgroundColor: Color.fromARGB(255, 3, 253, 212),
            child: FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 35.0,
            ),
          ),
        ),
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
        WillPopScope(
            onWillPop: onWillPop,
            child: Center(
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 24.0,
                      spreadRadius: 16.0,
                      color: Colors.black.withOpacity(0.2))
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8.0,
                      sigmaY: 8.0,
                    ),
                    child: Container(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 270,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.white.withOpacity(0.3),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Container(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (email == "")
                      ? Center(
                          child: CircleAvatar(
                          backgroundColor: Color.fromARGB(200, 0, 32, 63),
                          radius: 70.0,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(dp),
                            backgroundColor: Colors.transparent,
                          ),
                        ))
                      : Center(
                          child: Initicon(
                            color: Colors.black,
                            size: 100,
                            backgroundColor: Colors.grey.shade300,
                            text: email[0].toUpperCase(),
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Welcome,",
                      style: TextStyle(
                          fontSize: 26,
                          color: Color.fromARGB(255, 9, 112, 196)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      (email == "")
                          ? userName
                          : email.substring(0, email.indexOf('@')),
                      style: TextStyle(
                          fontSize: 26,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    "Proceed to Test",
                    style: TextStyle(
                        fontSize: 22, color: Color.fromARGB(255, 9, 112, 196)),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            duration: const Duration(seconds: 2),
                            elevation: 6.0,
                            content: Text(
                              "Page Under Construction!",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Formaldehyde",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      child: Text(
                        "Malaria",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            duration: const Duration(seconds: 2),
                            elevation: 6.0,
                            content: Text(
                              "Page Under Construction!",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Methanol",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
    await GoogleSignIn().signOut();
    userEmail = "";
    userName = "";
    email = "";
    password = "";
    dp = "";
    uid = "";
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          content: Text(
            'Tap again to signout and exit',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
      return Future.value(false);
    }
    signout();
    return Future.value(true);
  }
}
