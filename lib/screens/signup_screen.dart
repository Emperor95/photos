import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:photos/screens/login_screen.dart';
import 'package:photos/screens/profile_completion_screen.dart';
import 'package:photos/utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  static String id = "signup_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _usersCollection = FirebaseFirestore.instance.collection("Users");

  String _email = "", _password = "", _name = "";
  bool showProgressModal = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgressModal,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    TextField(
                      onChanged: (value) {
                        _name = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: "Enter your name",
                        hintText: "Enter your name",
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      onChanged: (value) {
                        _email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: "Enter your email",
                        hintText: "Enter your email",
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      onChanged: (value) {
                        _password = value;
                      },
                      obscureText: true,
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: "Enter your password",
                        hintText: "Enter your password",
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Material(
                      color: Colors.red,
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(8),
                      child: MaterialButton(
                        onPressed: () async {
                          if (_name.isEmpty) {
                            // show snackbar to alert user
                            print("name is empty ...");
                            Fluttertoast.showToast(
                              msg: "Enter your name ...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                          if (_email.isEmpty) {
                            // show snackbar to alert user
                            print("email is empty ...");
                            Fluttertoast.showToast(
                              msg: "Email cannot be empty ...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                          if (_password.isEmpty) {
                            // show snackbar to alert user
                            print("password is empty ...");
                            Fluttertoast.showToast(
                              msg: "Password cannot be empty ...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }

                          showProgressModal = true;
                          setState(() {});

                          try {
                            final user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            if (user != null) {
                              await _usersCollection
                                  .doc(_auth.currentUser.uid)
                                  .set({
                                "name": _name,
                                "email": _email,
                                "uid": _auth.currentUser.uid,
                                "registeredOn": FieldValue.serverTimestamp()
                              });
                              Navigator.pushReplacementNamed(
                                  context, ProfileCompletionScreen.id);
                            }
                            showProgressModal = false;
                            setState(() {});
                          } catch (e) {
                            print(e);
                            showProgressModal = false;
                            setState(() {});
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                        },
                        child: Text("Already have an account? Login"))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
