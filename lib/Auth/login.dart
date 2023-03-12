import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Auth/register.dart';
import 'package:dynamic_agent/Services/auth_provider.dart';
import 'package:dynamic_agent/Screens/home.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHiddenPassword = true;
  String username = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //getDeets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height * 0.1),
              Container(
                height: height * 0.15,
                margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                alignment: Alignment.center,
                child: Image.asset("assets/Logofull.png"),
              ),
              SizedBox(height: height * 0.04),
              Text(
                'AGENT LOGIN',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                    fontSize: height * 0.028,
                    color: dark),
              ),
              SizedBox(height: height * 0.04),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: height * 0.023),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: 20),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: dark,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: dark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusColor: purple,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: dark, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: dark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: dark,
                            fontSize: height * 0.025),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: dark,
                              fontSize: height * 0.025),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: dark,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: dark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusColor: purple,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: dark, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: const BorderSide(width: 3, color: dark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.08),
                      SizedBox(
                        width: width / 1.5,
                        height: width * 0.12,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(lightpurple)),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });

                              AuthClass()
                                  .signIN(_emailController.text.trim(),
                                      _passwordController.text.trim())
                                  .then((value) {
                                if (value == "Welcome" &&
                                    _emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                      (route) => false);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                }
                              });
                            },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600,
                                  fontSize: height * 0.027,
                                  color: Colors.black),
                            )),
                      ),
                      SizedBox(height: width * 0.06),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Register()),
                        ),
                        child: Text(
                          'Not Registered Yet? Sign Up Now',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.04,
                              color: dark),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
