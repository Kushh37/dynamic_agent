import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  //Sign in with phone

  //Create Account
  Future<String> createUser(String name, String email, String phone,
      String password, String storeName) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      String userdoc = user!.uid;
      await FirebaseFirestore.instance.collection("AGENTS").doc(userdoc).set({
        "email": email,
        "name": name,
        "phone": phone,
        "type": "AGENT",
        "code": "",
        "couponType": "Flat",
        "amount": 0.0,
        "storeName": storeName,
        "age": "NotFound",
        "gender": "Male",
        "profileUrl":
            "https://lh3.googleusercontent.com/a-/AOh14GiaWbgbWtigqnhh0tqhxkqZDRrwssxqDQ1a5_HTFQ=s96-c",
      });
      var fcmToken = fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("AGENTS")
            .doc(userdoc)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      return "Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred";
    }
    return 'Information Required';
  }

  //Sign in user
  Future<String> signIN(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // final cred1 = await auth.signInWithPhoneNumber(phone);
      final user = credential.user;
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection("AGENTS")
          .doc(user?.uid)
          .get();

      var usertype = data["type"];
      var fcmToken = fcm.getToken().then((value) {
        FirebaseFirestore.instance
            .collection("AGENTS")
            .doc(user!.uid)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);

      if (usertype == "AGENT") {
        return "Welcome";
      } else {
        return "NotWelcome";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Try Again';
  }

  //Reset Password
  Future<String> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return "Email sent";
    } catch (e) {
      return "Error occurred";
    }
  }

  //SignOut
  void logOut() async {
    auth.signOut();
  }
}
