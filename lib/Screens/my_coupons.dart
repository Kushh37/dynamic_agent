// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> with SingleTickerProviderStateMixin {
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

  String _code = "";
  String _type = "";
  String _amount = "";
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
        _code = event.get("code").toString();
        _type = event.get("couponType").toString();
        _amount = event.get("amount").toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const Home())),
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
          drawer: Drawers(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: dark),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
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
                          makePhoneCall("06352192149", true);
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
          body: Stack(
            children: [
              Container(
                height: height,
                decoration: const BoxDecoration(
                  color: lightpurple,
                  image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                height: height,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.gift,
                            color: dark,
                            size: width * 0.3,
                          ),
                          SizedBox(height: width * 0.02),
                          Text(
                            _code,
                            style: GoogleFonts.roboto(
                                color: dark,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.06),
                          ),
                          SizedBox(height: width * 0.02),
                          Text(
                            "Use this coupon code to get",
                            style: GoogleFonts.roboto(
                                color: dark,
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.04),
                          ),
                          Text(
                            _type == "Percentage"
                                ? "flat $_amount% off on all orders.Enjoy!!"
                                : "flat ₹$_amount off on all orders.Enjoy!!",
                            style: GoogleFonts.roboto(
                                color: dark,
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.04),
                          ),
                          Text(
                            "Thanks for being a part of Dynamic Family.",
                            style: GoogleFonts.roboto(
                                color: dark,
                                fontWeight: FontWeight.w400,
                                fontSize: width * 0.04),
                          ),
                          SizedBox(height: width * 0.05),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(lightpurple)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Go Back"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

Row details(double width) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        width: width * 0.37,
        child: Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/doctor.jpg',
            height: width * 0.3,
            width: width * 0.3,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. Julien More',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600, fontSize: 24, color: grey),
              ),
              SizedBox(height: width * 0.01),
              Text(
                'Psychiatrist',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600, fontSize: 18, color: grey3),
              ),
              SizedBox(height: width * 0.02),
              Text(
                'Luxembourg Ville - 2Km',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600, fontSize: 18, color: grey3),
              ),
              SizedBox(height: width * 0.02),
              Row(
                children: [
                  Image.asset(
                    'assets/star.png',
                    height: width * 0.04,
                    width: width * 0.04,
                    color: orange,
                  ),
                  SizedBox(width: width * 0.01),
                  Image.asset(
                    'assets/star.png',
                    height: width * 0.04,
                    width: width * 0.04,
                    color: orange,
                  ),
                  SizedBox(width: width * 0.01),
                  Image.asset(
                    'assets/star.png',
                    height: width * 0.04,
                    width: width * 0.04,
                    color: orange,
                  ),
                  SizedBox(width: width * 0.01),
                  Image.asset(
                    'assets/star.png',
                    height: width * 0.04,
                    width: width * 0.04,
                    color: orange,
                  ),
                  SizedBox(width: width * 0.01),
                  Image.asset(
                    'assets/star.png',
                    height: width * 0.04,
                    width: width * 0.04,
                    color: orange,
                  ),
                  SizedBox(width: width * 0.01),
                  Text(
                    '(160)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: grey3),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}
