import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class AddPatient extends StatefulWidget {
  final String route;

  const AddPatient({Key? key, required this.route}) : super(key: key);

  @override
  _AddPatientState createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  //List<Doctor> products = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();

  final TextEditingController _city = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  Future<void> addItem() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    String userdoc = user!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection('AGENTS')
        .doc(userdoc)
        .collection("PATIENTS");

    Map<String, dynamic> data = <String, dynamic>{
      "name": _name.text,
      "email": _email.text,
      "age": _age.text,
      "gender": _gendertype,
      "phone": _phone.text,
      "address1": _address1.text,
      "address2": _address2.text,
      "city": _city.text,
      "pincode": _pincode.text,
    };

    await mainCollection
        .doc()
        .set(data, SetOptions(merge: true))
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient Added Successfully.'))))
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
              "Add Patient",
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
                            textInputType: TextInputType.text,
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
                                  if (_name.text.isEmpty ||
                                      _age.text.isEmpty ||
                                      _gendertype == null ||
                                      _email.text.isEmpty ||
                                      _phone.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Field must not be empty.")));
                                  } else {
                                    addItem();
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (widget.route == "addPatient") {
                                        Navigator.of(context).pop();
                                      } else {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DoctorList()),
                                                (route) => false);
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  'Add',
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

class KFormfield extends StatelessWidget {
  const KFormfield(
      {Key? key,
      required this.textInputType,
      required this.label,
      required this.controller,
      required this.suffixText,
      required this.width})
      : super(key: key);
  final double width;
  final TextInputType textInputType;
  final String label;
  final TextEditingController controller;
  final String suffixText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      style: GoogleFonts.raleway(
          textStyle: GoogleFonts.raleway(
              fontSize: width * 0.04, fontWeight: FontWeight.bold)),
      decoration: InputDecoration(
        suffixText: suffixText,
        labelStyle: GoogleFonts.raleway(color: Colors.black),
        labelText: label,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple)),
      ),
    );
  }
}
