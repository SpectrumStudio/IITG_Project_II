import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/pages/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  var email = "";
  var password = "";
  var confirmPassword = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  registration() async {
    email = email.trim();
    password = password.trim();
    confirmPassword = confirmPassword.trim();
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 253, 117, 117),
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //print("Password Provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          //print("Account Already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
    } else {
      //print("Password and Confirm Password doesn't match");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Color.fromARGB(255, 0, 150, 242),
        //   Color.fromARGB(255, 0, 242, 236),
        //   Color.fromARGB(255, 0, 150, 242)
        // ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        children: [
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
          Center(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 24.0,
                    spreadRadius: 16.0,
                    color: Colors.black.withOpacity(0.2))
              ]),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 250,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.3),
                        )),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: FaIcon(FontAwesomeIcons.envelope),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(fontSize: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  errorStyle: TextStyle(
                                      color: Color.fromARGB(200, 0, 32, 63),
                                      fontSize: 15),
                                ),
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email';
                                  } else if (!value.contains('@')) {
                                    return 'Please Enter Valid Email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                autofocus: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: FaIcon(FontAwesomeIcons.key),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  errorStyle: TextStyle(
                                      color: Color.fromARGB(200, 0, 32, 63),
                                      fontSize: 15),
                                ),
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                autofocus: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: FaIcon(FontAwesomeIcons.key),
                                  ),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(fontSize: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  errorStyle: TextStyle(
                                      color: Color.fromARGB(200, 0, 32, 63),
                                      fontSize: 15),
                                ),
                                controller: confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.orange,
                                        )
                                      : Container(
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              // Validate returns true if the form is valid, otherwise false.
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  email = emailController.text;
                                                  password =
                                                      passwordController.text;
                                                  confirmPassword =
                                                      confirmPasswordController
                                                          .text;
                                                });
                                                registration();
                                                if (isLoading) return;
                                                setState(
                                                    () => isLoading = true);
                                                await Future.delayed(
                                                    Duration(seconds: 1));
                                                setState(
                                                    () => isLoading = false);
                                              }
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an Account?"),
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              ),
                                            )
                                          },
                                      child: Text('Login',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
