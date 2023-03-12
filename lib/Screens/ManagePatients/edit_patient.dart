import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/ManagePatients/add_patient.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class EditPatient extends StatefulWidget {
  final String docId;
  const EditPatient({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  _EditPatientState createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  File? selectedFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _age = TextEditingController();

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();

  final TextEditingController _city = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  var selectedSpeciality;
  var profileUrl;

  Future<void> _getDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userdoc = auth.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("PATIENTS")
        .doc(widget.docId)
        .snapshots()
        .listen((event) {
      setState(() {
        _name.text = event.get("name").toString();

        _email.text = event.get("email").toString();

        _phone.text = event.get("phone").toString();
        _address1.text = event.get("address1").toString();
        _address2.text = event.get("address2").toString();
        _city.text = event.get("city").toString();
        _pincode.text = event.get("pincode").toString();
        _age.text = event.get("age").toString();
        _gendertype = event.get("gender").toString();

        print("NAME: " + _name.text.toString());
        print("EMAIL: " + _email.text.toString());
      });
    });
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  Future<void> addItem() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userdoc = auth.currentUser!.uid;

    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('AGENTS')
        .doc(userdoc)
        .collection("PATIENTS");

    Map<String, dynamic> data = <String, dynamic>{
      "name": _name.text,
      "email": _email.text,
      "phone": _phone.text,
      "address1": _address1.text,
      "address2": _address2.text,
      "city": _city.text,
      "pincode": _pincode.text,
    };

    await mainCollection
        .doc(widget.docId)
        .set(data, SetOptions(merge: true))
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient Updated Successfully.'))))
        .catchError((e) => print(e));
  }

  var _gendertype;
  final List<String> _genderType = <String>[
    'Male',
    "Female",
    "Other",
    //'Instamojo',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              "Edit Patient",
              style: GoogleFonts.raleway(),
            ),
            centerTitle: true,
            backgroundColor: dark,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: width * 0.1),
                          KFormfield(
                            width: width,
                            label: "Name",
                            controller: _name,
                            textInputType: TextInputType.name,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Age",
                            controller: _age,
                            textInputType: TextInputType.number,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          Container(
                            // margin: EdgeInsets.fromLTRB(width * 0.05, 0.0,
                            //     width * 0.05, height * 0.04),
                            decoration: BoxDecoration(
                              border: Border.all(
                                // color: lightpurple,
                                width: 1,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.fromLTRB(width * 0.025,
                                height * 0.002, width * 0.017, height * 0.002),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      items: _genderType
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      value,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: dark),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (selectedtype) {
                                        setState(() {
                                          _gendertype = selectedtype;
                                        });
                                      },
                                      value: _gendertype,
                                      hint: Text(
                                        "Gender",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: height * 0.03,
                                        ),
                                      ),
                                      elevation: 0,
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Email",
                            controller: _email,
                            textInputType: TextInputType.emailAddress,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Phone",
                            controller: _phone,
                            textInputType: TextInputType.number,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Address 1",
                            controller: _address1,
                            textInputType: TextInputType.number,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Address 2",
                            controller: _address2,
                            textInputType: TextInputType.text,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "City",
                            controller: _city,
                            textInputType: TextInputType.text,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          KFormfield(
                            width: width,
                            label: "Pincode",
                            controller: _pincode,
                            textInputType: TextInputType.name,
                            suffixText: '',
                          ),
                          SizedBox(height: width * 0.03),
                          SizedBox(height: width * 0.1),
                          Container(
                            height: width * 0.1,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.3),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor:
                                        MaterialStateProperty.all(dark)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    addItem();
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.raleway(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          SizedBox(height: width * 0.1),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
