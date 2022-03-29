import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker_demo/pages/homePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_demo/pages/login.dart';

DateTime currentBackPressTime = DateTime.now().subtract(const Duration(days: 3));

class TestList extends StatefulWidget {
  const TestList({Key? key}) : super(key: key);

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
      onWillPop: onWillPop,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(dp),
                  backgroundColor: Colors.transparent,
                )),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Welcome,",
                    style: TextStyle(
                        fontSize: 26, color: Color.fromARGB(255, 9, 112, 196)),
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
                        fontSize: 26, color: Color.fromARGB(255, 98, 27, 131)),
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
                  "Select your Test",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 9, 112, 196)),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                  child: Text(
                    "Test 1",
                    style: TextStyle(
                        fontSize: 24, color: Color.fromARGB(255, 226, 33, 33)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
            ),
            Container(
                child: RawMaterialButton(
              onPressed: () async {
                signout();
              },
              elevation: 6.0,
              fillColor: Colors.white,
              child: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                size: 35.0,
              ),
              padding: EdgeInsets.all(16.0),
              shape: CircleBorder(),
            )),
          ],
        ),
      ),
    ),
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
    dp = "";
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 1),
          elevation: 6.0,
          content: Text(
            'Tap again to signout and exit',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      return Future.value(false);
    }
    signout();
    return Future.value(true);
  }
}
