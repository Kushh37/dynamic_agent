import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/ManagePatients/add_patient.dart';
import 'package:dynamic_agent/Screens/ManagePatients/edit_patient.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class Patients extends StatefulWidget {
  const Patients({Key? key}) : super(key: key);

  @override
  _PatientsState createState() => _PatientsState();
}

class _PatientsState extends State<Patients>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    // _getData();
  }
  //

  static Stream<QuerySnapshot> readItems() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("PATIENTS");

    return mainCollection.snapshots();
  }

  Future<void> _delete({
    required String docId,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("PATIENTS");
    DocumentReference documentReferencer = mainCollection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor Deleted Successfully.'))))
        .catchError((e) => print(e));
  }

  Future<void> _makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }

  String? specialityType;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Drawers(),
      bottomNavigationBar: SizedBox(
        height: width * 0.32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: MaterialStateProperty.all(lightpink2),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddPatient(
                              route: "addPatient",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: width * 0.08),
                      Text(
                        "Add Patient",
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                    ],
                  )),
            ),
            Container(
              decoration: const BoxDecoration(
                color: lightpurple,
              ),
              child: TabBar(
                //unselectedLabelColor: grey,
                controller: _tabController,
                indicatorColor: lightpurple,
                tabs: [
                  Tab(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Home(),
                      )),
                      child: const Icon(
                        Icons.home_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CallHistoryScreen(),
                      ));
                    },
                    child: const Tab(
                      child: Icon(
                        Icons.history,
                        size: 30,
                      ),
                    ),
                  ),
                  Tab(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Settings1(),
                        ));
                      },
                      child: const Icon(
                        Icons.settings,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: dark),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: width * 0.07,
              width: width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: lightpurple2,
              ),
              child: Center(
                child: Text(
                  "English",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.02,
                      color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                languageHindi(context, width, height);
              },
              child: Container(
                height: width * 0.07,
                width: width * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: dark,
                ),
                child: Center(
                  child: Text(
                    "Bengali",
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.02,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChatSupportScreen()));
            },
            child: Image.asset(
              "assets/b1.png",
              width: width * 0.05,
            ),
          ),
          SizedBox(
            width: width * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Alert(
                context: context,
                type: AlertType.success,
                // title: "RFLUTTER ALERT",
                desc: "Do you want to make a phone call to our support?",
                buttons: [
                  DialogButton(
                    onPressed: () {
                      _makePhoneCall("06352192149", true);
                    },
                    color: lightpurple2,
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  DialogButton(
                    onPressed: () => Navigator.pop(context),
                    color: lightpurple2,
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ).show();
            },
            child: Image.asset(
              "assets/p1.png",
              width: width * 0.05,
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: width * 0.02),
        child: StreamBuilder(
          stream: readItems(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
              return SizedBox(
                // color: Colors.red,
                height: height,
                width: width,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: height * 0.01,
                  ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String docId = snapshot.data!.docs[index].id;

                    String name = snapshot.data!.docs[index]['name'];
                    String city = snapshot.data!.docs[index]['city'];

                    specialityType = city;
                    //var data = snapshot.data;
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                      ),
                      // height: height,
                      width: width,
                      child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: lightpink3,
                          horizontalTitleGap: 0.0,
                          title: Text(
                            name,
                            style: GoogleFonts.raleway(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            city,
                            style: GoogleFonts.lato(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: SizedBox(
                            width: width * 0.25,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => EditPatient(
                                                    docId: docId,
                                                  )));
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.eye,
                                      color: dark,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _delete(docId: docId);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: dark,
                                    )),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          },
        ),
      ),
    );
  }
}
