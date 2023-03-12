import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dynamic_agent/Screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings>
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

  static Stream<QuerySnapshot> readItems() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userdoc = auth.currentUser!.uid;
    final CollectionReference mainCollection = FirebaseFirestore.instance
        .collection("AGENTS")
        .doc(userdoc)
        .collection("EARNINGS");
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user = auth.currentUser;
    // String userdoc = user!.uid;

    // CollectionReference notesItemCollection =
    //     _mainCollection.doc(userdoc).collection('products');
    return mainCollection.snapshots();
  }

  // var _october = DateTime.october;
  // LineChartData get sampleData1 => LineChartData(
  //       lineTouchData: lineTouchData1,
  //       gridData: gridData,
  //       titlesData: titlesData1,
  //       borderData: borderData,
  //       lineBarsData: lineBarsData1,
  //       minX: 0,
  //       maxX: 14,
  //       maxY: 4,
  //       minY: 0,
  //     );

  // LineTouchData get lineTouchData1 => LineTouchData(
  //       handleBuiltInTouches: true,
  //       touchTooltipData: LineTouchTooltipData(
  //         tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
  //       ),
  //     );

  // FlTitlesData get titlesData1 => FlTitlesData(
  //       bottomTitles: bottomTitles,
  //       rightTitles: SideTitles(showTitles: false),
  //       topTitles: SideTitles(showTitles: false),
  //       leftTitles: leftTitles(
  //         getTitles: (value) {
  //           switch (value.toInt()) {
  //             case 1:
  //               return '10';
  //             case 2:
  //               return '20';
  //             case 3:
  //               return '30';
  //             case 4:
  //               return '40';
  //           }
  //           return '';
  //         },
  //       ),
  //     );

  // List<LineChartBarData> get lineBarsData1 => [
  //       lineChartBarData1_1,
  //     ];

  // SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
  //       getTitles: getTitles,
  //       showTitles: true,
  //       margin: 8,
  //       interval: 1,
  //       reservedSize: 40,
  //       getTextStyles: (context, value) => const TextStyle(
  //         color: Color(0xff75729e),
  //         fontWeight: FontWeight.bold,
  //         fontSize: 14,
  //       ),
  //     );

  // SideTitles get bottomTitles => SideTitles(
  //       showTitles: true,
  //       reservedSize: 22,
  //       margin: 10,
  //       interval: 1,
  //       getTextStyles: (context, value) => const TextStyle(
  //         color: Color(0xff72719b),
  //         fontWeight: FontWeight.bold,
  //         fontSize: 8,
  //       ),
  //       getTitles: (value) {
  //         switch (value.toInt()) {
  //           case 1:
  //             return 'JAN';
  //           case 2:
  //             return 'FEB';
  //           case 3:
  //             return 'MAR';
  //           case 4:
  //             return 'APR';
  //           case 5:
  //             return 'MAY';
  //           case 6:
  //             return 'JUN';
  //           case 7:
  //             return 'JUL';
  //           case 8:
  //             return 'AUG';
  //           case 9:
  //             return 'SEPT';
  //           case 10:
  //             return 'OCT';
  //           case 11:
  //             return 'NOV';
  //           case 12:
  //             return 'DEC';
  //         }
  //         return '';
  //       },
  //     );

  // FlGridData get gridData => FlGridData(show: false);
  // FlBorderData get borderData => FlBorderData(
  //       show: true,
  //       border: const Border(
  //         bottom: BorderSide(color: Color(0xff4e4965), width: 2),
  //         left: BorderSide(color: Colors.transparent),
  //         right: BorderSide(color: Colors.transparent),
  //         top: BorderSide(color: Colors.transparent),
  //       ),
  //     );

  // LineChartBarData get lineChartBarData1_1 => LineChartBarData(
  //       isCurved: true,
  //       colors: [const Color(0xff4af699)],
  //       barWidth: 2,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: [
  //         FlSpot(1, 0.4),
  //         FlSpot(3, 1.5),
  //         FlSpot(5, 1.4),
  //         FlSpot(7, 3.4),
  //         FlSpot(10, 2),
  //         FlSpot(12, 2.2),
  //         FlSpot(13, 1.8),
  //       ],
  //     );

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
          backgroundColor: Colors.transparent,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: width * 0.02),
                Text(
                  "My Earnings",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    color: dark,
                    fontSize: width * 0.06,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.02),
                  child: StreamBuilder(
                    stream: readItems(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        return SizedBox(
                          // color: Colors.red,
                          height: height,
                          width: width,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: height * 0.01,
                            ),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              var totalOrder = snapshot.data!.docs.length;

                              DateTime date =
                                  snapshot.data!.docs[index]['date'].toDate();
                              var amount = snapshot.data!.docs[index]['amount'];
                              var sum = 0.0;
                              for (int i = 0; i < totalOrder; i++) {
                                sum += (amount).toDouble();
                              }
                              var datee = DateFormat.MMMM().format(date);

                              //var data = snapshot.data;
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.04),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      "Graphs shows number of patients booked.",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    LineGraph(
                                      graphOpacity: 0.1,
                                      features: [
                                        Feature(
                                          title: "Earning",
                                          color: dark,
                                          data: [0.15, 0],
                                        ),
                                      ],
                                      size: Size(width * 0.3, width * 0.7),
                                      labelX: const [
                                        "Sept",
                                        'Oct',
                                        'Nov',
                                        'Dec',
                                        'Jan',
                                        'Feb'
                                      ],
                                      labelY: const [
                                        '5',
                                        '10',
                                        '15',
                                        '20',
                                        '25',
                                        '30'
                                      ],
                                      //showDescription: true,
                                      graphColor: Colors.black87,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                      ),
                                      // height: height,
                                      width: width,
                                      child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          tileColor: lightpink3,
                                          horizontalTitleGap: 0.0,
                                          title: Text(
                                            datee,
                                            style: GoogleFonts.raleway(
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                            "Total Order: ${totalOrder.toString()}",
                                            style: GoogleFonts.lato(
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          trailing: Text(
                                            "${sum.toString()} BDT",
                                            style: GoogleFonts.lato(
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
