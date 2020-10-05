import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photos/screens/home_screen.dart';
import 'package:photos/screens/login_screen.dart';
import 'package:photos/screens/profile_completion_screen.dart';
import 'package:photos/screens/signup_screen.dart';
import 'package:photos/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ProfileCompletionScreen.id: (context) => ProfileCompletionScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        HomeScreen.id: (context) => HomeScreen()
      },
    );
  }
}
