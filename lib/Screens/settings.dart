import 'package:flutter/material.dart';
import 'package:dynamic_agent/Auth/login.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:dynamic_agent/Services/auth_provider.dart';

class Settings1 extends StatefulWidget {
  const Settings1({Key? key}) : super(key: key);

  @override
  _Settings1State createState() => _Settings1State();
}

class _Settings1State extends State<Settings1>
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const Home()));
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
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.black,
        // ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutUsScreen())),
              child: _tile(height, width, "About Us")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen())),
              child: _tile(height, width, "Privacy Policy")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndCondition())),
              child: _tile(height, width, "Terms & Condition")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RefundPolicyScreen())),
              child: _tile(height, width, "Refund Policy")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactUsScreen())),
              child: _tile(height, width, "Contact Us")),
          GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportScreen())),
              child: _tile(height, width, "Report")),
          SizedBox(
            height: height * 0.01,
          ),
          _buttons(height, width, "Delete Account", Colors.black),
          GestureDetector(
              onTap: () {
                AuthClass().logOut();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              child: _buttons(height, width, "Logout", Colors.red)),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }

  Widget _buttons(height, width, String title, Color colour) {
    return Container(
      //margin: EdgeInsets.only(left: width * 0.07, right: width * 0.07),
      height: height * 0.07,
      //width: width * 0.4,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
          color: colour,
          fontSize: height * 0.025,
          fontWeight: FontWeight.w700,
        ),
      )),
    );
  }

  Widget _tile(height, width, String title) {
    return SizedBox(
      height: height * 0.08,
      child: ListTile(
        tileColor: Colors.white,
        leading: Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: height * 0.025,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: height * 0.03,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
