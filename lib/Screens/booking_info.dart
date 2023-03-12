import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingInfo extends StatefulWidget {
  final String patientName;
  final String patientAddress;
  final String patientGender;
  final String doctorName;
  final String doctorLocation;
  final String doctorSpeciality;
  final String bookingDetails;
  final String bookingId;
  final String symptoms;
  final String url;
  final String patientImage;

  const BookingInfo(
      {Key? key,
      required this.patientName,
      required this.patientAddress,
      required this.patientGender,
      required this.doctorName,
      required this.doctorLocation,
      required this.doctorSpeciality,
      required this.bookingDetails,
      required this.bookingId,
      required this.url,
      required this.patientImage,
      required this.symptoms})
      : super(key: key);

  @override
  _BookingInfoState createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo>
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        body: ListView(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.03),
                  // alignment: Alignment.center,
                  child: Text(
                    "Patient Information",
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Flexible(
                  child: Container(),
                ),
                Container(
                  margin: EdgeInsets.only(right: width * 0.03),
                  // alignment: Alignment.center,
                  child: Text(
                    "Doctor Information",
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: lightpurple,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      margin: EdgeInsets.only(left: width * 0.03),
                      height: height * 0.13,
                      width: width * 0.44,
                      child: ListTile(
                        subtitle: Container(
                          padding: EdgeInsets.only(left: width * 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                widget.patientGender,
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w800,
                                    fontSize: height * 0.017,
                                    color: grey),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                widget.patientAddress,
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w800,
                                    fontSize: height * 0.015,
                                    color: grey),
                              ),
                            ],
                          ),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(left: width * 0.13),
                          child: Text(
                            widget.patientName,
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                fontSize: height * 0.02,
                                color: dark),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.patientImage,
                        width: width * 0.16,
                        height: height * 0.13,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                _cardtile(
                  height,
                  width,
                  widget.doctorName,
                  widget.url,
                  widget.doctorSpeciality,
                  widget.doctorLocation,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.04),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Booking ID:",
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.bookingId,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.04),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date and Time:",
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.bookingDetails,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              margin: EdgeInsets.only(left: width * 0.04),
              alignment: Alignment.centerLeft,
              child: Text(
                "Symptoms:",
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.035,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: width * 0.035, right: width * 0.03),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.symptoms,
                style: TextStyle(
                    color: dark,
                    fontSize: height * 0.022,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: height * 0.06),
            Container(
              margin: EdgeInsets.only(left: width * 0.25, right: width * 0.25),
              width: width * 0.4,
              height: width * 0.12,
              child: MaterialButton(
                elevation: 0.0,
                color: lightpink.withOpacity(0.3),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Future.delayed(Duration(seconds: 2), () {
                  //   Navigator.of(context)
                  //       .push(MaterialPageRoute(builder: (context) => Home()));
                  // });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.01),
                    Text(
                      'Go Back',
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w800,
                          fontSize: height * 0.03,
                          color: dark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardtile(height, width, title, img, gender, address) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: lightpurple,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          margin: EdgeInsets.only(left: width * 0.03),
          height: height * 0.13,
          width: width * 0.44,
          child: ListTile(
            subtitle: Container(
              padding: EdgeInsets.only(left: width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    gender,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.017,
                        color: grey),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    address,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.015,
                        color: grey),
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: width * 0.13),
              child: Text(
                '$title',
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w800,
                    fontSize: height * 0.02,
                    color: dark),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            '$img',
            width: width * 0.16,
            height: height * 0.13,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
