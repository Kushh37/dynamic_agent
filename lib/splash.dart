import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_agent/Services/firebase_push_notification_services.dart';
import 'package:dynamic_agent/constants.dart';
import 'package:dynamic_agent/Screens/home.dart';
import 'package:dynamic_agent/Auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  late FirebaseNotifcation firebase;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    firebase = FirebaseNotifcation();
    firebase.initialize(context);
    super.initState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (auth.currentUser == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
        }
      },
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/background.jpg'),
          ),
          color: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: height * 0.3),
            Container(
              height: height * 0.15,
              margin: EdgeInsets.symmetric(horizontal: width * 0.1),
              alignment: Alignment.center,
              child: Image.asset("assets/Logofull.png"),
            ),
            SizedBox(height: height * 0.07),
            Center(
                child: Padding(
              padding: EdgeInsets.only(
                left: width * 0.1,
                right: width * 0.1,
              ),
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[400],
                color: dark,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
