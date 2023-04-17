import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_agent/Screens/doctor_profile.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList>
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

    _getAllDoctors();
    _getData().then((value) {
      return Future.delayed(const Duration(seconds: 2), () {
        typePercentage(100);
        typeFlat(100);
      });
    });
  }

  Stream<QuerySnapshot> _getReviews(speciality, id) {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc(speciality)
        .collection("DOCTORS")
        .doc(id)
        .collection('REVIEWS');

    return mainCollection.snapshots();
  }

  String _patientName = "";
  String _patientAddress = "";
  String _patientGender = "";
  String _patientEmail = "";
  String _patientId = "";
  String _age = "";
  String _phone = "";
  String? _patientProfileUrl = "";

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
        _patientName = event.get("name").toString();
        _patientAddress = event.get("storeName").toString();
        _patientGender = event.get("gender").toString();
        _age = event.get("age").toString();

        _patientProfileUrl = event.get("profileUrl").toString();
        _patientEmail = event.get("email").toString();
        _phone = event.get("phone").toString();
        _patientId = userdoc;
        _code = event.get("code").toString();
        _type = event.get("couponType").toString();
        _couponAmount = event.get("amount").toDouble();

        print(_patientName);
      });
    });
  }

  String _code = "";
  String _type = "";
  double _couponAmount = 0.0;
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

  Stream<QuerySnapshot> _getCount() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('BOOKING');

    return mainCollection.snapshots();
  }

  String? _photoUrl = "";

  Future<void> _sendData({
    required bookingid,
    required doctorId,
    required doctorName,
    required doctorUrl,
    required doctorSpeciality,
    required doctorLocation,
    required doctorregistration,
    required doctorPrice,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    Map<String, dynamic> data = ({
      "patientId": userdoc,
      "patientName": _patientName,
      "patientEmail": user.email,
      "patientImage": _photoUrl ?? _patientProfileUrl,
      "gender": _patientGender,
      "age": _age,
      "phone": _phone,
      "address": _patientAddress,
      "city": _patientAddress,
      "pincode": "",
      "symptoms": "",
      "doctorId": doctorId,
      "doctorName": doctorName,
      "doctorUrl": doctorUrl,
      "doctorSpeciality": doctorSpeciality,
      "doctorLocation": doctorLocation,
      "doctorregistration": doctorregistration,
      "bookingDetails": "",
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(doctorPrice))
          : double.parse(typeFlat(doctorPrice)),
      "prescriptionStatus": "Pending",
      "prescriptionType": "",
      "prescriptionUrl": "",
      "status": "unpaid",
      "bookingType": "call",
      "type": "AGENT"
    });

    await FirebaseFirestore.instance
        .collection("BOOKING")
        .doc(bookingid)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(doctorId)
        .collection("BOOKINGS")
        .doc(bookingid)
        .set(data, SetOptions(merge: true));
    // print(_name);
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
          ? double.parse(typePercentageDiscount(doctorPrice))
          : double.parse(typeFlatDiscountAmount()),
    }, SetOptions(merge: true));

    //print("User id: $user");
  }

  var bookingCount;
  var status = true;

  bool all = true;
  //var statusType;
  bool cardiologist = false;
  bool general = false;
  bool generalPractitioner = false;
  bool entSpecialist = false;
  bool psychiatrist = false;
  bool pediatrics = false;
  bool surgeon = false;
  bool podiatrist = false;
  bool ophthalmology = false;
  bool anesthesiology = false;
  bool internalMedicine = false;
  bool neurologist = false;
  bool dermatologist = false;
  bool dermatology = false;
  bool neurology = false;
  bool familyMedicine = false;
  bool oncology = false;
  bool orthopedicSurgeon = false;
  bool radiology = false;
  bool radiologist = false;
  bool urology = false;
  bool emergencyMedicine = false;
  bool rheumatology = false;
  bool cardiology = false;
  bool plasticSurgery = false;
  bool endocrinologist = false;
  static Stream<QuerySnapshot> _getAllDoctors() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('DOCTORS');

    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getCardiologist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Cardiologist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getGeneral() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("General")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getGeneralPractitioner() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("General Practitioner")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getEntSpecialist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Ent Specialist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getPsychiatrist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Psychiatrist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getPediatrics() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Pediatrics")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getSurgeon() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Surgeon")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getPodiatrist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Podiatrist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getOphthalmology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Ophthalmology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getAnesthesiology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Anesthesiology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getInternalMedicine() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Internal Medicine")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getNeurologist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Neurologist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getDermatologist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Dermatologist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getDermatology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Dermatology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getNeurology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Neurology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getFamilyMedicine() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Family Medicine")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getOncology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Oncology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getOrthopedicSurgeon() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Orthopedic Surgeon")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getRadiology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Radiology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getRadiologist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Radiologist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getUrology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Urology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getEmergencyMedicine() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Emergency Medicine")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getRheumatology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Rheumatology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getCardiology() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Cardiology")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getPlasticSurgery() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Plastic Surgery")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getEndocrinologist() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('Doctor')
        .doc("Endocrinologist")
        .collection("DOCTORS");
    return mainCollection.snapshots();
  }

  static Stream<QuerySnapshot> _getAllCategorys() {
    final CollectionReference mainCollection =
        FirebaseFirestore.instance.collection('Doctor');
    return mainCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: 'FoMlSB6ftQg',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          Scaffold(
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
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Home(),
                        )),
                        child: const SizedBox(
                          child: Icon(
                            Icons.home_outlined,
                            size: 30,
                          ),
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
                        child: SizedBox(
                          child: Icon(
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
                        child: const SizedBox(
                          child: Icon(
                            Icons.settings,
                            size: 30,
                          ),
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
                        desc:
                            "Do you want to make a phone call to our support?",
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              makePhoneCall("06352192149", true);
                            },
                            color: lightpurple2,
                            child: const Text(
                              "Yes",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            color: lightpurple2,
                            child: const Text(
                              "No",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: [
                    TextFormField(
                      style: GoogleFonts.raleway(
                          textStyle: GoogleFonts.raleway(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            CupertinoIcons.search,
                            size: height * 0.03,
                            color: dark,
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: lightestpurple.withOpacity(0.8),
                          hintStyle: GoogleFonts.raleway(
                              textStyle: GoogleFonts.raleway(
                                  color: grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          hintText: 'Search Doctors',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusColor: purple,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: lightpurple, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 0, color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.07,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  all = true;
                                  cardiologist = false;
                                  general = false;
                                  generalPractitioner = false;
                                  entSpecialist = false;
                                  psychiatrist = false;
                                  pediatrics = false;
                                  surgeon = false;
                                  podiatrist = false;
                                  ophthalmology = false;
                                  anesthesiology = false;
                                  internalMedicine = false;
                                  neurologist = false;
                                  dermatologist = false;
                                  dermatology = false;
                                  neurology = false;
                                  familyMedicine = false;
                                  oncology = false;
                                  orthopedicSurgeon = false;
                                  radiology = false;
                                  radiologist = false;
                                  urology = false;
                                  emergencyMedicine = false;
                                  rheumatology = false;
                                  cardiology = false;
                                  plasticSurgery = false;
                                  endocrinologist = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: width * 0.02),
                                width: width * 0.2,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.035,
                                      vertical: height * 0.005),
                                  color: all == false
                                      ? lightestpurple
                                      : lightpurple2.withOpacity(0.8),
                                  child: Center(
                                    child: Text(
                                      'All',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.w500,
                                          fontSize: height * 0.021,
                                          color: all == true
                                              ? Colors.white
                                              : dark),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: StreamBuilder(
                              stream: _getAllCategorys(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                } else if (snapshot.hasData ||
                                    snapshot.data != null) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String docId =
                                          snapshot.data!.docs[index].id;
                                      // print(docId);
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: width * 0.02),
                                        width: width * 0.45,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (docId == "Cardiologist") {
                                                all = false;
                                                cardiologist = true;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "General") {
                                                all = false;
                                                cardiologist = false;
                                                general = true;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "General Practitioner") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = true;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Ent Specialist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = true;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Psychiatrist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = true;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Pediatrics") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = true;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "Surgeon") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = true;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Podiatrist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = true;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Ophthalmology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = true;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Anesthesiology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = true;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Internal Medicine") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = true;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Neurologist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = true;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Dermatologist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = true;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Dermatology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = true;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "Neurology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = true;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Family Medicine") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = true;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "Oncology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = true;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Orthopedic Surgeon") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = true;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "Radiology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = true;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Radiologist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = true;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId == "Urology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = true;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Emergency Medicine") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = true;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Rheumatology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = true;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Cardiology") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = true;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Plastic Surgery") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = true;
                                                endocrinologist = false;
                                              } else if (docId ==
                                                  "Endocrinologist") {
                                                all = false;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = true;
                                              } else if (docId == "All") {
                                                all = true;
                                                cardiologist = false;
                                                general = false;
                                                generalPractitioner = false;
                                                entSpecialist = false;
                                                psychiatrist = false;
                                                pediatrics = false;
                                                surgeon = false;
                                                podiatrist = false;
                                                ophthalmology = false;
                                                anesthesiology = false;
                                                internalMedicine = false;
                                                neurologist = false;
                                                dermatologist = false;
                                                dermatology = false;
                                                neurology = false;
                                                familyMedicine = false;
                                                oncology = false;
                                                orthopedicSurgeon = false;
                                                radiology = false;
                                                radiologist = false;
                                                urology = false;
                                                emergencyMedicine = false;
                                                rheumatology = false;
                                                cardiology = false;
                                                plasticSurgery = false;
                                                endocrinologist = false;
                                              } else {
                                                all = true;
                                              }
                                            });
                                          },
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.5)),
                                            margin: EdgeInsets.symmetric(
                                                vertical: height * 0.005,
                                                horizontal: width * 0.033),
                                            color: docId == "Cardiologist" &&
                                                    cardiologist == true
                                                ? lightpurple2.withOpacity(0.8)
                                                : docId == "General" &&
                                                        general == true
                                                    ? lightpurple2
                                                        .withOpacity(0.8)
                                                    : docId == "General Practitioner" &&
                                                            generalPractitioner ==
                                                                true
                                                        ? lightpurple2
                                                            .withOpacity(0.8)
                                                        : docId == "Ent Specialist" &&
                                                                entSpecialist ==
                                                                    true
                                                            ? lightpurple2
                                                                .withOpacity(
                                                                    0.8)
                                                            : docId == "Psychiatrist" &&
                                                                    psychiatrist ==
                                                                        true
                                                                ? lightpurple2
                                                                    .withOpacity(
                                                                        0.8)
                                                                : docId == "Pediatrics" &&
                                                                        pediatrics ==
                                                                            true
                                                                    ? lightpurple2
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : docId == "Surgeon" &&
                                                                            surgeon ==
                                                                                true
                                                                        ? lightpurple2.withOpacity(
                                                                            0.8)
                                                                        : docId == "Podiatrist" &&
                                                                                podiatrist == true
                                                                            ? lightpurple2.withOpacity(0.8)
                                                                            : docId == "Ophthalmology" && ophthalmology == true
                                                                                ? lightpurple2.withOpacity(0.8)
                                                                                : docId == "Anesthesiology" && anesthesiology == true
                                                                                    ? lightpurple2.withOpacity(0.8)
                                                                                    : docId == "Internal Medicine" && internalMedicine == true
                                                                                        ? lightpurple2.withOpacity(0.8)
                                                                                        : docId == "Neurologist" && neurologist == true
                                                                                            ? lightpurple2.withOpacity(0.8)
                                                                                            : docId == "Dermatologist" && dermatologist == true
                                                                                                ? lightpurple2.withOpacity(0.8)
                                                                                                : docId == "Dermatology" && dermatology == true
                                                                                                    ? lightpurple2.withOpacity(0.8)
                                                                                                    : docId == "Neurology" && neurology == true
                                                                                                        ? lightpurple2.withOpacity(0.8)
                                                                                                        : docId == "Family Medicine" && familyMedicine == true
                                                                                                            ? lightpurple2.withOpacity(0.8)
                                                                                                            : docId == "Oncology" && oncology == true
                                                                                                                ? lightpurple2.withOpacity(0.8)
                                                                                                                : docId == "Orthopedic Surgeon" && orthopedicSurgeon == true
                                                                                                                    ? lightpurple2.withOpacity(0.8)
                                                                                                                    : docId == "Radiology" && radiology == true
                                                                                                                        ? lightpurple2.withOpacity(0.8)
                                                                                                                        : docId == "Radiologist" && radiologist == true
                                                                                                                            ? lightpurple2.withOpacity(0.8)
                                                                                                                            : docId == "Urology" && urology == true
                                                                                                                                ? lightpurple2.withOpacity(0.8)
                                                                                                                                : docId == "Emergency Medicine" && emergencyMedicine == true
                                                                                                                                    ? lightpurple2.withOpacity(0.8)
                                                                                                                                    : docId == "Rheumatology" && rheumatology == true
                                                                                                                                        ? lightpurple2.withOpacity(0.8)
                                                                                                                                        : docId == "Cardiology" && cardiology == true
                                                                                                                                            ? lightpurple2.withOpacity(0.8)
                                                                                                                                            : docId == "Plastic Surgery" && plasticSurgery == true
                                                                                                                                                ? lightpurple2.withOpacity(0.8)
                                                                                                                                                : docId == "Endocrinologist" && endocrinologist == true
                                                                                                                                                    ? lightpurple2.withOpacity(0.8)
                                                                                                                                                    : lightestpurple,
                                            child: Center(
                                              child: Text(
                                                docId,
                                                style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: height * 0.021,
                                                  color: docId ==
                                                              "Cardiologist" &&
                                                          cardiologist == true
                                                      ? Colors.white
                                                      : docId == "General" &&
                                                              general == true
                                                          ? Colors.white
                                                          : docId == "General Practitioner" &&
                                                                  generalPractitioner ==
                                                                      true
                                                              ? Colors.white
                                                              : docId == "Ent Specialist" &&
                                                                      entSpecialist ==
                                                                          true
                                                                  ? Colors.white
                                                                  : docId == "Psychiatrist" &&
                                                                          psychiatrist ==
                                                                              true
                                                                      ? Colors
                                                                          .white
                                                                      : docId == "Pediatrics" &&
                                                                              pediatrics ==
                                                                                  true
                                                                          ? Colors
                                                                              .white
                                                                          : docId == "Surgeon" && surgeon == true
                                                                              ? Colors.white
                                                                              : docId == "Podiatrist" && podiatrist == true
                                                                                  ? Colors.white
                                                                                  : docId == "Ophthalmology" && ophthalmology == true
                                                                                      ? Colors.white
                                                                                      : docId == "Anesthesiology" && anesthesiology == true
                                                                                          ? Colors.white
                                                                                          : docId == "Internal Medicine" && internalMedicine == true
                                                                                              ? Colors.white
                                                                                              : docId == "Neurologist" && neurologist == true
                                                                                                  ? Colors.white
                                                                                                  : docId == "Dermatologist" && dermatologist == true
                                                                                                      ? Colors.white
                                                                                                      : docId == "Dermatology" && dermatology == true
                                                                                                          ? Colors.white
                                                                                                          : docId == "Neurology" && neurology == true
                                                                                                              ? Colors.white
                                                                                                              : docId == "Family Medicine" && familyMedicine == true
                                                                                                                  ? Colors.white
                                                                                                                  : docId == "Oncology" && oncology == true
                                                                                                                      ? Colors.white
                                                                                                                      : docId == "Orthopedic Surgeon" && orthopedicSurgeon == true
                                                                                                                          ? Colors.white
                                                                                                                          : docId == "Radiology" && radiology == true
                                                                                                                              ? Colors.white
                                                                                                                              : docId == "Radiologist" && radiologist == true
                                                                                                                                  ? Colors.white
                                                                                                                                  : docId == "Urology" && urology == true
                                                                                                                                      ? Colors.white
                                                                                                                                      : docId == "Emergency Medicine" && emergencyMedicine == true
                                                                                                                                          ? Colors.white
                                                                                                                                          : docId == "Rheumatology" && rheumatology == true
                                                                                                                                              ? Colors.white
                                                                                                                                              : docId == "Cardiology" && cardiology == true
                                                                                                                                                  ? Colors.white
                                                                                                                                                  : docId == "Plastic Surgery" && plasticSurgery == true
                                                                                                                                                      ? Colors.white
                                                                                                                                                      : docId == "Endocrinologist" && endocrinologist == true
                                                                                                                                                          ? Colors.white
                                                                                                                                                          : dark,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: dark,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        // Text(
                        //   'Online',
                        //   style: GoogleFonts.raleway(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 14,
                        //       color: dark),
                        // ),
                        // SizedBox(width: width * 0.01),
                        // Switch(
                        //   activeColor: dark,
                        //   inactiveTrackColor: dark,
                        //   value: status,
                        //   onChanged: (val) {
                        //     setState(() {
                        //       status = val;
                        //       print("object : $status");
                        //     });
                        //   },
                        // ),
                        // SizedBox(width: width * 0.01),
                        // Text(
                        //   'All',
                        //   style: GoogleFonts.raleway(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: height * 0.017,
                        //       color: dark),
                        // ),
                        Flexible(
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () {
                            showGeneralDialog(
                              barrierLabel: "Barrier",
                              barrierDismissible: false,
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: width * 0.02,
                                      right: width * 0.02,
                                      top: height * 0.04,
                                      bottom: height * 0.04),
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: StatefulBuilder(
                                      builder:
                                          (BuildContext context, setState) {
                                        return Container(
                                          color: Colors.black,
                                          height: height,
                                          width: width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height: height - height * 0.1,
                                                  width: width,
                                                  // padding:
                                                  //     const EdgeInsets.all(12.0),
                                                  child: YoutubePlayer(
                                                    controller: controller,
                                                    showVideoProgressIndicator:
                                                        true,
                                                    progressIndicatorColor:
                                                        Colors.amber,
                                                    onReady: () {},
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder: (_, anim, __, child) {
                                return SlideTransition(
                                  position: Tween(
                                          begin: const Offset(0, 1),
                                          end: const Offset(0, 0))
                                      .animate(anim),
                                  child: child,
                                );
                              },
                            );
                          },
                          child: Text(
                            'Help',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w800,
                                fontSize: height * 0.017,
                                color: dark),
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        Icon(
                          CupertinoIcons.question_circle,
                          color: dark,
                          size: height * 0.03,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: width * 1.0,
                        padding: EdgeInsets.only(top: width * 0.05),
                        child: StreamBuilder(
                          stream: cardiologist == true
                              ? _getCardiologist()
                              : general == true
                                  ? _getGeneral()
                                  : generalPractitioner == true
                                      ? _getGeneralPractitioner()
                                      : entSpecialist == true
                                          ? _getEntSpecialist()
                                          : psychiatrist == true
                                              ? _getPsychiatrist()
                                              : pediatrics == true
                                                  ? _getPediatrics()
                                                  : surgeon == true
                                                      ? _getSurgeon()
                                                      : podiatrist == true
                                                          ? _getPodiatrist()
                                                          : ophthalmology ==
                                                                  true
                                                              ? _getOphthalmology()
                                                              : anesthesiology ==
                                                                      true
                                                                  ? _getAnesthesiology()
                                                                  : internalMedicine ==
                                                                          true
                                                                      ? _getInternalMedicine()
                                                                      : neurologist ==
                                                                              true
                                                                          ? _getNeurologist()
                                                                          : dermatologist == true
                                                                              ? _getDermatologist()
                                                                              : dermatology == true
                                                                                  ? _getDermatology()
                                                                                  : neurology == true
                                                                                      ? _getNeurology()
                                                                                      : familyMedicine == true
                                                                                          ? _getFamilyMedicine()
                                                                                          : oncology == true
                                                                                              ? _getOncology()
                                                                                              : orthopedicSurgeon == true
                                                                                                  ? _getOrthopedicSurgeon()
                                                                                                  : radiology == true
                                                                                                      ? _getRadiology()
                                                                                                      : radiologist == true
                                                                                                          ? _getRadiologist()
                                                                                                          : urology == true
                                                                                                              ? _getUrology()
                                                                                                              : emergencyMedicine == true
                                                                                                                  ? _getEmergencyMedicine()
                                                                                                                  : rheumatology == true
                                                                                                                      ? _getRheumatology()
                                                                                                                      : cardiology == true
                                                                                                                          ? _getCardiology()
                                                                                                                          : plasticSurgery == true
                                                                                                                              ? _getPlasticSurgery()
                                                                                                                              : endocrinologist == true
                                                                                                                                  ? _getEndocrinologist()
                                                                                                                                  : _getAllDoctors(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            } else if (snapshot.hasData ||
                                snapshot.data != null) {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                // _name.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String docId = snapshot.data!.docs[index].id;

                                  String name =
                                      snapshot.data!.docs[index]['name'];
                                  String speciality =
                                      snapshot.data!.docs[index]['speciality'];

                                  String profileUrl =
                                      snapshot.data!.docs[index]['profileUrl'];

                                  String experience =
                                      snapshot.data!.docs[index]['experience'];
                                  String fullExperience = snapshot
                                      .data!.docs[index]['fullExperience'];
                                  String registration = snapshot
                                      .data!.docs[index]['registration'];
                                  String location =
                                      snapshot.data!.docs[index]['location'];
                                  String fullInfo =
                                      snapshot.data!.docs[index]['fullInfo'];
                                  String doctorType =
                                      snapshot.data!.docs[index]["doctorType"];
                                  var price =
                                      snapshot.data!.docs[index]["price"];
                                  String presence =
                                      snapshot.data!.docs[index]["presence"];
                                  String bookingStatus = snapshot
                                      .data!.docs[index]["bookingStatus"];
                                  String stateStatus =
                                      snapshot.data!.docs[index]["status"];
                                  // statusType = statusA;
                                  // print("Type:$statusType");

                                  return GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        bookingStatus == "booked"
                                            ? Container(
                                                width: width * 0.22,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color: dark),
                                                padding: EdgeInsets.only(
                                                    left: width * 0.01,
                                                    right: width * 0.01),
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02),
                                                //alignment: Alignment.center,
                                                child: Text(
                                                  "Booked",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : SizedBox(
                                                height: width * 0.000001,
                                              ),
                                        SizedBox(
                                          height: height * 0.17,
                                          width: width,
                                          child: Card(
                                            color: lightestpurple,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (stateStatus ==
                                                        "AVAILABLE") {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (_) => DoctorProfile(
                                                              price: price,
                                                              id: docId,
                                                              name: name,
                                                              speciality:
                                                                  speciality,
                                                              experience:
                                                                  experience,
                                                              registration:
                                                                  registration,
                                                              location:
                                                                  location,
                                                              fullInfo:
                                                                  fullInfo,
                                                              fullExperience:
                                                                  fullExperience,
                                                              profileUrl:
                                                                  profileUrl)));
                                                    }
                                                  },
                                                  child: Card(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: ProgressiveImage(
                                                        fit: BoxFit.cover,
                                                        height: height,
                                                        blur: 2.0,
                                                        width: width * 0.213,
                                                        placeholder:
                                                            const AssetImage(
                                                                "assets/doctor.png"),
                                                        image: NetworkImage(
                                                            profileUrl),
                                                        thumbnail: NetworkImage(
                                                            profileUrl),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: width * 0.5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (stateStatus ==
                                                                    "AVAILABLE") {
                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                      builder: (_) => DoctorProfile(
                                                                          price:
                                                                              price,
                                                                          id:
                                                                              docId,
                                                                          name:
                                                                              name,
                                                                          speciality:
                                                                              speciality,
                                                                          experience:
                                                                              experience,
                                                                          registration:
                                                                              registration,
                                                                          location:
                                                                              location,
                                                                          fullInfo:
                                                                              fullInfo,
                                                                          fullExperience:
                                                                              fullExperience,
                                                                          profileUrl:
                                                                              profileUrl)));
                                                                }
                                                              },
                                                              child: Text(
                                                                name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.raleway(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        width *
                                                                            0.04,
                                                                    color:
                                                                        blue2),
                                                              ),
                                                            ),
                                                            presence == "ACTIVE"
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.02,
                                                                      ),
                                                                      Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              green,
                                                                        ),
                                                                        width: width *
                                                                            0.015,
                                                                        height: height *
                                                                            0.015,
                                                                        child:
                                                                            null,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        'Available',
                                                                        style: GoogleFonts.raleway(
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            color:
                                                                                grey,
                                                                            fontSize:
                                                                                10),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : SizedBox(
                                                                    width: width *
                                                                        0.0001,
                                                                  ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.5,
                                                          height: width * 0.04,
                                                          child: StreamBuilder(
                                                            stream: _getReviews(
                                                                speciality,
                                                                docId),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return const Text(
                                                                    'Something went wrong');
                                                              } else if (snapshot
                                                                      .hasData ||
                                                                  snapshot.data !=
                                                                      null) {
                                                                //print(snapshot.data.toString());
                                                                return SizedBox(
                                                                  width: width,
                                                                  // color: Colors.blue,
                                                                  child: ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    itemCount:
                                                                        1,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      // String docId = snapshot.data!.docs[index]['email'];
                                                                      int count1 = snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length;
                                                                      double
                                                                          rating =
                                                                          snapshot.data!.docs[index]["ratings"].toDouble() ??
                                                                              0.0;

                                                                      return count1 ==
                                                                              0
                                                                          ? Container(
                                                                              child: Row(
                                                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  RatingBarIndicator(
                                                                                    rating: 4,
                                                                                    itemBuilder: (context, index) => const Icon(
                                                                                      Icons.star,
                                                                                      color: Colors.amber,
                                                                                    ),
                                                                                    itemCount: 5,
                                                                                    itemSize: width * 0.03,
                                                                                    direction: Axis.horizontal,
                                                                                  ),
                                                                                  const Text("(Reviews)")
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
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
                                                                                Text("($count1 Reviews)")
                                                                              ],
                                                                            );
                                                                    },
                                                                  ),
                                                                );
                                                              }
                                                              return const SizedBox(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: dark,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                width * 0.01),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              speciality,
                                                              style: GoogleFonts.lato(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      height *
                                                                          0.02,
                                                                  color: dark),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: width *
                                                                          0.03),
                                                              child: Text(
                                                                "Fees: ৳ $price ",
                                                                style: GoogleFonts.lato(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        height *
                                                                            0.02,
                                                                    color:
                                                                        dark),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: height * 0.01,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        width *
                                                                            0.01),
                                                            width: width * 0.4,
                                                            child:
                                                                StreamBuilder(
                                                              stream:
                                                                  _getCount(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return const Text(
                                                                      'Something went wrong');
                                                                } else if (snapshot
                                                                        .hasData ||
                                                                    snapshot.data !=
                                                                        null) {
                                                                  var itemCount =
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length;
                                                                  return stateStatus ==
                                                                          "AVAILABLE"
                                                                      ? ElevatedButton(
                                                                          style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all(0.0),
                                                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                                  side: const BorderSide(
                                                                                    color: dark,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5))),
                                                                              backgroundColor: MaterialStateProperty.all(dark)),
                                                                          onPressed: () {
                                                                            var item =
                                                                                itemCount + 1;
                                                                            if (doctorType ==
                                                                                "In House") {
                                                                              _sendData(
                                                                                bookingid: "MH000$item",
                                                                                doctorId: docId,
                                                                                doctorName: name,
                                                                                doctorUrl: profileUrl,
                                                                                doctorSpeciality: speciality,
                                                                                doctorLocation: location,
                                                                                doctorregistration: registration,
                                                                                doctorPrice: _type == "Percentage" ? double.parse(typePercentage(double.parse(price))) : double.parse(typeFlat(double.parse(price))),
                                                                              ).whenComplete(() => {
                                                                                    Navigator.of(context).push(MaterialPageRoute(
                                                                                        builder: (_) => CallPage(
                                                                                              doctorregistration: registration,
                                                                                              doctorLocation: location,
                                                                                              doctorProfileUrl: profileUrl,
                                                                                              price: double.parse(price),
                                                                                              patientCity: _patientAddress,
                                                                                              patientName: _patientName,
                                                                                              doctorName: name,
                                                                                              doctorSpeciality: speciality,
                                                                                              route: "agentCall",
                                                                                              patientid: _patientId,
                                                                                              patientEmail: _patientEmail,
                                                                                              bookingDetails: "",
                                                                                              bookingId: "MH000$item",
                                                                                              type: "AGENT",
                                                                                              doctorId: docId,
                                                                                            )))
                                                                                  });
                                                                            } else {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => DoctorProfile(price: price, id: docId, name: name, speciality: speciality, experience: experience, registration: registration, location: location, fullInfo: fullInfo, fullExperience: fullExperience, profileUrl: profileUrl)));
                                                                            }
                                                                          },
                                                                          child: Text(
                                                                            doctorType == "In House"
                                                                                ? 'CALL DOCTOR'
                                                                                : 'Book Appointment',
                                                                            style: GoogleFonts.raleway(
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.white,
                                                                                fontSize: width * 0.035),
                                                                          ))
                                                                      : ElevatedButton(
                                                                          style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all(0.0),
                                                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                                  side: const BorderSide(
                                                                                    color: dark,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5))),
                                                                              backgroundColor: MaterialStateProperty.all(dark)),
                                                                          onPressed: () {
                                                                            print("notAllowd");
                                                                          },
                                                                          child: Text(
                                                                            'Currently Unavailable',
                                                                            style: GoogleFonts.raleway(
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.white,
                                                                                fontSize: width * 0.035),
                                                                          ));
                                                                }
                                                                return const CircularProgressIndicator(
                                                                  color: dark,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: dark,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
