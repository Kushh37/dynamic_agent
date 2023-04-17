import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

import 'package:url_launcher/url_launcher.dart';

class DoctorProfile extends StatefulWidget {
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

  const DoctorProfile(
      {Key? key,
      required this.id,
      required this.name,
      required this.speciality,
      required this.experience,
      required this.registration,
      required this.location,
      required this.fullInfo,
      required this.price,
      required this.fullExperience,
      required this.profileUrl})
      : super(key: key);

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tab1Controller;

  double _rating = 1.0;
  final TextEditingController _reviews = TextEditingController();
  var status = true;
  Stream<QuerySnapshot> _getReviews() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(widget.speciality)
        .collection("DOCTORS")
        .doc(widget.id)
        .collection('REVIEWS');

    return mainCollection.snapshots();
  }

  String _name = "";
  Future<void> _getCurrentUser() async {
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
        print(_name);
      });
    });
  }

  Future<void> _addReviews() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var userDoc = auth.currentUser!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(widget.speciality)
        .collection("DOCTORS")
        .doc(widget.id)
        .collection('REVIEWS');

    Map<String, dynamic> data = <String, dynamic>{
      "name": _name,
      "ratings": _rating,
      "reviews": _reviews.text,
    };

    await mainCollection
        .doc(userDoc)
        .set(data, SetOptions(merge: true))
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review Added Successfully.'))))
        .catchError((e) => print(e));
  }

  // Future<void> _getDetails() async {
  //   // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //   FirebaseFirestore.instance
  //       .collection("DOCTORS")
  //       .doc("bN8Mt2FIkpm9bPv2zlGI")
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       _bio = event.get("bio").toString();
  //       _category = event.get("category").toString();
  //       _name = event.get("name").toString();
  //       _rating = event.get("rating").toString();
  //       _reviews = event.get("reviews").toString();
  //       print("bio: " + _bio.toString());
  //       print("name: " + _name.toString());
  //       print("category: " + _category.toString());
  //       print("rating: " + _rating.toString());
  //       print("reviews: " + _reviews.toString());
  //     });
  //   });
  // }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tab1Controller = TabController(length: 3, vsync: this, initialIndex: 0);
    _getCurrentUser();
    //_getDetails();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          child: Stack(
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
              SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(width * 0.035),
                          height: height * 0.22,
                          child: _details(width, height),
                        ),
                        SizedBox(width: width * 0.02),
                        _experienceBar(width),
                        SizedBox(height: width * 0.02),
                        SizedBox(height: height * 0.03),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          width: width,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(lightpurple)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BookingDoctorScreen(
                                        price: widget.price,
                                        id: widget.id,
                                        name: widget.name,
                                        speciality: widget.speciality,
                                        experience: widget.experience,
                                        registration: widget.registration,
                                        location: widget.location,
                                        fullInfo: widget.fullInfo,
                                        fullExperience: widget.fullExperience,
                                        profileUrl: widget.profileUrl)));
                              },
                              child: Text(
                                'Book Appointment',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: height * 0.026,
                                    color: Colors.white),
                              )),
                        ),
                        SizedBox(height: height * 0.01),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              child: TabBar(
                                controller: _tabController,
                                indicatorWeight: 3,
                                indicatorColor: grey,
                                tabs: [
                                  Tab(
                                      child: Text(
                                    'Info',
                                    style: GoogleFonts.raleway(
                                        fontSize: height * 0.018,
                                        fontWeight: FontWeight.w600,
                                        color: grey),
                                  )),
                                  Tab(
                                      child: Container(
                                    child: Text(
                                      'Experience',
                                      style: GoogleFonts.raleway(
                                          fontSize: height * 0.018,
                                          fontWeight: FontWeight.w600,
                                          color: grey),
                                    ),
                                  )),
                                  Tab(
                                      child: Text(
                                    'Reviews',
                                    style: GoogleFonts.raleway(
                                        fontSize: height * 0.018,
                                        fontWeight: FontWeight.w600,
                                        color: grey),
                                  )),
                                ],
                              ),
                            ),
                            Divider(
                                height: 0,
                                indent: width * 0.038,
                                endIndent: width * 0.038,
                                color: grey),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        width: width,
                        child:
                            TabBarView(controller: _tabController, children: [
                          _info(height),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Experience',
                                style: GoogleFonts.raleway(
                                    fontSize: height * 0.024,
                                    fontWeight: FontWeight.bold,
                                    color: grey),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                widget.fullExperience,
                                style: GoogleFonts.raleway(
                                    fontSize: height * 0.019,
                                    fontWeight: FontWeight.w600,
                                    color: grey2),
                              ),
                            ],
                          ),
                          //SizedBox(height: height * 0.02),
                          _review(width, height),
                        ]),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _review(double width, double height) {
    return Column(
      children: [
        Column(
          children: [
            TextFormField(
              controller: _reviews,
              keyboardType: TextInputType.name,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color: dark,
                  fontSize: width * 0.04),
              decoration: InputDecoration(
                labelText: 'Write Review',
                labelStyle: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    color: dark,
                    fontSize: width * 0.04),
                filled: true,
                fillColor: dark.withOpacity(0.1),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: dark),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusColor: purple,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightpurple, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: dark),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: width * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                      print(rating);
                    },
                  ),
                  SizedBox(
                    height: width * 0.12,
                    child: MaterialButton(
                        elevation: 0.0,
                        color: lightpurple,
                        onPressed: () async {
                          _addReviews();
                          _reviews.clear();
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: height * 0.025),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: width * 0.04),
        Expanded(
          child: SizedBox(
            width: width,
            height: height,
            child: StreamBuilder(
              stream: _getReviews(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  //print(snapshot.data.toString());
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, index) {
                      return SizedBox(height: width * 0.02);
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      // String docId = snapshot.data!.docs[index]['email'];

                      String name = snapshot.data!.docs[index]['name'];
                      String review = snapshot.data!.docs[index]['reviews'];
                      double rating =
                          snapshot.data!.docs[index]["ratings"].toDouble();

                      return Container(
                        color: lightpink.withOpacity(0.2),
                        width: width,
                        // padding: EdgeInsets.only(top: width * 0.01),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: width * 0.02),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: grey2),
                              ),
                              child: CircleAvatar(
                                backgroundColor: lightpink,
                                radius: width * 0.08,
                                child: Icon(
                                  CupertinoIcons.person_alt,
                                  color: dark,
                                  size: width * 0.1,
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.04),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.raleway(
                                            color: dark,
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        "",
                                        style: GoogleFonts.raleway(
                                            color: dark,
                                            fontSize: width * 0.03,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width * 0.01),
                                  RatingBarIndicator(
                                    rating: rating.toDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: width * 0.03,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(width: width * 0.01),
                                  Text(
                                    review,
                                    style: GoogleFonts.raleway(
                                        color: grey2,
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator(
                  color: dark,
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: width * 0.02,
        ),
      ],
    );
  }

  _details(double width, double height) {
    return Row(
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
                Expanded(
                  child: SizedBox(
                    width: width * 0.5,
                    height: height,
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

                                double rating = snapshot
                                    .data!.docs[index]["ratings"]
                                    .toDouble();
                                return Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    Text(
                                        "(${snapshot.data!.docs.length.toString()} Reviews)")
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _experienceBar(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Total Experience',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 14, color: grey),
                ),
                SizedBox(width: width * 0.01),
                Text(
                  '${widget.experience}+ Years',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold, fontSize: 18, color: grey),
                ),
              ],
            ),
          ),
          DottedLine(
            dashLength: 3,
            dashGapLength: 3,
            lineThickness: 2,
            dashColor: grey,
            //dashGapColor: Colors.red,
            direction: Axis.vertical,
            lineLength: width * 0.12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Rating',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 14, color: grey),
                ),
                SizedBox(width: width * 0.01),
                SizedBox(
                  // height: width * 0.1,
                  width: width * 0.5,
                  child: StreamBuilder(
                    stream: _getReviews(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        //print(snapshot.data.toString());
                        return SizedBox(
                          height: width * 0.05,
                          width: width,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              // String docId = snapshot.data!.docs[index]['email'];

                              double rating = snapshot
                                  .data!.docs[index]["ratings"]
                                  .toDouble();

                              return Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RatingBarIndicator(
                                    rating: rating.toDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: width * 0.03,
                                    direction: Axis.horizontal,
                                  ),
                                  Text(
                                      "(${snapshot.data!.docs.length.toString()})")
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
          DottedLine(
            dashLength: 3,
            dashGapLength: 3,
            lineThickness: 2,
            dashColor: grey,
            //dashGapColor: Colors.red,
            direction: Axis.vertical,
            lineLength: width * 0.12,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'registration Number',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600, fontSize: 14, color: grey),
                ),
                SizedBox(width: width * 0.01),
                Text(
                  widget.registration,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 16, color: grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _info(double height) {
    return ListView(
      children: [
        Text(
          'Info',
          style: GoogleFonts.raleway(
              fontSize: height * 0.024,
              fontWeight: FontWeight.bold,
              color: grey),
        ),
        SizedBox(height: height * 0.01),
        Text(
          widget.fullInfo,
          style: GoogleFonts.raleway(
              fontSize: height * 0.019,
              fontWeight: FontWeight.w600,
              color: grey2),
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }
}
