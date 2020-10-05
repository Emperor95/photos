import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photos/screens/login_screen.dart';
import 'package:photos/screens/profile_completion_screen.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";

  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: _firestore.doc(_auth.currentUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            if (data['dob'] != null &&
                data['occupation'] != null &&
                data['gender'] != null &&
                data['height'] != null) {
              return HomeScreen();
            } else {
              return ProfileCompletionScreen();
            }
            // return Text("Full Name: ${data['name']} ${data['occupation']}");
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      Text(
                        'Photos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: new CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return LoginScreen();
    }
  }
}
