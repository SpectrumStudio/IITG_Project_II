import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_demo/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for Errors
        if (snapshot.hasError) {
          print("Something Went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PG-Mal-Digital',
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color.fromARGB(200, 0, 32, 63),
              secondary: Color.fromARGB(200, 3, 0, 158),
            ),
            //primaryColor: Color.fromARGB(255, 0, 0, 0),
            //visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Login(),
        );
      },
    );
  }
}
