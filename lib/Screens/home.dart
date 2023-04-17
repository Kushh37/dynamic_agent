import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/ManagePatients/patients.dart';
import 'package:dynamic_agent/Screens/earnings.dart';
import 'package:dynamic_agent/Screens/my_coupons.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: dark),
          centerTitle: true,
          title: SizedBox(
            child: Row(
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
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("SLIDERS")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      const Text('Loading');
                    } else {
                      List totalItems = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];

                        totalItems.add(
                          snap['url'],
                        );
                      }
                      return CarouselSlider(
                        items: totalItems.map((e) {
                          return Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(e),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: height * 0.2,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1200),
                          viewportFraction: 0.8,
                        ),
                      );
                    }
                    return const CircularProgressIndicator(
                      color: dark,
                    );
                  },
                ),
                SizedBox(height: width * 0.005),
                Container(
                  color: Colors.transparent,
                  height: height * 0.62,
                  width: width,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const DoctorList()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'Search Doctors',
                                  image: Image.asset(
                                    'assets/show-doctor.jpeg',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const BookDoctor()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'Send Doctors',
                                  image: Image.asset(
                                    'assets/send-doctor.jpeg',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CallHistoryScreen()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'View Appointments',
                                  image: Image.asset(
                                    'assets/calendar.png',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Patients()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'View Patients',
                                  image: Image.asset(
                                    'assets/team.png',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Coupons()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'My Coupons',
                                  image: Image.asset(
                                    'assets/coupon.png',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Earnings()));
                                },
                                child: KCard(
                                  width: width,
                                  title: 'My Earnings',
                                  image: Image.asset(
                                    'assets/coins.png',
                                    height: width * 0.3,
                                    width: width * 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KCard extends StatelessWidget {
  const KCard({
    Key? key,
    required this.width,
    required this.image,
    required this.title,
  }) : super(key: key);

  final double width;
  final Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: height * 0.01),
      width: width * 0.2,
      height: height * 0.2,
      child: Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: dark, width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: image,
              ),
              SizedBox(height: width * 0.03),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.02,
                      color: dark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
