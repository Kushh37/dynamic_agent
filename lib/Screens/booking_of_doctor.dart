import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class Day {
  final int id;
  final String day;
  Day({
    required this.id,
    required this.day,
  });
}

class Timing {
  final int id;
  final String time;
  Timing({
    required this.id,
    required this.time,
  });
}

class BookingDoctorScreen extends StatefulWidget {
  final String id;
  final String name;
  final String speciality;

  final String experience;
  final String registration;
  final String location;
  final String fullInfo;
  final String fullExperience;
  final String profileUrl;
  final String price;

  const BookingDoctorScreen(
      {Key? key,
      required this.id,
      required this.price,
      required this.name,
      required this.speciality,
      required this.experience,
      required this.registration,
      required this.location,
      required this.fullInfo,
      required this.fullExperience,
      required this.profileUrl})
      : super(key: key);

  @override
  _BookingDoctorScreenState createState() => _BookingDoctorScreenState();
}

class _BookingDoctorScreenState extends State<BookingDoctorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<QuerySnapshot> _getReviews() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(widget.speciality)
        .collection("DOCTORS")
        .doc(widget.id)
        .collection('REVIEWS');

    return mainCollection.snapshots();
  }

  static List<Day> days = [
    Day(id: 1, day: "Monday"),
    Day(id: 2, day: "Tuesday"),
    Day(id: 3, day: "Wednesday"),
    Day(id: 4, day: "Thursday"),
    Day(id: 5, day: "Friday"),
    Day(id: 6, day: "Saturday"),
    Day(id: 7, day: "Sunday"),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // _getDetails();
    super.initState();
  }

  var selectedDay;
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
      // backgroundColor: Colors.transparent,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.035),
                      height: height * 0.22,
                      child: _details(width, height),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
                SizedBox(height: height * 0.1),
                Text(
                  'Available Timing',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 24, color: dark),
                ),
                SizedBox(height: height * 0.03),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Doctor")
                        .doc(widget.speciality)
                        .collection('DOCTORS')
                        .doc(widget.id)
                        .collection("TIMINGS")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        const Text('Loading');
                      } else {
                        List<DropdownMenuItem> days = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];

                          days.add(
                            DropdownMenuItem(
                              value: snap.id,
                              child: Text(snap.id),
                            ),
                          );
                        }
                        return Container(
                          //width: width * 0.30,
                          child: _counter == 4
                              ? const Text(
                                  "You can book maximum of 3 slots per day.Try again Tommorow.")
                              : DropdownButtonFormField(
                                  onTap: () {
                                    setState(() {
                                      _counter++;
                                      // SharedPreferences prefs =
                                      //     await SharedPreferences
                                      //         .getInstance();
                                      // prefs.setInt('count', _counter);
                                    });
                                    print(_counter);
                                  },
                                  decoration: InputDecoration(
                                    suffixText: '',
                                    labelStyle: GoogleFonts.raleway(
                                        color: Colors.black),
                                    // labelText: label,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple)),
                                  ),
                                  items: days,
                                  //  onChanged: (dynamic selectedValue){},

                                  onChanged: (dynamic selectedValue) {
                                    setState(() {
                                      selectedDay = selectedValue;
                                      print(selectedDay);
                                    });
                                  },
                                  value: selectedDay,
                                  hint: days.isEmpty
                                      ? selectedDay
                                      : Text(
                                          'Select Day',
                                          style: GoogleFonts.ptSans(
                                              textStyle: GoogleFonts.ptSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                ),
                        );
                      }
                      return Container();
                    }),
                SizedBox(height: height * 0.11),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: EditButton(
                        width: width,
                        onTap: () {
                          _counter == 4
                              ? null
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckOutScreen(
                                      bookingId: "",
                                      route: "booking",
                                      price: double.parse(widget.price),
                                      registration: widget.registration,
                                      doctorId: widget.id,
                                      doctorName: widget.name,
                                      doctorUrl: widget.profileUrl,
                                      doctorLocation: widget.location,
                                      doctorSpeciality: widget.speciality,
                                      bookedDateAndTime: selectedDay)));
                        },
                        title: 'Submit')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _details(double width, double height) {
    return Container(
      // height: height * 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 0.22,
            width: width * 0.3,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                widget.profileUrl,
                height: height * 0.22,
                width: width * 0.25,
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
                    widget.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.055,
                        color: grey),
                  ),
                  SizedBox(height: width * 0.001),
                  Text(
                    widget.speciality,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04,
                        color: grey3),
                  ),
                  SizedBox(height: width * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.location,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                            color: grey3),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Text(
                          "Fees: ${widget.price} BDT",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.04,
                              color: grey3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.02),
                  SizedBox(
                    width: width * 0.5,
                    height: width * 0.04,
                    child: StreamBuilder(
                      stream: _getReviews(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          //print(snapshot.data.toString());
                          return SizedBox(
                            width: width,
                            // color: Colors.blue,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                // String docId = snapshot.data!.docs[index]['email'];
                                int count1 = snapshot.data!.docs.length;
                                double rating = snapshot
                                        .data!.docs[index]["ratings"]
                                        .toDouble() ??
                                    0.0;

                                return count1 == 0
                                    ? Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RatingBarIndicator(
                                            rating: 4,
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: width * 0.03,
                                            direction: Axis.horizontal,
                                          ),
                                          const Text("(Reviews)")
                                        ],
                                      )
                                    : Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RatingBarIndicator(
                                            rating: rating.toDouble(),
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: width * 0.03,
                                            direction: Axis.horizontal,
                                          ),
                                          Text("($count1 Reviews)")
                                        ],
                                      );
                              },
                            ),
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
          ),
        ],
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.width,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final double width;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      width: width,
      height: width * 0.1,
      child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              elevation: MaterialStateProperty.all(5),
              backgroundColor: MaterialStateProperty.all(lightpurple)),
          onPressed: () => onTap(),
          child: Text(
            title,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600,
                fontSize: title == "Submit" ? 20 : 14,
                color: Colors.white),
          )),
    );
  }
}
