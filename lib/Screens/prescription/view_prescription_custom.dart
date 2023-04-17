import 'dart:io';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:url_launcher/url_launcher.dart';

class ViewPrescriptionCustom extends StatefulWidget {
  final String url;
  final String route;
  const ViewPrescriptionCustom(
      {Key? key, required this.url, required this.route})
      : super(key: key);

  @override
  _ViewPrescriptionCustomState createState() => _ViewPrescriptionCustomState();
}

class _ViewPrescriptionCustomState extends State<ViewPrescriptionCustom>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String fileurl = widget.url;

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
          bottomNavigationBar: SizedBox(
            height: width * 0.28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dark, // background
                      foregroundColor: Colors.white, // foreground
                    ),
                  ),
                ),
                Container(
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
                              builder: (context) => const Settings1(),
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
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    // alignment: Alignment.center,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),

                    // height: height * 0.4,
                    // width: width * 0.25,
                    child: Image.network(
                      widget.url,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, child,
                          ImageChunkEvent? loadingProgress) {
                        {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: lightpink3,
                          ),
                        );
                      },
                    ),
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
