import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition>
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
                    "TERMS & CONDITION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Welcome to www.humbingo.com!",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "These terms and conditions outline the rules and regulations for the use of Mr Healer Health Solution LTD's Website, located at https://www.humbingo.com.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "By accessing this website we assume you accept these terms and conditions. Do not continue to use www.humbingo.com if you do not agree to take all of the terms and conditions stated on this page.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: \"Client\", \"You\" and \"Your\" refers to you, the person log on this website and compliant to the Company’s terms and conditions. \"The Company\", \"Ourselves\", \"We\", \"Our\" and \"Us\", refers to our Company. \"Party\", \"Parties\", or \"Us\", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Cookies",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We employ the use of cookies. By accessing www.humbingo.com, you agreed to use cookies in agreement with the Mr Healer Health Solution LTD's Privacy Policy.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "License",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Unless otherwise stated, Mr Healer Health Solution LTD and/or its licensors own the intellectual property rights for all material on www.humbingo.com. All intellectual property rights are reserved. You may access this from www.humbingo.com for your own personal use subjected to restrictions set in these terms and conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "You must not:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "Republish material from www.humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Sell, rent or sub-license material from www.humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Reproduce, duplicate or copy material from www.humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text: "Redistribute content from www.humbingo.com",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Mr Healer Health Solution LTD does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Mr Healer Health Solution LTD,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Mr Healer Health Solution LTD shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Mr Healer Health Solution LTD reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "You hereby grant Mr Healer Health Solution LTD a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Hyperlinking to our Content",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "The following organizations may link to our Website without prior written approval:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "Government agencies;",
                  ),
                  BulletText(
                    width: width,
                    text: "Search engines;",
                  ),
                  BulletText(
                    width: width,
                    text: "News organizations;",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We may consider and approve other link requests from the following types of organizations:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text:
                        "commonly-known consumer and/or business information sources;",
                  ),
                  BulletText(
                    width: width,
                    text: "dot.com community sites;",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "associations or other groups representing charities;",
                  ),
                  BulletText(
                    width: width,
                    text: "online directory distributors;",
                  ),
                  BulletText(
                    width: width,
                    text: "internet portals;",
                  ),
                  BulletText(
                    width: width,
                    text: "accounting, law and consulting firms; and",
                  ),
                  BulletText(
                    width: width,
                    text: "educational institutions and trade associations.",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Mr Healer Health Solution LTD; and (d) the link is in the context of general resource information.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Mr Healer Health Solution LTD. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Approved organizations may hyperlink to our Website as follows:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "By use of our corporate name; or",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "By use of the uniform resource locator being linked to; or",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "No use of Mr Healer Health Solution LTD's logo or other artwork will be allowed for linking absent a trademark license agreement.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "iFrames",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Content Liability",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Your Privacy",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Please read Privacy Policy",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Reservation of Rights",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Removal of links from our website",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Disclaimer",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text:
                        "limit or exclude our or your liability for death or personal injury;",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "limit or exclude our or your liability for fraud or fraudulent misrepresentation;",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "limit any of our or your liabilities in any way that is not permitted under applicable law; or",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "exclude any of our or your liabilities that may not be excluded under applicable law.",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.",
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
