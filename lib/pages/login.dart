import 'dart:core';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker_demo/pages/forgot_password.dart';
import 'package:image_picker_demo/pages/signup.dart';
import 'package:image_picker_demo/pages/testList.dart';

var userName = "";
var userEmail = "";
var email = "";
var password = "";
var dp = "";
var uid = "";

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
      FirebaseAuth auth = FirebaseAuth.instance;
      uid = auth.currentUser!.uid.toString();
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
      resizeToAvoidBottomInset: false,
      body: Stack(
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
                borderRadius: BorderRadius.circular(16.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
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
                              child: TextButton(
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
                            ),
                            Container(
                              //margin: EdgeInsets.only(left: 60.0),
                              child: Center(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.orange,
                                      )
                                    : Container(
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                200,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            // Validate returns true if the form is valid, otherwise false.
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                //print("Hello");
                                                email = emailController.text;
                                                //print(email);
                                                password =
                                                    passwordController.text;
                                              });
                                              userLogin();
                                              if (isLoading) return;
                                              setState(() => isLoading = true);
                                              await Future.delayed(
                                                  Duration(seconds: 1));
                                              setState(() => isLoading = false);
                                            }
                                          },
                                          child: Text(
                                            'Login',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ),
                                //SizedBox(width: 12),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an Account? "),
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ),
                                      )
                                    },
                                    child: Text('Signup',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: new Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 15.0),
                                            child: Divider(
                                              color: Colors.black,
                                              height: 50,
                                            )),
                                      ),
                                      Text("OR"),
                                      Expanded(
                                        child: new Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 15.0),
                                            child: Divider(
                                              color: Colors.black,
                                              height: 50,
                                            )),
                                      ),
                                    ],
                                  ),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 255, 255),
                                            duration:
                                                const Duration(seconds: 1),
                                            elevation: 6.0,
                                            content: Text(
                                              'Welcome, ' +
                                                  ((email == "")
                                                      ? userName
                                                      : email.substring(0,
                                                          email.indexOf('@'))),
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Image.asset(
                                      'assets/google_logo.png',
                                      height: 28,
                                      width: 28,
                                    ),
                                    //icon: FaIcon(FontAwesomeIcons.google),
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
                  ),
                ),
              ),
            ),
          ),
        ],
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
    FirebaseAuth auth = FirebaseAuth.instance;
    uid = auth.currentUser!.uid.toString();

    return true;
  }
}
