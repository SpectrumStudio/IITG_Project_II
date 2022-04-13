import 'dart:io';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker_demo/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_demo/pages/forgot_password.dart';
import 'package:image_picker_demo/pages/homePage.dart';
import 'package:image_picker_demo/pages/signup.dart';
import 'package:image_picker_demo/pages/testList.dart';
import 'package:image_picker_demo/pages/user/user_main.dart';
import 'package:provider/provider.dart';

var userName = "";
var userEmail = "";
var email = "";
var password = "";
var dp = "";
var uid="";

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      email = email.trim();
      password = password.trim();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FirebaseAuth auth=FirebaseAuth.instance;
      uid=auth.currentUser!.uid.toString();    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestList(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 1),
          elevation: 6.0,
          content: Text(
            'Welcome, ' +
                ((email == "")
                    ? userName
                    : email.substring(0, email.indexOf('@'))),
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            duration: const Duration(seconds: 2),
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        // print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            duration: const Duration(seconds: 2),
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("User Login"),
      // ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
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
                    labelText: 'Password: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
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
                margin: EdgeInsets.only(left: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? CircularProgressIndicator(
                            color: Colors.orange,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  //print("Hello");
                                  email = emailController.text;
                                  //print(email);
                                  password = passwordController.text;
                                });
                                userLogin();
                                if (isLoading) return;
                                setState(() => isLoading = true);
                                await Future.delayed(Duration(seconds: 1));
                                setState(() => isLoading = false);
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                    SizedBox(width: 12),
                    TextButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        )
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account? "),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, a, b) => Signup(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                            (route) => false)
                      },
                      child: Text('Signup',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "OR",
                      style: TextStyle(fontSize: 20),
                    )),
                    SizedBox(
                      height: 26,
                    ),
                    FloatingActionButton.extended(
                      onPressed: () async {
                        bool success = await signInWithGoogle();

                        if (success) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestList(),
                              ),
                              (route) => false);
                          email = "";
                          password = "";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              duration: const Duration(seconds: 1),
                              elevation: 6.0,
                              content: Text(
                                'Welcome, ' +
                                    ((email == "")
                                        ? userName
                                        : email.substring(
                                            0, email.indexOf('@'))),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                          );
                        }
                      },
                      // icon: Image.asset(
                      //   'assets/google_logo.png',
                      //   height: 28,
                      //   width: 28,
                      // ),
                      icon: FaIcon(FontAwesomeIcons.google),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return false;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential usercreds =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // ignore: unnecessary_null_comparison
    if (usercreds != null) {
      userEmail = googleUser.email;
      userName = googleUser.displayName!;
      dp = googleUser.photoUrl!.replaceAll("s96-c", "s400-c");
    }
    FirebaseAuth auth=FirebaseAuth.instance;
    uid=auth.currentUser!.uid.toString();

    return true;
  }
}
