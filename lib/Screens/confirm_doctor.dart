import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmDoctor extends StatefulWidget {
  const ConfirmDoctor({Key? key}) : super(key: key);

  @override
  _ConfirmDoctorState createState() => _ConfirmDoctorState();
}

class _ConfirmDoctorState extends State<ConfirmDoctor>
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
    _getBooking();
    Future.delayed(const Duration(seconds: 1), () {
      _getDoctorData();
    });
    //_getDoctorData();
  }

  String _id = "";

  String _doctorSpeciality = "";
  String _doctorExperience = "";
  Future<void> _getDoctorData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(_id)
        .snapshots()
        .listen((event) {
      setState(() {
        _doctorExperience = event.get("experience").toString();
        _doctorSpeciality = event.get("speciality").toString();
      });
    });
  }

  Stream<QuerySnapshot> _getBooking() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection('APPOINTMENTS');

    return mainCollection.snapshots();
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
                    Expanded(
                      child: StreamBuilder(
                        stream: _getBooking(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            return ListView.separated(
                              separatorBuilder: (BuildContext context, index) {
                                return SizedBox(height: width * 0.02);
                              },
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                String docId = snapshot.data!.docs[index].id;
                                String doctorId =
                                    snapshot.data!.docs[index]['doctorId'];
                                String doctorName =
                                    snapshot.data!.docs[index]['doctorName'];
                                String doctorUrl =
                                    snapshot.data!.docs[index]['doctorUrl'];

                                var price = snapshot.data!.docs[index]['price'];
                                _id = doctorId;
                                String patientName =
                                    snapshot.data!.docs[index]['name'];
                                String patientAddress =
                                    snapshot.data!.docs[index]['address'];
                                String symptoms =
                                    snapshot.data!.docs[index]['symptoms'];
                                String patientAppointmentType = snapshot
                                    .data!.docs[index]['appointmentType'];
                                String patientEmail =
                                    snapshot.data!.docs[index]['email'];
                                String patientPhone =
                                    snapshot.data!.docs[index]['phone'];
                                String status =
                                    snapshot.data!.docs[index]['Status'];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    status == "assigned"
                                        ? ListTile(
                                            horizontalTitleGap: 0.0,
                                            contentPadding: EdgeInsets.zero,
                                            minVerticalPadding: 0.0,
                                            leading: SizedBox(
                                              height: width * 0.23,
                                              width: width * 0.23,
                                              // decoration: BoxDecoration(
                                              //     shape: BoxShape.circle,
                                              //     image: DecorationImage(
                                              //         fit: BoxFit.contain,
                                              //         image: NetworkImage(
                                              //           _doctorUrl,
                                              //         ))),
                                              child: Image.network(
                                                doctorUrl,
                                                filterQuality:
                                                    FilterQuality.low,
                                                fit: BoxFit.contain,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Container(
                                                    height: height * 0.2,
                                                    width: width * 0.35,
                                                    alignment: Alignment.center,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: lightpink3,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            title: Text(
                                              doctorName,
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  color: dark),
                                            ),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Fees: ৳$price",
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: width * 0.028,
                                                      color: dark),
                                                ),
                                              ],
                                            ),
                                            trailing: status == "completed"
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.04),
                                                    child: Text(
                                                      "Completed",
                                                      style:
                                                          GoogleFonts.raleway(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  width * 0.035,
                                                              color: dark),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: width * 0.2,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AppointmentBookingDetails(
                                                                            docId:
                                                                                docId,
                                                                            price:
                                                                                double.parse(price),
                                                                            patientPhone:
                                                                                patientPhone,
                                                                            patientEmail:
                                                                                patientEmail,
                                                                            doctorName:
                                                                                doctorName,
                                                                            doctorExperience:
                                                                                _doctorExperience,
                                                                            doctorSpeciality:
                                                                                _doctorSpeciality,
                                                                            doctorUrl:
                                                                                doctorUrl,
                                                                            symptoms:
                                                                                symptoms,
                                                                            patientAddress:
                                                                                patientAddress,
                                                                            patientName:
                                                                                patientName,
                                                                            patientAppointmentType:
                                                                                patientAppointmentType,
                                                                          )));
                                                        },
                                                        icon: Icon(
                                                          Icons.forward_rounded,
                                                          color: dark,
                                                          size: width * 0.08,
                                                        )),
                                                  ),
                                          )
                                        : status == "completed"
                                            ? ListTile(
                                                horizontalTitleGap: 0.0,
                                                contentPadding: EdgeInsets.zero,
                                                minVerticalPadding: 0.0,
                                                leading: SizedBox(
                                                  height: width * 0.23,
                                                  width: width * 0.23,
                                                  // decoration: BoxDecoration(
                                                  //     shape: BoxShape.circle,
                                                  //     image: DecorationImage(
                                                  //         fit: BoxFit.contain,
                                                  //         image: NetworkImage(
                                                  //           _doctorUrl,
                                                  //         ))),
                                                  child: Image.network(
                                                    doctorUrl,
                                                    filterQuality:
                                                        FilterQuality.low,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Container(
                                                        height: height * 0.2,
                                                        width: width * 0.35,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          color: lightpink3,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                title: Text(
                                                  doctorName,
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                      color: dark),
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Fees: ৳$price",
                                                      style:
                                                          GoogleFonts.raleway(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  width * 0.028,
                                                              color: dark),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.04),
                                                  child: Text(
                                                    "Completed",
                                                    style: GoogleFonts.raleway(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: width * 0.035,
                                                        color: dark),
                                                  ),
                                                ))
                                            : Container(),
                                  ],
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
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
