import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_agent/Screens/screens.dart';

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({Key? key}) : super(key: key);

  @override
  _RefundPolicyScreenState createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen>
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
                    "REFUND POLICY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dark,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Last updated: March 07, 2023",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Thank you for shopping at humbingo.com.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If, for any reason, You are not completely satisfied with a purchase We invite You to review our policy on refunds and returns. This Return and Refund Policy has been created with the help of the Return and Refund Policy Generator.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The following terms are applicable for any products that You purchased with Us.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Interpretation and Definitions",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Interpretation",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Definitions",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "For the purposes of this Return and Refund Policy:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text:
                        'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Mr Healer Health Solution LTD, House No: 26/1(2nd Floor), Road No: 4, Rupnagar R/A, Dhaka 1216..',
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Goods refer to the items offered for sale on the Service.",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Orders mean a request by You to purchase Goods from Us.",
                  ),
                  BulletText(
                    width: width,
                    text: "Service refers to the Website.",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "Website refers to humbingo.com, accessible from https://humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.",
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Your Order Cancellation Rights",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "You are entitled to cancel Your Order within 7 days without giving any reason for doing so.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The deadline for cancelling an Order is 7 days from the date on which You received the Goods or on which a third party you have appointed, who is not the carrier, takes possession of the product delivered.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "In order to exercise Your right of cancellation, You must inform Us of your decision by means of a clear statement. You can inform us of your decision by:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "By email: info@humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text: "By phone number: 06352192149",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We will reimburse You no later than 14 days from the day on which We receive the returned Goods. We will use the same means of payment as You used for the Order, and You will not incur any fees for such reimbursement.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Conditions for Returns",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "In order for the Goods to be eligible for a return, please make sure that:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "The Goods were purchased in the last 7 days",
                  ),
                  BulletText(
                    width: width,
                    text: "The Goods are in the original packaging",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "The following Goods cannot be returned:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text:
                        "The supply of Goods made to Your specifications or clearly personalized.",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "The supply of Goods which according to their nature are not suitable to be returned, deteriorate rapidly or where the date of expiry is over.",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "TThe supply of Goods which are not suitable for return due to health protection or hygiene reasons and were unsealed after delivery.",
                  ),
                  BulletText(
                    width: width,
                    text:
                        "The supply of Goods which are, after delivery, according to their nature, inseparably mixed with other items.",
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We reserve the right to refuse returns of any merchandise that does not meet the above return conditions in our sole discretion.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "Only regular priced Goods may be refunded. Unfortunately, Goods on sale cannot be refunded. This exclusion may not apply to You if it is not permitted by applicable law.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Returning Goods",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "You are responsible for the cost and risk of returning the Goods to Us. You should send the Goods at the following address:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "House No: 26/1(2nd Floor), Road No: 4, Rupnagar R/A, Dhaka 1216.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "We cannot be held responsible for Goods damaged or lost in return shipment. Therefore, We recommend an insured and trackable mail service. We are unable to issue a refund without actual receipt of the Goods or proof of received return delivery.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Gifts",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "If the Goods were marked as a gift when purchased and then shipped directly to you, You'll receive a gift credit for the value of your return. Once the returned product is received, a gift certificate will be mailed to You.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(
                    "If the Goods weren't marked as a gift when purchased, or the gift giver had the Order shipped to themselves to give it to You later, We will send the refund to the gift giver.",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "Contact Us",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.04),
                  Text(
                    "If you have any questions about our Returns and Refunds Policy, please contact us:",
                    style: TextStyle(
                        color: dark,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: width * 0.02),
                  BulletText(
                    width: width,
                    text: "By email: info@humbingo.com",
                  ),
                  BulletText(
                    width: width,
                    text: "By phone number: 06352192149",
                  ),
                  SizedBox(height: width * 0.02),
                ],
              ),
            ),
          )),
    );
  }
}
