import 'dart:io';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPrescriptionGen extends StatefulWidget {
  final String route;
  final String docName;
  final String registration;
  final String bookingid;
  final String speciality;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String prescriptionUrl;
  const ViewPrescriptionGen(
      {Key? key,
      required this.docName,
      required this.route,
      required this.registration,
      required this.speciality,
      required this.patientAge,
      required this.patientGender,
      required this.patientName,
      required this.bookingid,
      required this.prescriptionUrl})
      : super(key: key);

  @override
  _ViewPrescriptionGenState createState() => _ViewPrescriptionGenState();
}

class _ViewPrescriptionGenState extends State<ViewPrescriptionGen>
    with SingleTickerProviderStateMixin {
  // String docname = "Raunak Chatterjee";
  // String registration = "123456";
  // String bookingid = "MH009";
  // var _url =
  //     "https://humbingo.com/doctor/docname/$docname/registration/$registration/bookingid/$bookingid/";
  // var _dwnurl =
  //     "https://api.html2pdfrocket.com/pdf?value=https://humbingo.com/doctor/docname/$docname/registration/$registration/bookingid/$bookingid/&apikey=1f5e1922-0df7-4f38-90cd-212c55a64761";

  final GlobalKey webViewKey = GlobalKey();

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
  void dispose() {
    super.dispose();
  }

  late TabController _tabController;

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
    // var _url =
    //     "https://humbingo.com/doctor/docname/${widget.docName}/registration/${widget.registration}/info/${widget.speciality}/bookingid/${widget.bookingid}/patient/${widget.patientName}/age/${widget.patientAge}/gender/${widget.patientGender}/";
    // var _downloadUrl =
    //     "https://api.apiflash.com/v1/urltoimage?access_key=4e234fbc0223438e80898e7aed298409&format=jpeg&fresh=true&response_type=image&url=$_url&width=700";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        drawer: Drawers(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: dark),
          centerTitle: true,
          title: Container(
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
        bottomNavigationBar: SizedBox(
          height: width * 0.26,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Back to Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark, // background
                    foregroundColor: Colors.white, // foreground
                  ),
                ),
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
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
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
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      // alignment: Alignment.center,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),

                      margin: EdgeInsets.only(
                          left: width * 0.03,
                          right: width * 0.03,
                          top: height * 0.02),
                      height: height * 0.4,
                      width: width * 0.25,
                      child: Image.network(
                        widget.prescriptionUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, child,
                            ImageChunkEvent? loadingProgress) {
                          {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Container(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: lightpink3,
                            ),
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
}
