import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:dynamic_agent/Services/storage_provider.dart';
import 'package:dynamic_agent/image_helper.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:url_launcher/url_launcher.dart';

class CallPage extends StatefulWidget {
  final String patientCity;
  final String patientName;
  final String doctorName;
  final String doctorSpeciality;
  final String route;
  final String patientid;
  final String patientEmail;
  final String bookingId;
  final String bookingDetails;
  final String doctorId;
  final String type;
  final double price;
  final String doctorProfileUrl;
  final String doctorregistration;
  final String doctorLocation;

  const CallPage(
      {Key? key,
      required this.patientCity,
      required this.patientName,
      required this.doctorName,
      required this.doctorSpeciality,
      required this.route,
      required this.patientid,
      required this.patientEmail,
      required this.bookingDetails,
      required this.bookingId,
      required this.type,
      required this.price,
      required this.doctorregistration,
      required this.doctorLocation,
      required this.doctorProfileUrl,
      required this.doctorId})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    print("Route: ${widget.route}");
    print("Booking Id: ${widget.bookingId}");
    print("DoctorId Id: ${widget.doctorId}");
    print("Patient Id: ${widget.patientid}");
    print("Patient Name: ${widget.patientName}");
    print("Patient city: ${widget.patientCity}");
    print("Doctor Name: ${widget.doctorName}");
    print("Doctor Specaility: ${widget.doctorSpeciality}");
    print("Patient EMail: ${widget.patientEmail}");
    print("Patient Details: ${widget.bookingDetails}");

    if (widget.route == "agentCall") {
      _getData().then((value) {
        return Future.delayed(const Duration(seconds: 2), () {
          typePercentage(widget.price);
          typeFlat(widget.price);
          print(typePercentage(widget.price));
          print(typeFlat(widget.price));
        });
      });
      print("type: ${widget.type}");
      print("type: ${widget.price}");
    }
    // if (widget.route == "call") {
    //   ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    //       content:
    //           Text("Do not leave the call until your consultancy is over."),
    //       actions: [
    //         GestureDetector(
    //             onTap: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Icon(Icons.cancel))
    //       ]));
    // }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> readItems() {
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('BOOKING')
        .doc(widget.bookingId)
        .collection("PRESCRIPTIONS");

    return mainCollection.snapshots();
  }

  void _showUploadedPictures(BuildContext context, height, width) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          builder: (context, controller) => Container(
            alignment: Alignment.topCenter,
            //padding: EdgeInsets.only(top: width * 0.02),
            child: StreamBuilder(
              stream: readItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print("Error");
                  return const Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return SizedBox(
                    //color: Colors.red,
                    //height: height,
                    width: width,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        String docId = snapshot.data!.docs[index].id;

                        String url =
                            snapshot.data!.docs[index]['prescriptionUrl'];
                        print(docId);
                        print(url);

                        return Container(
                          height: width * 0.8,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                          ),
                          width: width,
                          child: Container(
                            alignment: Alignment.center,
                            // margin:
                            //     EdgeInsets.symmetric(vertical: width * 0.01),
                            width: width * 0.25,
                            height: height * 0.5,
                            decoration: BoxDecoration(
                              //shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  url,
                                ),
                              ),
                            ),
                            child: null,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  File? selectedFile;
  void _selectImageFromGallery(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
      addItem();
    } else {}
  }

  void _selectImageFromCamera(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromCamera(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Product Image');
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
      addItem();
    } else {}
  }

  Future<void> addItem() async {
    final CollectionReference mainCollection2 = FirebaseFirestore.instance
        .collection('BOOKING')
        .doc(widget.bookingId)
        .collection("PRESCRIPTIONS");

    StorageProvider storageProvider =
        StorageProvider(firebaseStorage: FirebaseStorage.instance);
    String imageUrl =
        await storageProvider.uploadPrescriptionCallImage(image: selectedFile);

    Map<String, dynamic> data = <String, dynamic>{
      "prescriptionUrl": imageUrl,
    };

    await mainCollection2
        .doc()
        .set(data, SetOptions(merge: true))
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription Added Successfully.'))))
        .catchError((e) => print(e));
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.route == "patient" || widget.route == "agentCall"
                    ? 'Doctor Details'
                    : widget.route == "call"
                        ? "Doctor Details"
                        : 'Patient Details',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.route == "patient" ||
                        widget.route == "call" ||
                        widget.route == "agentCall"
                    ? 'Name: ${widget.doctorName}'
                    : 'Name: ${widget.patientName}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.route == "patient" ||
                        widget.route == "call" ||
                        widget.route == "agentCall"
                    ? 'Speciality: ${widget.doctorSpeciality}'
                    : 'City: ${widget.patientCity}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.route == "patient" || widget.route == "call"
                    ? ""
                    : 'Slot: ${widget.bookingDetails}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late TabController _tabController;

  String _patientName = "";
  String _patientAddress = "";
  String _patientGender = "";
  String _patientEmail = "";
  String _patientId = "";
  String _age = "";
  String _phone = "";
  String? _patientProfileUrl = "";
  String _agentType = "";

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
        _patientAddress = event.get("address").toString();
        _patientGender = event.get("gender").toString();
        _age = event.get("age").toString();
        _type = event.get("couponType").toString();
        _couponAmount = event.get("amount").toDouble();

        _patientProfileUrl = event.get("profileUrl").toString();
        _agentType = event.get("type").toString();
        _patientEmail = event.get("email").toString();
        _phone = event.get("phone").toString();
        _patientId = userdoc;
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
    print("typePercentageAmount: $returnStr");
    return returnStr;
  }

  String typePercentageDiscount(amount) {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    discount = amount * _couponAmount / 100;
    returnStr = discount.toStringAsFixed(2);
    print("typePercentageAmount: $returnStr");
    return returnStr;
  }

  String typeFlat(amount) {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    discount = amount - discount;
    returnStr = discount.toStringAsFixed(2);
    print("FlatAmount: $returnStr");
    return returnStr;
  }

  String typeFlatDiscountAmount() {
    String returnStr;
    double discount = _couponAmount;
    returnStr = discount.toString();
    returnStr = discount.toStringAsFixed(2);
    print("typeFlatDiscountAmount: $returnStr");
    return returnStr;
  }

  Future<void> sslCommerzGeneralCall(price) async {
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
          ? double.parse(typePercentage(price))
          : _type == "Flat"
              ? double.parse(typeFlat(price))
              : price,
      tran_id: "1231321321321312",
    ));
    sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: _patientName,
            customerEmail: _patientEmail,
            customerAddress1: _patientAddress,
            customerCity: _patientAddress,
            customerPostCode: "123123",
            customerState: "",
            customerCountry: "",
            customerPhone: _phone));
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

  Future<void> _sendStatus({required status, prescriptionStatus}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    String userdoc = user!.uid;
    Map<String, dynamic> data = ({
      "status": status,
      "prescriptionStatus": prescriptionStatus,
      "totalAmount": _type == "Percentage"
          ? double.parse(typePercentage(widget.price))
          : _type == "Flat"
              ? double.parse(typeFlat(widget.price))
              : widget.price,
    });

    await FirebaseFirestore.instance
        .collection("BOOKING")
        .doc(widget.bookingId)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("BOOKINGS")
        .doc(widget.bookingId)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("DOCTORS")
        .doc(widget.doctorId)
        .collection("BOOKINGS")
        .doc(widget.bookingId)
        .set(data, SetOptions(merge: true));
    // print(_name);

    //print("User id: $user");
  }

  void _showUploadedPicturesPatient(BuildContext context, height, width) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                //height: width * 0.4,
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Photo Library'),
                        onTap: () {
                          _selectImageFromGallery(context);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context).pop();
                          });
                        }),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () {
                        _selectImageFromCamera(context);
                        // addItem();
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: width * 0.04),
            Text(
              "Your Uploaded Files",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500, fontSize: width * 0.04),
            ),
            SizedBox(height: width * 0.04),
            Expanded(
              flex: 4,
              child: DraggableScrollableSheet(
                initialChildSize: 1,
                builder: (context, controller) => Container(
                  alignment: Alignment.topCenter,
                  //padding: EdgeInsets.only(top: width * 0.02),
                  child: StreamBuilder(
                    stream: readItems(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print("Error");
                        return const Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        return SizedBox(
                          //color: Colors.red,
                          //height: height,
                          width: width,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String docId = snapshot.data!.docs[index].id;

                              String url =
                                  snapshot.data!.docs[index]['prescriptionUrl'];
                              print(docId);
                              print(url);

                              return GestureDetector(
                                onTap: () {
                                  showGeneralDialog(
                                    barrierLabel: "Barrier",
                                    barrierDismissible: false,
                                    // barrierColor: Colors.black.withOpacity(0.5),
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
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: height * 0.4,
                                                        width: width,
                                                        child: Container(
                                                            child: ProgressiveImage(
                                                                fit: BoxFit
                                                                    .contain,
                                                                height: height *
                                                                    0.3,
                                                                width: width,
                                                                blur: 2.0,
                                                                placeholder:
                                                                    const AssetImage(
                                                                        "assets/prescription (1).png"),
                                                                thumbnail:
                                                                    NetworkImage(
                                                                        url),
                                                                image:
                                                                    NetworkImage(
                                                                        url))),
                                                        // padding:
                                                        //     const EdgeInsets.all(12.0),
                                                        // child: YoutubePlayer(
                                                        //   controller: _controller,
                                                        //   showVideoProgressIndicator:
                                                        //       true,
                                                        //   progressIndicatorColor:
                                                        //       Colors.amber,
                                                        //   onReady: () {
                                                        //     print("player ready..");
                                                        //   },
                                                        // ),
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
                                child: Container(
                                  height: width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.02,
                                  ),
                                  width: width,
                                  child: Container(
                                    alignment: Alignment.center,
                                    // margin:
                                    //     EdgeInsets.symmetric(vertical: width * 0.01),
                                    width: width * 0.25,
                                    height: height * 0.5,
                                    decoration: BoxDecoration(
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                          url,
                                        ),
                                      ),
                                    ),
                                    child: null,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _url =
        "https://humbingo.com/videocall/doctor-appointment/?doctorid=${widget.doctorId}";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          webViewController!.goBack();
          return false;
        },
        child: Scaffold(
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
                          makePhoneCall("09611677590", true);
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
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                          url: Uri.parse(_url),
                        ),
                        initialOptions: options,
                        // pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() async {
                            this.url = url.toString();
                            urlController.text = this.url;
                            print(_url);
                          });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        androidOnGeolocationPermissionsShowPrompt:
                            (InAppWebViewController controller,
                                String origin) async {
                          return GeolocationPermissionShowPromptResponse(
                              origin: origin, allow: true, retain: true);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          // ignore: avoid_print
                          print(consoleMessage);
                        },
                      ),
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (widget.route == "call") {
                        _sendStatus(
                            status: "unpaid", prescriptionStatus: "Pending");
                        sslCommerzGeneralCall(widget.price).whenComplete(
                          () => {
                            _sendStatus(
                                status: "paid", prescriptionStatus: "Pending"),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "You will find your Prescription in previous Prescription Section."))),
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false)
                          },
                        );
                      } else if (widget.route == "doctorCall") {
                        _sendStatus(
                            status: "completed",
                            prescriptionStatus: "completed");
                        Navigator.of(context).pop();
                      } else if (widget.route == "agentCall") {
                        _sendStatus(
                          status: "unpaid",
                          prescriptionStatus: "Pending",
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckOutScreen(
                                  bookingId: widget.bookingId,
                                  route: "call",
                                  doctorId: widget.doctorId,
                                  doctorName: widget.doctorName,
                                  doctorUrl: widget.doctorProfileUrl,
                                  doctorLocation: widget.doctorLocation,
                                  doctorSpeciality: widget.doctorSpeciality,
                                  registration: widget.doctorregistration,
                                  price: widget.price,
                                  bookedDateAndTime: "",
                                )));
                        sslCommerzGeneralCall(widget.price).whenComplete(
                          () => {
                            _sendStatus(
                                status: "paid", prescriptionStatus: "Pending"),
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "You will find your Prescription in previous Prescription Section."))),
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false)
                          },
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('End Call'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startAddNewTransaction(context),
                    icon: const Icon(Icons.person),
                    label: Text(
                      widget.route == "patient" || widget.route == "agentCall"
                          ? 'Doctor Details'
                          : widget.route == "call"
                              ? "Doctor Details"
                              : 'Patient Details',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dark, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.route == "patient" || widget.route == "agentCall"
                          ? _showUploadedPicturesPatient(context, height, width)
                          : widget.route == "call"
                              ? _showUploadedPicturesPatient(
                                  context, height, width)
                              : _showUploadedPictures(context, height, width);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightestpurple,
                        ),
                        height: width * 0.1,
                        width: width * 0.35,
                        child: Text(
                          widget.route == "patient" ||
                                  widget.route == "agentCall"
                              ? "Upload Files"
                              : widget.route == "call"
                                  ? "Upload Files"
                                  : "See Files",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500, color: dark),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
