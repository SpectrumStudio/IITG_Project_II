import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker_demo/pages/homePage.dart';
import 'package:image_picker_demo/pages/login.dart';

class TestList extends StatefulWidget {
  const TestList({Key? key}) : super(key: key);

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome,",
              style: TextStyle(
                  fontSize: 26, color: Color.fromARGB(255, 9, 112, 196)),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: TextStyle(
                  fontSize: 26, color: Color.fromARGB(255, 98, 27, 131)),
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
            TextButton(
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
        SizedBox(height: 50,),
        Container(
          child: ActionChip(           
            padding: EdgeInsets.all(2.0),
            elevation: 6.0,
            avatar: CircleAvatar(   
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.logout_outlined),             
            ),
            label: const Text('Signout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false);
                await GoogleSignIn().signOut();
            },
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shape: StadiumBorder(
              side: BorderSide(width: 2,
              color: Colors.blueAccent)),
          )
        ),
      ],
    ));
  }
}
