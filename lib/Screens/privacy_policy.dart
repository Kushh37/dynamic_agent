import 'package:dynamic_agent/Screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: lightpurple,
            ),
            child: TabBar(
              // unselectedLabelColor: grey,
              controller: _tabController,
              indicatorColor: lightpurple,
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Home()));
                    },
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
          backgroundColor: Colors.transparent,
          drawer: const Drawers(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // leading: new IconButton(
            //   icon: new Icon(Icons.menu, color: grey4),
            //   //onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            // ),
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
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "PRIVACY POLICY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "At www.humbingo.com, accessible from https://www.humbingo.com, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by www.humbingo.com and how we use it.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in www.humbingo.com. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the TermsFeed Privacy Policy Generator.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Consent",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "By using our website, you hereby consent to our Privacy Policy and agree to its terms.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Information we collect",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "How we use your information",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We use the information we collect in various ways, including to:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  BulletText(
                    width: width,
                    text: "Provide, operate, and maintain our website",
                  ),
                  BulletText(
                    width: width,
                    text: "Improve, personalize, and expand our website",
                  ),
                  BulletText(
                    width: width,
                    text: "Understand and analyze how you use our website",
                  ),
                  BulletText(
                    width: width,
                    text: "Develop new products, services, features, and",
                  ),
                  BulletText(
                    width: width,
                    text: "Communicate with you, either directly or through ",
                  ),
                  BulletText(
                    width: width,
                    text: "Send you emails",
                  ),
                  BulletText(
                    width: width,
                    text: "Find and prevent fraud",
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Log Files",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "www.humbingo.com follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users' movement on the website, and gathering demographic information.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Cookies and Web Beacons",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Like any other website, www.humbingo.com uses 'cookies'. These cookies are used to store information including visitors' preferences, and the pages on the website that the visitor accessed or visited. The information is used to optimize the users' experience by customizing our web page content based on visitors' browser type and/or other information.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Our Advertising Partners",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Some of advertisers on our site may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "Google",
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Advertising Partners Privacy Policies",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "You may consult this list to find the Privacy Policy for each of the advertising partners of www.humbingo.com.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on www.humbingo.com, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Note that www.humbingo.com has no access to or control over these cookies that are used by third-party advertisers.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Third Party Privacy Policies",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "www.humbingo.com's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "CCPA Privacy Rights (Do Not Sell My Personal Information)",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Under the CCPA, among other rights, California consumers have the right to:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Request that a business that collects a consumer's personal data disclose the categories and specific pieces of personal data that a business has collected about consumers.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Request that a business delete any personal data about the consumer that a business has collected.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Request that a business that sells a consumer's personal data, not sell the consumer's personal data.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "GDPR Data Protection Rights",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We would like to make sure you are fully aware of all of your data protection rights. Every user is entitled to the following:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to access – You have the right to request copies of your personal data. We may charge you a small fee for this service.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to rectification – You have the right to request that we correct any information you believe is inaccurate. You also have the right to request that we complete the information you believe is incomplete.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to erasure – You have the right to request that we erase your personal data, under certain conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to restrict processing – You have the right to request that we restrict the processing of your personal data, under certain conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to object to processing – You have the right to object to our processing of your personal data, under certain conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The right to data portability – You have the right to request that we transfer the data that we have collected to another organization, or directly to you, under certain conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If you make a request, we have one month to respond to you. If you would like to exercise any of these rights, please contact us.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Children's Information",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "www.humbingo.com does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                ],
              ),
            ),
          )),
    );
  }
}
