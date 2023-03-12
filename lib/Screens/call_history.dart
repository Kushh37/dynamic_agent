import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_agent/Screens/prescription/view_prescription_custom.dart';
import 'package:dynamic_agent/Screens/prescription/view_prescription_generated.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  @override
  _CallHistoryScreenState createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen>
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
    // showNotification();
  }

  void showNotification() {
    // setState(()
    //   _counter++;
    // });
    // flutterLocalNotificationsPlugin.show(
    //     0,
    //     "Connect Doctor",
    //     "Doctor is about to start video call.",
    //     NotificationDetails(
    //         android: AndroidNotificationDetails(
    //             channel.id, channel.name, channel.description,
    //             importance: Importance.high,
    //             color: dark,
    //             playSound: true,
    //             icon: '@mipmap/launcher_icon')));
  }

  // showNotification();
  // var androidInitilize =
  //     new AndroidInitializationSettings('@mipmap/launcher_icon');
  // var iOSinitilize = new IOSInitializationSettings();
  // var initilizationsSettings = new InitializationSettings(
  //     android: androidInitilize, iOS: iOSinitilize);
  // fltrNotification = new FlutterLocalNotificationsPlugin();
  // fltrNotification.initialize(initilizationsSettings,
  //     onSelectNotification: notificationSelected);

  // ////
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             channel.description,
  //             color: Colors.blue,
  //             playSound: true,
  //             icon: '@mipmap/launcher_icon',
  //           ),
  //         ));
  //   }
  // });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('A new onMessageOpenedApp event was published!');
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     showDialog(
  //         context: context,
  //         builder: (_) {
  //           return AlertDialog(
  //             title: Text(notification.title!),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [Text(notification.body!)],
  //               ),
  //             ),
  //           );
  //         });
  //   }
  // });
  Future<void> _sendStatus(
      {required bookingId, required doctorId, required status}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    Map<String, dynamic> data = ({
      "status": status,
    });

    await FirebaseFirestore.instance
        .collection("BOOKING")
        .doc(bookingId)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(bookingId)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(doctorId)
        .collection("BOOKINGS")
        .doc(bookingId)
        .set(data, SetOptions(merge: true));
    // print(_name);

    //print("User id: $user");
  }

  Future<void> sslCommerzGeneralCall(
      {patientName, patientEmail, patientAddress, patientPhone, price}) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
      //Use the ipn if you have valid one, or it will fail the transaction.
      //   ipn_url: "www.ipnurl.com",
      multi_card_name: 'visa,master,bkash',
      currency: SSLCurrencyType.BDT,
      product_category: "Consultancy",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: 'Dynamic',
      store_passwd: '61371C2BAF4AE37538',
      total_amount: double.parse(price),
      tran_id: "1231321321321312",
    ));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: patientName,
            customerEmail: patientEmail,
            customerAddress1: patientAddress,
            customerCity: patientAddress,
            customerPostCode: "123123",
            customerState: "",
            customerCountry: "",
            customerPhone: patientPhone));
    // sslcommerz.payNow();

    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.status.toString() +
          " code: " +
          result.status.toString());
    } else {
      SSLCTransactionInfoModel model = result;
    }
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

  Stream<QuerySnapshot> _getBooking() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    final CollectionReference _mainCollection = FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection('BOOKINGS');

    return _mainCollection.snapshots();
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
                                String patientName =
                                    snapshot.data!.docs[index]['patientName'];
                                String patientAddress =
                                    snapshot.data!.docs[index]['city'];
                                String patientGender =
                                    snapshot.data!.docs[index]['gender'];
                                String symptoms =
                                    snapshot.data!.docs[index]['symptoms'];

                                String doctorLocation = snapshot
                                    .data!.docs[index]['doctorLocation'];
                                String doctorSpeciality = snapshot
                                    .data!.docs[index]['doctorSpeciality'];

                                String bookingId =
                                    snapshot.data!.docs[index].id;

                                String doctorName =
                                    snapshot.data!.docs[index]['doctorName'];
                                String bookingDetails = snapshot
                                    .data!.docs[index]['bookingDetails'];

                                String url =
                                    snapshot.data!.docs[index]['doctorUrl'];
                                String prescriptionStatus = snapshot
                                    .data!.docs[index]['prescriptionStatus'];
                                String prescriptionUrl = snapshot
                                    .data!.docs[index]['prescriptionUrl'];
                                String prescriptionType = snapshot
                                    .data!.docs[index]['prescriptionType'];
                                String patientId =
                                    snapshot.data!.docs[index]['patientId'];
                                String patientImage =
                                    snapshot.data!.docs[index]['patientImage'];
                                String patientEmail =
                                    snapshot.data!.docs[index]['patientEmail'];
                                String enableStatus =
                                    snapshot.data!.docs[index]['status'];
                                String doctorId =
                                    snapshot.data!.docs[index]['doctorId'];
                                String type =
                                    snapshot.data!.docs[index]['type'];
                                String registration = snapshot.data!.docs[index]
                                    ['doctorregistration'];
                                var totalAmount =
                                    snapshot.data!.docs[index]['totalAmount'];
                                String patientAge =
                                    snapshot.data!.docs[index]['age'];
                                // String channelToken = snapshot
                                //     .data!.docs[index]['channelToken'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      horizontalTitleGap: 0.0,
                                      contentPadding: EdgeInsets.zero,
                                      minVerticalPadding: 0.0,
                                      leading: Container(
                                        height: width * 0.23,
                                        width: width * 0.23,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                  url,
                                                ))),
                                        child: null,
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
                                            bookingDetails,
                                            style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.w600,
                                                fontSize: width * 0.025,
                                                color: dark),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          prescriptionStatus == "Uploaded"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (prescriptionType ==
                                                        "write") {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewPrescriptionGen(
                                                                    patientName:
                                                                        patientName,
                                                                    patientAge:
                                                                        patientAge,
                                                                    patientGender:
                                                                        patientGender,
                                                                    speciality:
                                                                        doctorSpeciality,
                                                                    route:
                                                                        "patient",
                                                                    docName:
                                                                        doctorName,
                                                                    registration:
                                                                        registration,
                                                                    bookingid:
                                                                        bookingId,
                                                                    prescriptionUrl:
                                                                        prescriptionUrl,
                                                                  )));
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewPrescriptionCustom(
                                                                      route:
                                                                          "patient",
                                                                      url:
                                                                          prescriptionUrl)));
                                                    }
                                                  },
                                                  child: Text(
                                                    'View Prescription',
                                                    style: GoogleFonts.raleway(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: width * 0.025,
                                                        color: dark),
                                                  ),
                                                )
                                              : prescriptionStatus ==
                                                          "Pending" ||
                                                      enableStatus == "unpaid"
                                                  ? const SizedBox(width: 0.01)
                                                  : const SizedBox(
                                                      width: 0.01,
                                                    ),
                                        ],
                                      ),
                                      trailing: enableStatus == "completed" ||
                                              enableStatus == "paid"
                                          ? Text(
                                              'Completed',
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width * 0.025,
                                                  color: dark),
                                            )
                                          : enableStatus == "active"
                                              ? SizedBox(
                                                  width: width * 0.2,
                                                  child: IconButton(
                                                    iconSize: width * 0.1,
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return CallPage(
                                                          doctorregistration:
                                                              registration,
                                                          doctorLocation:
                                                              doctorLocation,
                                                          doctorProfileUrl: url,
                                                          price: totalAmount,
                                                          type: type,
                                                          doctorId: doctorId,
                                                          bookingDetails:
                                                              bookingDetails,
                                                          bookingId: bookingId,
                                                          patientEmail:
                                                              patientEmail,
                                                          patientid: patientId,
                                                          route: "patient",
                                                          doctorName:
                                                              doctorName,
                                                          doctorSpeciality:
                                                              doctorSpeciality,
                                                          patientCity:
                                                              patientAddress,
                                                          patientName:
                                                              patientName,
                                                          // channelName:
                                                          //     channelName,
                                                          // channelToken:
                                                          //     channelToken,
                                                          // role: ClientRole
                                                          //     .Broadcaster,
                                                        );
                                                      }));
                                                    },
                                                    icon: Container(
                                                      width: width * 0.2,
                                                      height: width * 0.2,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .video_camera,
                                                        color: Colors.white,
                                                        size: width * 0.08,
                                                      ),
                                                    ),
                                                  ))
                                              : enableStatus == "unpaid"
                                                  ? ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(
                                                                      lightpurple)),
                                                      onPressed: () {
                                                        sslCommerzGeneralCall(
                                                                patientAddress:
                                                                    patientAddress,
                                                                patientEmail:
                                                                    patientEmail,
                                                                patientName:
                                                                    patientName,
                                                                // patientPhone:
                                                                //     patientPhone,
                                                                price: double.parse(
                                                                    totalAmount
                                                                        .toString()))
                                                            .whenComplete(() =>
                                                                _sendStatus(
                                                                    bookingId:
                                                                        bookingId,
                                                                    doctorId:
                                                                        doctorId,
                                                                    status:
                                                                        "paid"));
                                                      },
                                                      child: Text(
                                                        "Pay",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    width *
                                                                        0.04),
                                                      ))
                                                  : IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          // print("Day: $monday");

                                                          return BookingInfo(
                                                            patientImage:
                                                                patientImage,
                                                            patientName:
                                                                patientName,
                                                            patientAddress:
                                                                patientAddress,
                                                            patientGender:
                                                                patientGender,
                                                            doctorName:
                                                                doctorName,
                                                            doctorLocation:
                                                                doctorLocation,
                                                            doctorSpeciality:
                                                                doctorSpeciality,
                                                            bookingDetails:
                                                                bookingDetails,
                                                            bookingId:
                                                                bookingId,
                                                            symptoms: symptoms,
                                                            url: url,
                                                          );
                                                        }));
                                                      },
                                                      icon: Icon(
                                                        CupertinoIcons.info,
                                                        color: dark,
                                                        size: width * 0.08,
                                                      ),
                                                    ),
                                    ),
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
