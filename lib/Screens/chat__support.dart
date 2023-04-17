import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

import 'package:url_launcher/url_launcher.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({
    Key? key,
  }) : super(key: key);

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat>
    with SingleTickerProviderStateMixin {
  String _name = "";
  String _email = "";
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
        _email = event.get("email").toString();
        print("$_name || $_email");
      });
    });
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

    _getData();

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

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String uname = _name;
    String uemail = _email;
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
            body: SafeArea(
                child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://humbingo.com/chat/?name=$uname&email=$uemail"),
                      ),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() async {
                          this.url = url.toString();
                          urlController.text = this.url;
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
            ]))),
      ),
    );
  }
}
