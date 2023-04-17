import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

//colours:
const dark = Color(0xff54415e);
const dark2 = Color(0xff262626);
const blue = Color(0xff3976ea);
const blue2 = Color(0xff7ea5e6);
const blue3 = Color(0xff3875ea);
const lightblue = Color(0xff76a1ed);
const black = Color(0xff141010);
const black2 = Color(0xff131313);
const purple = Color(0xffa538e5);
const darkpurple = Color(0xff625006b);
const lightpurple = Color(0xffd3bbdd);
const lightpurple2 = Color(0xffc58de2);
const lightpink = Color(0xffcd99a1);
const lightpink2 = Color(0xffcc969e);
const lightpink3 = Color(0xffefd9e4);
const lightestpurple = Color(0xffF5E5FF);
const grey = Color(0xff7a727d);
const grey2 = Color(0xffa49ba7);
const grey3 = Color(0xffbdb4c1);
const grey4 = Color(0xff4b444e);
const grey5 = Color(0xffcac6cc);
const lightgrey = Color(0xffb6b6b6);
const orange = Color(0xffdc9539);
const green = Color(0xff04be04);

const videoAppId = 328174001;
const videoAppSign =
    "47c3e992217b0113482089da76606c767af5903f202ff461e42673e96ce2bfd2";

const storeId = "vedas612dadfd20e40";
const storePassword = "vedas612dadfd20e40@ssl";

makePhoneCall(String contact, bool direct) async {
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

languageHindi(
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
                      // SizedBox(height: height * 0.2),
                      Text(
                        'Coming Soon',
                        style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: grey),
                      ),
                      Text(
                        'Bengali',
                        style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: grey),
                      ),

                      SizedBox(height: height * 0.03),
                      Container(
                        width: width * 0.4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(lightpink3)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
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
