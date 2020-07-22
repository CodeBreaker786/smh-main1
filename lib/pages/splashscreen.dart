import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sarasotaapp/appsettings.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/home.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void handleTimeout() async {
    Navigation.closeOpen(context, new Home());
  }

  startTimeout() async {
    var duration = const Duration(seconds: 2);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          //color: Color(0xff639ec3),
          height: 250,
          width: 250,
          child: Center(child: Image.asset('assets/images/smhblueicon.png')),
        ),
      ),
    );
  }
}
