import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
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
              // unselectedLabelColor: grey,
              controller: _tabController,
              indicatorColor: lightpurple,
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Home()));
                    },
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
          drawer: const Drawers(),
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
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "ABOUT US",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Dynamic is an online Health Solution app (Telemedicine) where patients can get 24/7 doctor consultation on video call. We have many qualified specialist doctors in our app along with that we have few in house doctors to provide medical consultation round the clock. Beside online consultation service we are providing send doctor facilities (Sending Doctor at your home) within very short time. Patient can also order medicine through our app to get medicine home delivery within very short time. We are also providing various authentic health care product at a  very reasonable price. Dynamic uses 256 bit encryption to make video calls between doctor and patient to do the consultation.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We are providing post paid service (take consultation first then pay) for consultation with in house Doctors. Patients can keep their previous consultation history and view online prescriptions. Doctors can join our platform from anywhere using our simple process. We verify every doctor to make sure only BMDC authorized doctors are providing consultation using the latest technology. Here patients can search for doctors as per category and they can see who are at online and get immediate consultation and can also take pre booking for doctors not available at online. We will add more specialist doctors into the platform. The consultation fee is defined by each doctor but for consultation with our in house doctor it is always very reasonable.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We are willing to provide treatment to everyone through our App. We have also arranged facilities for the persons who can’t use app. To provide treatment to them we are opening Dynamic Healing Point at various local pharmacy. From where pharmacy owners will work as a bridge between patient and App.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Key features of the app:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  BulletText(
                    width: width,
                    text: "Search Doctor (See all of our enlisted Doctors)",
                  ),
                  BulletText(
                    width: width,
                    text: "Send Doctor (Get Doctor support at you home)",
                  ),
                  BulletText(
                    width: width,
                    text: "Order Medicine",
                  ),
                  BulletText(
                    width: width,
                    text: "See Nearby Hospital",
                  ),
                  BulletText(
                    width: width,
                    text: "See Nearby Pharmacy",
                  ),
                  BulletText(
                    width: width,
                    text: "Health Care Product",
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Key features of Doctor module:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  BulletText(
                    width: width,
                    text: "Quick registration process",
                  ),
                  BulletText(
                    width: width,
                    text: "Full control on setting own consultation fees",
                  ),
                  BulletText(
                    width: width,
                    text: "Video consultation (256 bit encrypted)",
                  ),
                  BulletText(
                    width: width,
                    text: "Weekly payments out to Internet Banking, Mobile.",
                  ),
                  BulletText(
                    width: width,
                    text: "Flexible consultation time",
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Key features of Agent (Pharmacy Owner) module:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  BulletText(
                    width: width,
                    text: "Get available doctor for video consultation",
                  ),
                  BulletText(
                    width: width,
                    text: "Get order of medicine",
                  ),
                  BulletText(
                    width: width,
                    text: "Get Special discount ",
                  ),
                  BulletText(
                    width: width,
                    text: "Get instant payment",
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
