import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photos/utils/constants.dart';

import 'home_screen.dart';

class ProfileCompletionScreen extends StatefulWidget {
  static String id = "profile_completion_screen";

  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _firestore = FirebaseFirestore.instance.collection("Users");
  final _auth = FirebaseAuth.instance;

  String radioItem, occupation, height;
  int currentStep = 0;
  bool complete = false;

  String name = "";

  next() async {
    if (currentStep == 0) {
      if (selectedDate == null) {
        Fluttertoast.showToast(
          msg: "Select your date of birth...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return;
      }
      try {
        await _firestore
            .doc(_auth.currentUser.uid)
            .update({"dob": selectedDate});
      } catch (e) {
        print(e);
      }
    }
    if (currentStep == 1) {
      if (radioItem == null || radioItem.isEmpty) {
        Fluttertoast.showToast(
          msg: "Select your gender...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return;
      }
      try {
        await _firestore
            .doc(_auth.currentUser.uid)
            .update({"gender": radioItem});
      } catch (e) {
        print(e);
      }
    }
    if (currentStep == 2) {
      if (occupation == null || occupation.isEmpty) {
        Fluttertoast.showToast(
          msg: "Tell us what you do...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return;
      }
      try {
        await _firestore
            .doc(_auth.currentUser.uid)
            .update({"occupation": occupation});
      } catch (e) {
        print(e);
      }
    }
    if (currentStep == 3) {
      if (height == null || height.isEmpty) {
        Fluttertoast.showToast(
          msg: "How tall you are you...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return;
      }
      try {
        await _firestore.doc(_auth.currentUser.uid).update({"height": height});
      } catch (e) {
        print(e);
      }
    }
    currentStep + 1 != stepper().length
        ? goTo(currentStep + 1)
        // : setState(() => complete = true
        : Fluttertoast.showToast(
            msg: "Profile setup completed ...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          ).then(
            (value) => Navigator.pushReplacementNamed(context, HomeScreen.id));
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  DateTime selectedDate; //DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: "Select Your Date Of Birth",
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  checkStatus() async {
    try {
      final document = await _firestore.doc(_auth.currentUser.uid).get();
      if (document.exists) {
        if (document.data()["dob"] == null) {
          currentStep = 0;
        } else if (document.data()["gender"] == null) {
          currentStep = 1;
        } else if (document.data()["occupation"] == null) {
          currentStep = 2;
        } else if (document.data()["height"] == null) {
          currentStep = 3;
        }
        name = document.data()["name"];
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Your Profile"),
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
              "Welcome, $name please provide details below to complete your profile"),
        ),
        Expanded(
          child: Stepper(
            steps: stepper(),
            physics: ClampingScrollPhysics(),
            currentStep: currentStep,
            onStepContinue: next,
            // onStepTapped: (step) => goTo(step),
            // onStepCancel: cancel,
          ),
        ),
      ])),
    );
  }

  List<Step> stepper() {
    List<Step> steps = [
      Step(
        title: const Text('Date Of Birth'),
        isActive: currentStep >= 0,
        // state: StepState.editing,
        content: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Text(selectedDate == null
                    ? "Date Of Birth"
                    : selectedDate.toIso8601String().substring(
                        0, selectedDate.toIso8601String().indexOf("T"))),
              ),
            ),
          ],
        ),
      ),
      Step(
        isActive: currentStep >= 1,
        // state: StepState.editing,
        title: const Text('Gender'),
        content: Column(
          children: <Widget>[
            RadioListTile(
              groupValue: radioItem,
              title: Text('Male'),
              value: 'male',
              onChanged: (val) {
                setState(() {
                  radioItem = val;
                });
              },
            ),
            RadioListTile(
              groupValue: radioItem,
              title: Text('Female'),
              value: 'female',
              onChanged: (val) {
                setState(() {
                  radioItem = val;
                });
              },
            ),
          ],
        ),
      ),
      Step(
        isActive: currentStep >= 2,
        // state: StepState.error,
        title: const Text('Occupation'),
        // subtitle: const Text("Error!"),
        content: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 3),
              child: TextField(
                onChanged: (value) {
                  occupation = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  labelText: "Tell us your occupation",
                  hintText: "",
                ),
              ),
            )
          ],
        ),
      ),
      Step(
        isActive: currentStep >= 3,
        // state: StepState.error,
        title: const Text('Height'),
        // subtitle: const Text("Error!"),
        content: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 3),
              child: TextField(
                onChanged: (value) {
                  height = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  labelText: "How tall are you?",
                  hintText: "How tall are you?",
                ),
                keyboardType: TextInputType.number,
              ),
            )
          ],
        ),
      ),
    ];

    return steps;
  }
}
