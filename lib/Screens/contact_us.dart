import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
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
          drawer: Drawers(),
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
          body: Container(
            margin: EdgeInsets.all(width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "CONTACT US",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: dark,
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Phone: 06352192149",
                  style: TextStyle(
                      color: dark,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: width * 0.02),
                Text(
                  "Mail: info@humbingo.com",
                  style: TextStyle(
                      color: dark,
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )),
    );
  }
}
