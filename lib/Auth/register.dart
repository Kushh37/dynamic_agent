import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Services/auth_provider.dart';
import 'package:dynamic_agent/constants.dart';
import 'package:dynamic_agent/Screens/home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _storeNameController = TextEditingController();
    // String? _verificationid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: lightpurple,
                        image: DecorationImage(
                            image: AssetImage("assets/Logofull.png"),
                            fit: BoxFit.cover,
                            opacity: 0.05),
                      ),
                      child: null),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.04),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: height * 0.04,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: width * 0.03),
                        Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.1,
                              color: Colors.white),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          'Sign up Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.06,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.05),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Phone No.',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _storeNameController,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Company/Store Name',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.raleway(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: width * 0.04),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusColor: purple,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: lightpurple, width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(width: 1, color: dark),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.055),

                              SizedBox(
                                width: width,
                                height: width * 0.12,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(purple)),
                                    onPressed: () {
                                      if (_emailController.text.isEmpty &&
                                          _phoneController.text.isEmpty &&
                                          _nameController.text.isEmpty &&
                                          _passwordController.text.isEmpty &&
                                          _storeNameController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Fill all the fields.")));
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        AuthClass()
                                            .createUser(
                                          _nameController.text.trim(),
                                          _emailController.text.trim(),
                                          _phoneController.text.trim(),
                                          _passwordController.text.trim(),
                                          _storeNameController.text.trim(),
                                        )
                                            .then((value) {
                                          if (value == "Created") {
                                            setState(() {
                                              isLoading = false;
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Home()),
                                                  (route) => false);
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(value)));
                                          }
                                        });
                                      }
                                    },
                                    child: isLoading == false
                                        ? Text(
                                            'Sign Up',
                                            style: GoogleFonts.raleway(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.06,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                              ),
                              SizedBox(height: width * 0.02),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Already a member? Sign in now',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: width * 0.02),
                              // GestureDetector(
                              //   // onTap: () => Navigator.of(context).push(
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) =>
                              //   //             ForgotPassword())),
                              //   child: Text(
                              //     'forget Password?',
                              //     textAlign: TextAlign.center,
                              //     style: GoogleFonts.raleway(
                              //         fontWeight: FontWeight.w600,
                              //         fontSize: width * 0.04,
                              //         color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
