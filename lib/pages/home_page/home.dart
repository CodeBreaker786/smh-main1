import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/model/locationitem.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctorsearch.dart';
import 'package:sarasotaapp/pages/home_page/nearest_locations.dart';
import 'package:sarasotaapp/pages/locations/locationdetails.dart';
import 'package:sarasotaapp/pages/menu.dart';
import 'package:sarasotaapp/pages/services/ourservices.dart';
import 'package:sarasotaapp/pages/surgerystatus.dart';
import 'package:sarasotaapp/pages/symptom/step1.dart';

class Home extends StatefulWidget {
  List<LocationItem> cardsData = List();
  Home({this.cardsData});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool seeAll = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      resizeToAvoidBottomPadding: false,
      body: Container(
          color: UiColors.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            return InkWell(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Icon(Icons.menu));
                          },
                        ),
                        Text(
                          'Sarasota Memorial',
                          style: TextStyle(fontSize: 18),
                          // style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          bottom: 6, // HERE THE IMPORTANT PART
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        //  prefixIcon: Icon(Icons.search,)
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'How may we help you?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                trailing: Text(
                  'SEE ALL',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 14),
                  height: MediaQuery.of(context).size.height * .25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png',
                          callBack: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return DoctorSearch();
                              }),
                            );
                          }),
                      _buildListTile(
                          title: 'Our Serives',
                          path: 'assets/images/main/our_serives.png',
                          callBack: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return OurServices();
                              }),
                            );
                          }),
                      _buildListTile(
                          title: 'Symptom Checker',
                          path: 'assets/images/main/sympton_checker.png',
                          callBack: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return SymptomChecker();
                              }),
                            );
                          }),
                      _buildListTile(
                          title: 'Surgery Status',
                          path: 'assets/images/main/surgery_status.png',
                          callBack: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return SurgeryStatus(
                                  url: 'https://surgerystatus.smh.com',
                                );
                              }),
                            );
                          }),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                      _buildListTile(
                          title: 'Find a Doctor',
                          path: 'assets/images/main/find_a_doctor.png'),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              'Nearest Locations',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NearestLocations(cardsData: widget.cardsData)));
                              },
                              child: Text(
                                'SEE ALL',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 14),
                            height: MediaQuery.of(context).size.height * .33,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...widget.cardsData.map(
                                    (e) => _buildListCard(
                                        path: e.image, 
                                        title: e.title,
                                        callBack: () {
                                           Navigation.open(
                    context,
                    LocationDetails(
                      info:  e,
                      distance: e.distance != null
                          ? '${e.distance} mi'
                          : '',
                      latitude: e.latitude,
                      longitude: e.longitude,
                      address: e.mapAddress,
                      //address:list[i].address,
                    ),
                  );
                                        }),
                                  )
                                ]),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              child: Text(
                                'smh',
                                style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: UiColors.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          )),
    );
  }

  _buildListTile({String title, String path, Function callBack}) {
    return InkWell(
      onTap: callBack,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 80,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(path),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListCard({String title, String path, Function callBack}) {
    return InkWell(
      onTap: () {
        callBack();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Container(
               width: MediaQuery.of(context).size.width * .5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
           
                height: MediaQuery.of(context).size.height * .2,
                decoration: BoxDecoration(
                    color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(
                  title,
                  //overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: Text(
                  'Sarasota , Florida',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:sarasotaapp/appsettings.dart';
// import 'package:sarasotaapp/pages/locations/ourlocations.dart';
// import 'package:sarasotaapp/pages/menu.dart';
// import 'package:sarasotaapp/pages/services/ourservices.dart';
// import 'package:sarasotaapp/pages/smhevents.dart';
// import 'package:sarasotaapp/pages/surgerystatus.dart';
// import 'package:sarasotaapp/pages/symptom/step1.dart';
// import 'package:sarasotaapp/uatheme.dart';
// import 'package:sarasotaapp/widgets/ualabel.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'FindADoctor/doctorsearch.dart';
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// void _getCurrentLocation() async {
//   final position = await Geolocator()
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   print(position);
// }
//
// class _HomeState extends State<Home> {
//   TextEditingController mobileTextEditingController;
//
//   @override
//   Widget build(BuildContext context) {
//     UATheme.init(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppSettings.primaryColor,
//         title: UALabel(
//           text: 'Sarasota Memorial',
//         ),
//       ),
//       drawer: Menu(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(builder: (BuildContext context) {
//                           return DoctorSearch();
//                         }),
//                       );
//                     },
//                     child: Image(
//                       image: AssetImage("assets/images/main/findadoctor1.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         new MaterialPageRoute(
//                           builder: (BuildContext context) => new OurServices(),
//                         ),
//                       );
//                     },
//                     child: Image(
//                       image: new AssetImage("assets/images/main/our_services1.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         new MaterialPageRoute(
//                           builder: (BuildContext context) => new SymptomChecker(),
//                         ),
//                       );
//                     },
//                     child: Image(
//                       image: new AssetImage("assets/images/main/symptomchecker.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         new MaterialPageRoute(
//                           builder: (BuildContext context) => new SurgeryStatus(
//                             url: 'https://surgerystatus.smh.com',
//                           ),
//                         ),
//                       );
//                     },
//                     child: Image(
//                       image: new AssetImage("assets/images/main/surgerystatus1.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _getCurrentLocation();
//                       Navigator.of(context).push(
//                         new MaterialPageRoute(
//                           builder: (BuildContext context) => new OurLocations(),
//                         ),
//                       );
//                     },
//                     child: Image(
//                       image: new AssetImage("assets/images/main/locations1.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         new MaterialPageRoute(
//                           builder: (BuildContext context) => new SMHEvents(
//                             url: 'https://www.smh.com/Calendar',
//                             title: 'SMH Events',
//                           ),
//                         ),
//                       );
//                     },
//                     child: Image(
//                       image: new AssetImage("assets/images/main/wayfinder1.png"),
//                       width: UATheme.screenWidth * 0.45,
//                       height: UATheme.screenWidth * 0.45,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Image(
//                 image: new AssetImage("assets/images/smhblueicon.png"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   line() {
//     return Container(
//       height: 1,
//       color: Colors.grey.shade300,
//     );
//   }
//
//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url,
//           forceSafariVC: false, forceWebView: false, enableJavaScript: true);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
