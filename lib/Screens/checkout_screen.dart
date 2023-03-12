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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'call_history.dart';
import 'ManagePatients/add_patient.dart';

class CheckOutScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorUrl;
  final String doctorLocation;
  final String doctorSpeciality;
  final String bookedDateAndTime;
  final String registration;
  final double price;
  final String route;
  final String bookingId;

  const CheckOutScreen(
      {Key? key,
      required this.doctorId,
      required this.doctorName,
      required this.doctorUrl,
      required this.doctorLocation,
      required this.doctorSpeciality,
      required this.registration,
      required this.price,
      required this.route,
      required this.bookingId,
      required this.bookedDateAndTime})
      : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _paymenttype;
  var selectedPatient;

  var status = true;
  String _name = "";
  String _email = "";

  Stream<QuerySnapshot> _getCount() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('BOOKING');
    return mainCollection.snapshots();
  }

  Stream<QuerySnapshot> _getPatientDetails() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userDoc = auth.currentUser!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('AGENTS')
        .doc(userDoc)
        .collection("PATIENTS");
    return mainCollection.snapshots();
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
        _name = event.get("name").toString();
        _email = event.get("email").toString();
        _code = event.get("code").toString();
        _type = event.get("couponType").toString();
        _couponAmount = event.get("amount").toDouble();
        print(_name);
        print(_email);
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

  Future<void> sslCommerzGeneralCall() async {
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
      total_amount: _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      tran_id: "1231321321321312",
    ));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: _nameController.text,
            customerEmail: _email,
            customerAddress1: _address1Controller.text,
            customerCity: _cityController.text,
            customerPostCode: _pinController.text,
            customerState: "",
            customerCountry: "",
            customerPhone: _phoneController.text));
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

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    print(widget.bookedDateAndTime);
    print(widget.doctorName);
    _getUserData().then((value) {
      return Future.delayed(const Duration(seconds: 1), () {
        typePercentage(widget.price);
        typeFlat(widget.price);
      });
    });
    // calDiscount();

    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  String? _photoUrl = "";
  String? _profileUrl = "";
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
        _name = event.get("name").toString();
        _photoUrl = user.photoURL;
        _profileUrl = event.get("profileUrl").toString();
        print(_name);
      });
    });
  }

  Future<void> _sendCallData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance
        .collection("BOOKING")
        .doc(widget.bookingId)
        .set({
      "agentName": _name,
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientImage":
          "https://lh3.googleusercontent.com/a-/AOh14GiaWbgbWtigqnhh0tqhxkqZDRrwssxqDQ1a5_HTFQ=s96-c",
      "patientEmail": user.email,
      "gender": _genderController.text,
      "age": _ageController.text,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "doctorregistration": widget.registration,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "paid",
      "bookingType": "call",
      "type": "AGENT"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(widget.bookingId)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "gender": _genderController.text,
      "patientImage": _photoUrl ?? _profileUrl,
      "age": _ageController.text,
      "doctorregistration": widget.registration,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "paid",
      "bookingType": "call",
      "type": "AGENT"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .collection("BOOKINGS")
        .doc(widget.bookingId)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "gender": _genderController.text,
      "age": _ageController.text,
      "doctorregistration": widget.registration,
      "patientImage": _photoUrl ?? _profileUrl,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "paid",
      "bookingType": "call",
      "type": "AGENT"
    }, SetOptions(merge: true));
    print(_name);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("EARNINGS")
        .doc(widget.bookingId)
        .set({
      "bookingId": widget.bookingId,
      "date": DateTime.utc(now.year, now.month, now.day),
      "amount": _type == "Percentage"
          ? double.parse(typePercentageDiscount(widget.price))
          : double.parse(typeFlatDiscountAmount()),
    }, SetOptions(merge: true));

    //print("User id: $user");
  }

  Future<void> _sendData(bookingid) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;

    await FirebaseFirestore.instance.collection("BOOKING").doc(bookingid).set({
      "agentName": _name,
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientImage":
          "https://lh3.googleusercontent.com/a-/AOh14GiaWbgbWtigqnhh0tqhxkqZDRrwssxqDQ1a5_HTFQ=s96-c",
      "patientEmail": user.email,
      "gender": _genderController.text,
      "age": _ageController.text,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "doctorregistration": widget.registration,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "inactive",
      "bookingType": "booking",
      "type": "AGENT"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "gender": _genderController.text,
      "patientImage": _photoUrl ?? _profileUrl,
      "age": _ageController.text,
      "doctorregistration": widget.registration,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "inactive",
      "bookingType": "booking",
      "type": "AGENT"
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set({
      "patientId": userdoc,
      "patientName": _nameController.text,
      "patientEmail": user.email,
      "gender": _genderController.text,
      "age": _ageController.text,
      "doctorregistration": widget.registration,
      "patientImage": _photoUrl ?? _profileUrl,
      "phone": _phoneController.text,
      "address": "${_address1Controller.text},${_address2Controller.text}",
      "city": _cityController.text,
      "pincode": _pinController.text,
      "symptoms": _symptomsController.text,
      "doctorId": widget.doctorId,
      "doctorName": widget.doctorName,
      "doctorUrl": widget.doctorUrl,
      "doctorSpeciality": widget.doctorSpeciality,
      "doctorLocation": widget.doctorLocation,
      "bookingDetails": widget.bookedDateAndTime,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : double.parse(typeFlat(widget.price)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "inactive",
      "bookingType": "booking",
      "type": "AGENT"
    }, SetOptions(merge: true));
    print(_name);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("EARNINGS")
        .doc(bookingid)
        .set({
      "bookingId": bookingid,
      "date": DateTime.utc(now.year, now.month, now.day),
      "amount": _type == "Percentage"
          ? double.parse(typePercentageDiscount(widget.price))
          : double.parse(typeFlatDiscountAmount()),
    }, SetOptions(merge: true));

    //print("User id: $user");
  }

  var bookingCount;

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
                child: Tab(
                  child: Container(
                    child: const Icon(
                      Icons.history,
                      size: 30,
                    ),
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
        backgroundColor: lightestpurple,
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
                color: lightestpurple,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Billing Details',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      StreamBuilder<QuerySnapshot>(
                          stream: _getPatientDetails(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              const Text('Loading');
                            } else {
                              List<DropdownMenuItem> currencyItems = [];
                              for (int i = 0;
                                  i < snapshot.data!.docs.length;
                                  i++) {
                                DocumentSnapshot snap = snapshot.data!.docs[i];
                                String doctorId1 = snap.id;
                                String name = snap['name'];
                                String email = snap['email'];
                                String address =
                                    "${snap['address1']},${snap['address2']}";
                                String gender = snap['gender'];
                                String phone = snap['phone'];
                                String pincode = snap['pincode'];
                                String age = snap['age'];
                                String city = snap['city'];

                                currencyItems.add(
                                  DropdownMenuItem(
                                    value: "${snap.id}",
                                    onTap: () {
                                      setState(() {
                                        _nameController.text = name;
                                        _genderController.text = gender;
                                        _ageController.text = age;
                                        _phoneController.text = phone;
                                        _address1Controller.text = address;
                                        _cityController.text = city;
                                        _pinController.text = pincode;
                                        print("Name:${_nameController.text}");
                                        print("Doctor ID1:$doctorId1");
                                      });
                                    },
                                    child: Text(snap['name']),
                                  ),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: width * 0.04,
                                              right: width * 0.04,
                                              // top: height * 0.01,
                                            ),
                                            width: width * 0.30,
                                            child: DropdownButtonFormField(
                                              decoration: InputDecoration(
                                                suffixText: '',
                                                labelStyle: GoogleFonts.raleway(
                                                    color: Colors.black),
                                                // labelText: label,
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightpurple)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    lightpurple,
                                                                width: 2)),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightpurple)),
                                              ),
                                              items: currencyItems,
                                              // onSaved: (selectedValue){

                                              // },
                                              // //  onChanged: (dynamic selectedValue){},

                                              onChanged:
                                                  (dynamic selectedValue) {
                                                setState(() {
                                                  selectedPatient =
                                                      selectedValue;
                                                  // doctorId = doctorId;
                                                  // print(doctorId);
                                                });
                                              },
                                              value: selectedPatient,

                                              hint: currencyItems.isEmpty
                                                  ? selectedPatient
                                                  : Text(
                                                      'Select Patient',
                                                      style: GoogleFonts.ptSans(
                                                          textStyle: GoogleFonts
                                                              .ptSans(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        lightpurple2)),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddPatient(
                                                            route: "checkout",
                                                          )));
                                            },
                                            child: const Text("Add Patient")),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            // return Container(
                            //   padding: EdgeInsets.only(
                            //     left: width * 0.04,
                            //     right: width * 0.04,
                            //     // top: height * 0.01,
                            //   ),
                            //   width: width * 0.30,
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     children: [
                            //       Text(
                            //         "No Patient Found!!",
                            //         style: GoogleFonts.raleway(
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: width * 0.04,
                            //             color: dark),
                            //       ),
                            //       ElevatedButton(
                            //           style: ButtonStyle(
                            //               backgroundColor:
                            //                   MaterialStateProperty.all(
                            //                       lightpurple2)),
                            //           onPressed: () {
                            //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPatient()));
                            //           },
                            //           child: Text("Add Patient")),
                            //     ],
                            //   ),
                            // );
                            return Container();
                          }),
                      SizedBox(height: width * 0.02),
                      Column(
                        children: [
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _genderController,
                              keyboardType: TextInputType.number,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.022),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.022),
                              decoration: InputDecoration(
                                labelText: "Age",
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.022),
                              decoration: InputDecoration(
                                labelText: "Phone",
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _address1Controller,
                              keyboardType: TextInputType.text,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.022),
                              decoration: InputDecoration(
                                labelText: "Street Address",
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _cityController,
                              keyboardType: TextInputType.streetAddress,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.02),
                              decoration: InputDecoration(
                                labelText: "City",
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                fillColor: Colors.transparent.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.04,
                              right: width * 0.04,
                              // top: height * 0.01,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: _pinController,
                              keyboardType: TextInputType.number,
                              cursorColor: lightpurple,
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: grey,
                                  fontSize: height * 0.02),
                              decoration: InputDecoration(
                                labelText: 'Pincode',
                                labelStyle: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w500,
                                    color: grey,
                                    fontSize: height * 0.02),
                                fillColor: Colors.transparent.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: lightpurple),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: purple,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: lightpurple, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Additional Information',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          // top: height * 0.01,
                        ),
                        child: TextFormField(
                          controller: _symptomsController,
                          keyboardType: TextInputType.text,
                          cursorColor: lightpurple,
                          maxLines: 2,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: grey,
                              fontSize: height * 0.02),
                          decoration: InputDecoration(
                            labelText: 'Symptoms',
                            labelStyle: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: grey,
                                fontSize: height * 0.02),
                            fillColor: Colors.transparent.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: lightpurple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusColor: purple,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: lightpurple, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0, color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Text(
                          'Your Orders',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: grey),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Table(
                            // border: TableBorder.symmetric(
                            //   inside: BorderSide(color: grey2),
                            // ), // Allows to add a border decoration around your table
                            children: [
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Timing',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.025,
                                          color: black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Price',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.025,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    // bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Booking for @${widget.doctorName}- ${widget.bookedDateAndTime}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.02,
                                          color: black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    // bottom: height * 0.02,
                                    // left: width * 0.03,
                                    // right: width * 0.03
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹${widget.price}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.03,
                                          color: black),
                                    ),
                                  ),
                                ),
                              ]),
                              // TableRow(
                              //     decoration: BoxDecoration(
                              //         border: Border.symmetric(
                              //             horizontal:
                              //                 BorderSide(color: black))),
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.only(
                              //           top: height * 0.02,
                              //           bottom: height * 0.02,
                              //           // left: width * 0.03,
                              //           // right: width * 0.03
                              //         ),
                              //         child: Center(
                              //           child: Text(
                              //             'Subtotal',
                              //             textAlign: TextAlign.center,
                              //             style: GoogleFonts.raleway(
                              //                 fontWeight: FontWeight.w800,
                              //                 fontSize: height * 0.02,
                              //                 color: black),
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.only(
                              //           top: height * 0.02,
                              //           bottom: height * 0.02,
                              //           // left: width * 0.03,
                              //           // right: width * 0.03
                              //         ),
                              //         child: Center(
                              //           child: Text(
                              //             '₹400',
                              //             textAlign: TextAlign.center,
                              //             style: GoogleFonts.raleway(
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: height * 0.03,
                              //                 color: black),
                              //           ),
                              //         ),
                              //       ),
                              //     ]),
                              TableRow(
                                  // decoration: BoxDecoration(
                                  //     border: Border.symmetric(
                                  //         horizontal: BorderSide(color: black))),
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: height * 0.02,
                                        bottom: height * 0.02,
                                        // left: width * 0.03,
                                        // right: width * 0.03
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Total',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w800,
                                              fontSize: height * 0.02,
                                              color: black),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                        top: height * 0.02,
                                        // bottom: height * 0.02,
                                        // left: width * 0.03,
                                        // right: width * 0.03
                                      ),
                                      child: Center(
                                        child: Text(
                                          _type == "Percentage"
                                              ? typePercentage(widget.price)
                                              : typeFlat(widget.price),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.bold,
                                              fontSize: height * 0.03,
                                              color: black),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        height: width * 0.1,
                        decoration: BoxDecoration(
                            color: lightpurple,
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Coupon Code Applied!",
                                style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    color: dark,
                                    fontSize: width * 0.04)),
                            Icon(
                              CupertinoIcons.check_mark_circled,
                              color: dark,
                              size: width * 0.08,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Text(
                          'Your Personal data will be used to process your order, support your experience throughout this website,and for other purposes described in our privacy Policy.',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.03,
                              color: dark),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: width,
                        //height: height * 0.1,
                        child: StreamBuilder(
                          stream: _getCount(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            } else if (snapshot.hasData ||
                                snapshot.data != null) {
                              var itemCount = snapshot.data!.docs.length;
                              //print(snapshot.data.toString());
                              return Container(
                                width: width * 0.4,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                lightpurple)),
                                    onPressed: () {
                                      var item = itemCount + 1;
                                      if (widget.route == "call") {
                                        sslCommerzGeneralCall()
                                            .whenComplete(() {
                                          setState(() {
                                            _sendCallData();

                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home()),
                                                    (route) => false);
                                          });
                                        });
                                      } else {
                                        sslCommerzGeneralCall().then((value) {
                                          setState(() {
                                            _sendData("MH000$item");
                                            _showAppointmentDoneDialog(
                                                context,
                                                width,
                                                height,
                                                item,
                                                widget.bookedDateAndTime);
                                          });
                                        });
                                      }

                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             PaymentScreen()));
                                    },
                                    child: Text(
                                      widget.route == "call"
                                          ? "Pay Now"
                                          : 'Place Order',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w600,
                                          fontSize: height * 0.023,
                                          color: grey),
                                    )),
                              );
                            }
                            return const CircularProgressIndicator(
                              color: dark,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAppointmentDoneDialog(BuildContext context, double width, double height,
      var bookingId, var dateAndTime) {
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
                          'Your Appointment has been Created',
                          style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "Your Booking Id: MH000$bookingId",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: grey),
                        ),
                        SizedBox(height: width * 0.02),
                        Text(
                          "Booking Date & Time:$dateAndTime",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontSize: 16,
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
}
