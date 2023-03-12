import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/ManagePatients/patients.dart';
import 'package:dynamic_agent/Screens/prescription/previous_prescription.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:dynamic_agent/Services/auth_provider.dart';
import 'package:dynamic_agent/Auth/login.dart';

class Drawers extends StatefulWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  String _name = "";
  Future<void> _getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .snapshots()
        .listen((event) {
      setState(() {
        _name = event.get("name").toString();
      });
    });
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      width: width * 0.8,
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            leading: Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: Image.asset(
                "assets/profile.png",
                width: width * 0.2,
              ),
            ),
            title: Text(
              _name.toString(),
              style: GoogleFonts.lato(
                  color: grey4,
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.03),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Agent",
                style: GoogleFonts.lato(
                    color: grey4,
                    fontWeight: FontWeight.w500,
                    fontSize: height * 0.024),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.045),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const Home()));
              },
              child: _listTile(height, width, "home", "Home")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const CallHistoryScreen()));
              },
              child: _listTile(height, width, "call", "Call History")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ConfirmDoctor()));
              },
              child: _listTile(height, width, "eye", "Send Doctor History")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const CallHistoryScreen()));
              },
              child: _listTile(height, width, "appointments", "Appointments")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PreviousPrescription()));
              },
              child: _listTile(
                  height, width, "appointments", "Previous Prescriptions")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const Patients()));
            },
            child: _listTile(height, width, "m1", "Manage Patients"),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Settings1()));
              },
              child: _listTile(height, width, "setting", "Settings")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
          GestureDetector(
              onTap: () {
                AuthClass().logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              child: _listTile(height, width, "logout", "Logout")),
          Padding(
            padding: EdgeInsets.only(right: width * 0.12, top: height * 0.02),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }

  Widget _listTile(height, width, String image, String title) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.03,
        ),
        Image.asset(
          "assets/$image.png",
          width: width * 0.045,
        ),
        SizedBox(
          width: width * 0.037,
        ),
        Text(
          title,
          style: GoogleFonts.lato(
              color: grey4,
              fontWeight: FontWeight.w700,
              fontSize: height * 0.024),
        ),
      ],
    );
  }
}
