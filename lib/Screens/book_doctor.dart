import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BookDoctor extends StatefulWidget {
  const BookDoctor({Key? key}) : super(key: key);

  @override
  _BookDoctorState createState() => _BookDoctorState();
}

class _BookDoctorState extends State<BookDoctor>
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
    _getData();
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

  var _consultationValue;
  final List<String> _consultationtype = <String>[
    'New Consultation',
    'Followup Consultation',
    'Show Reports',
    'Others',
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> _formnKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _moreDetailsController = TextEditingController();
  String _name = "";
  String _type = "";
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
        _type = event.get("type").toString();
        print(_name);
      });
    });
  }

  Stream<QuerySnapshot> _getCount() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('APPOINTMENTS');

    return mainCollection.snapshots();
  }

  Future<void> _sendData(appointmentId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance
        .collection("APPOINTMENTS")
        .doc(appointmentId)
        .set({
      "userId": userdoc,
      "name": _nameController.text,
      "email": user.email,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "appointmentType": _consultationValue,
      "symptoms": _symptomsController.text,
      "moreDetails": _moreDetailsController.text,
      "doctorId": "",
      "doctorName": "",
      "price": "0.0",
      "Status": "Pending",
      "doctorUrl": "",
      "type": "AGENT",
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("APPOINTMENTS")
        .doc(appointmentId)
        .set({
      "userId": userdoc,
      "name": _nameController.text,
      "email": user.email,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "appointmentType": _consultationValue,
      "symptoms": _symptomsController.text,
      "moreDetails": _moreDetailsController.text,
      "doctorId": "",
      "doctorName": "",
      "price": "0.0",
      "Status": "Pending",
      "doctorUrl": "",
      "type": "AGENT",
    }, SetOptions(merge: true));
    print(_name);

    print("User id: $user");
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'FoMlSB6ftQg',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawers(),
        bottomNavigationBar: Container(
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
        appBar: AppBar(
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
                      "Hindi",
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: grey4),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ChatSupportScreen()));
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
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              SizedBox(height: width * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        barrierLabel: "Barrier",
                        barrierDismissible: false,
                        transitionDuration: const Duration(milliseconds: 700),
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: width * 0.02,
                                right: width * 0.02,
                                top: height * 0.04,
                                bottom: height * 0.04),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return Container(
                                    color: Colors.black,
                                    height: height,
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: height - height * 0.1,
                                            width: width,
                                            // padding:
                                            //     const EdgeInsets.all(12.0),
                                            child: YoutubePlayer(
                                              controller: _controller,
                                              showVideoProgressIndicator: true,
                                              progressIndicatorColor:
                                                  Colors.amber,
                                              onReady: () {
                                                print("player ready..");
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        transitionBuilder: (_, anim, __, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(0, 1),
                                    end: const Offset(0, 0))
                                .animate(anim),
                            child: child,
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Help',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              fontSize: height * 0.017,
                              color: dark),
                        ),
                        SizedBox(width: width * 0.01),
                        Icon(
                          CupertinoIcons.question_circle,
                          color: dark,
                          size: height * 0.03,
                        ),
                        SizedBox(
                          width: width * 0.04,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                // margin: EdgeInsets.only(left: width * 0.08),
                alignment: Alignment.center,
                child: Text(
                  "Book a Doctor",
                  style: TextStyle(
                      color: dark,
                      fontSize: height * 0.05,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: height * 0.07),
              Form(
                key: _formnKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.067),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Name*',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          filled: true,
                          fillColor: dark.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.067),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Phone No.*',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          filled: true,
                          fillColor: dark.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.067),
                      child: TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Address*',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          filled: true,
                          fillColor: dark.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    selectConsultationType(height, width),
                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.067),
                      child: TextFormField(
                        controller: _symptomsController,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Symptoms',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          filled: true,
                          fillColor: dark.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.06, right: width * 0.067),
                      child: TextFormField(
                        controller: _moreDetailsController,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'More Details',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          filled: true,
                          fillColor: dark.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    SizedBox(
                      width: width,
                      //height: height * 0.1,
                      child: StreamBuilder(
                        stream: _getCount(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            var itemCount = snapshot.data!.docs.length;
                            //print(snapshot.data.toString());
                            return Container(
                              width: width * 0.4,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.08),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              lightpurple)),
                                  onPressed: () {
                                    if (_consultationValue == null ||
                                        _nameController.text.isEmpty ||
                                        _phoneController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Field must not be empty.")));
                                    } else {
                                      var item = itemCount + 1;
                                      _sendData("Appointment000$item");
                                      _showAppointmentDoneDialog(
                                          context, width, height);
                                    }
                                  },
                                  child: Text(
                                    'NEXT',
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w600,
                                        fontSize: height * 0.023,
                                        color: grey),
                                  )),
                            );
                          }
                          return const CircularProgressIndicator(
                            color: dark,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAppointmentDoneDialog(
      BuildContext context, double width, double height) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.06),
                        Image.asset(
                          'assets/check (2).png',
                          height: width * 0.35,
                          width: width * 0.35,
                          color: grey,
                        ),
                        SizedBox(height: height * 0.06),
                        Text(
                          'Booking Successful',
                          style: GoogleFonts.raleway(
                              fontSize: height * 0.032,
                              fontWeight: FontWeight.w700,
                              color: dark),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'We will be sending a\n confirmation shortly',
                          style: GoogleFonts.raleway(
                              fontSize: height * 0.026,
                              fontWeight: FontWeight.w700,
                              color: grey4),
                        ),
                        SizedBox(height: height * 0.03),
                        Container(
                          margin: EdgeInsets.only(
                              left: width * 0.2, right: width * 0.2),
                          width: width * 0.4,
                          height: width * 0.12,
                          child: MaterialButton(
                              elevation: 0.0,
                              color: lightpurple.withOpacity(0.6),
                              onPressed: () async {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (route) => false);
                              },
                              child: Text(
                                'Go Back',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: height * 0.025),
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget selectConsultationType(height, width) {
    return Container(
      margin: EdgeInsets.fromLTRB(width * 0.06, 0.0, width * 0.06, 0.0),
      decoration: BoxDecoration(
        color: dark.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(
          width * 0.025, height * 0.005, width * 0.017, height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.grey[100],
                items: _consultationtype
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: dark),
                          ),
                        ))
                    .toList(),
                onChanged: (selectedtype) {
                  setState(() {
                    _consultationValue = selectedtype;
                  });
                },
                value: _consultationValue,
                hint: Text(
                  "Select Your Type",
                  style: TextStyle(
                    color: dark,
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.025,
                  ),
                ),
                elevation: 0,
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
