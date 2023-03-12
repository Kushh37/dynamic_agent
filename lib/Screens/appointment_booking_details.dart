import 'dart:ui';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_agent/Screens/screens.dart';

import 'package:url_launcher/url_launcher.dart';

class AppointmentBookingDetails extends StatefulWidget {
  final String doctorName;
  final String docId;
  final String doctorSpeciality;

  final String symptoms;

  final String doctorUrl;
  final String doctorExperience;
  final String patientName;
  final String patientAddress;
  final String patientAppointmentType;
  final String patientEmail;
  final String patientPhone;
  final double price;

  const AppointmentBookingDetails({
    Key? key,
    required this.docId,
    required this.doctorName,
    required this.price,
    required this.doctorExperience,
    required this.doctorSpeciality,
    required this.doctorUrl,
    required this.patientAddress,
    required this.patientAppointmentType,
    required this.patientName,
    required this.symptoms,
    required this.patientEmail,
    required this.patientPhone,
  }) : super(key: key);

  @override
  _AppointmentBookingDetailsState createState() =>
      _AppointmentBookingDetailsState();
}

class _AppointmentBookingDetailsState extends State<AppointmentBookingDetails>
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
    _getUserData().then((value) {
      return Future.delayed(const Duration(seconds: 1), () {
        typePercentage(widget.price);
        typeFlat(widget.price);
      });
    });
  }

  String _code = "";
  String _type = "";
  double _couponAmount = 0.0;

  Future<void> _getUserData() async {
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
        _couponAmount = event.get("amount").toDouble();

        print(_code);
        print(_couponAmount);
      });
    });
  }

  String typePercentage(amount) {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    discount = amount * _couponAmount / 100;
    discount = amount - discount;
    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  String typePercentageDiscount(amount) {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    discount = amount * _couponAmount / 100;
    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  String typeFlat(amount) {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    discount = amount - discount;
    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  String typeFlatDiscountAmount() {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    returnStr = discount.toStringAsFixed(2);
    return returnStr;
  }

  Future<void> sslCommerzCustomizedCall1() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
      //Use the ipn if you have valid one, or it will fail the transaction.
      //ipn_url: "www.ipnurl.com",
      multi_card_name: 'visa,master,bkash',
      currency: SSLCurrencyType.BDT,
      product_category: "Consultancy",
      sdkType: SSLCSdkType.TESTBOX,
      store_id: 'Dynamic',
      store_passwd: '61371C2BAF4AE37538',
      total_amount: _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      tran_id: "1231321321321312",
    ));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: widget.patientName.toString(),
            customerEmail: widget.patientEmail.toString(),
            customerAddress1: widget.patientAddress.toString(),
            customerCity: "",
            customerPostCode: "",
            customerState: "",
            customerCountry: "",
            customerPhone: widget.patientPhone.toString()));
    // sslcommerz.payNow();

    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("the response is: " +
              result.status.toString() +
              " code: " +
              result.status.toString())));
      print("the response is: " +
          result.status.toString() +
          " code: " +
          result.status.toString());
    } else {
      SSLCTransactionInfoModel model = result;
      Fluttertoast.showToast(
          msg: "Transaction successful: Amount ${model.amount} TK",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _update() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userdoc = auth.currentUser!.uid;
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('APPOINTMENTS');
    final CollectionReference mainCollection1 = FirebaseFirestore.instance
        .collection('AGENTS')
        .doc(userdoc)
        .collection("APPOINTMENTS");

    Map<String, dynamic> data = <String, dynamic>{
      "Status": "completed",
      "doctorName": widget.doctorName,
    };

    await mainCollection.doc(widget.docId).set(data, SetOptions(merge: true));
    await mainCollection1.doc(widget.docId).set(data, SetOptions(merge: true));

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("EARNINGS")
        .doc()
        .set({
      "bookingId": "A001",
      "date": DateTime.utc(now.year, now.month, now.day),
      "amount": _type == "Percentage"
          ? double.parse(typePercentageDiscount(widget.price))
          : double.parse(typeFlatDiscountAmount()),
    }, SetOptions(merge: true));
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
                                widget.patientAppointmentType,
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
                    Container(
                      width: width * 0.16,
                      height: height * 0.13,
                      decoration: BoxDecoration(
                        color: grey3.withOpacity(1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        CupertinoIcons.person_alt,
                        size: width * 0.1,
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
                ),
              ],
            ),
            SizedBox(
              height: height * 0.1,
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
                onPressed: () async {
                  // sslCommerzCustomizedCall();
                  await sslCommerzCustomizedCall1().then((value) {
                    setState(() {
                      _update();
                      showAppointmentDoneDialog(context, width, height);
                    });
                  });
                  Navigator.of(context).pop();
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Home()));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: width * 0.01),
                    Text(
                      'Book Now',
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

  showAppointmentDoneDialog(
    BuildContext context,
    double width,
    double height,
  ) {
    return showGeneralDialog(
        context: context,
        //barrierDismissible: true,
        // barrierLabel:
        //     MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.2),
                        Image.asset(
                          'assets/like (1).png',
                          height: width * 0.25,
                          width: width * 0.25,
                          color: grey,
                        ),
                        SizedBox(height: height * 0.06),
                        Text(
                          'Thank You!',
                          style: GoogleFonts.raleway(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Your Appointment has been Scheduled.',
                          style: GoogleFonts.raleway(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: width * 0.02),
                        Text(
                          "For any inconvenience contact us. ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.2),
                        SizedBox(
                          width: width * 0.4,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(lightpink3)),
                              onPressed: () {
                                // Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Home()));
                              },
                              child: Text(
                                'Done',
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: grey),
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget _cardtile(height, width) {
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
                    "Experience: ${widget.doctorExperience} Years",
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.017,
                        color: grey),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "Speciality: ${widget.doctorSpeciality}",
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
                widget.doctorName,
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
            widget.doctorUrl,
            width: width * 0.16,
            height: height * 0.13,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
