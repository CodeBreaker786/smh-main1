import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sarasotaapp/appsettings.dart';
import 'package:sarasotaapp/pages/locations/ourlocations.dart';
import 'package:sarasotaapp/pages/menu.dart';
import 'package:sarasotaapp/pages/services/ourservices.dart';
import 'package:sarasotaapp/pages/smhevents.dart';
import 'package:sarasotaapp/pages/surgerystatus.dart';
import 'package:sarasotaapp/pages/symptom/step1.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'FindADoctor/doctorsearch.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

void _getCurrentLocation() async {
  final position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);
}

class _HomeState extends State<Home> {
  TextEditingController mobileTextEditingController;

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppSettings.primaryColor,
        title: UALabel(
          text: 'Sarasota Memorial',
        ),
      ),
      drawer: Menu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return DoctorSearch();
                        }),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m1.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new OurServices(),
                        ),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m2.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new Step1(),
                        ),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m3.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new SurgeryStatus(
                            url: 'https://surgerystatus.smh.com',
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m4.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _getCurrentLocation();
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new OurLocations(),
                        ),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m5.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new SMHEvents(
                            url: 'https://www.smh.com/Calendar',
                            title: 'SMH Events',
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: new AssetImage("assets/images/m6.png"),
                      width: UATheme.screenWidth * 0.45,
                      height: UATheme.screenWidth * 0.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Image(
                image: new AssetImage("assets/images/smhblueicon.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  line() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: false, forceWebView: false, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
