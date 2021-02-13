import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/pages/home_page/apps.dart';

import 'package:sarasotaapp/pages/privacypolicy.dart';
import 'package:sarasotaapp/pages/home_page/socialmedia.dart';

import 'package:url_launcher/url_launcher.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getTileText(
            text: 'Call SMH',
            callback: () {
              _launchURL.call('tel://9419179000');
            },
            url: 'assets/images/call_logo.png'),
        line(),
        getTileText(
            text: 'Patient Portal',
            callback: () {
              _launchURL(
                  'https://smh.followmyhealth.com/Login/Home/Index?authproviders=0&returnArea=PatientAccess#!/default');
            },
            url: 'assets/images/patient_portal.png'),
        line(),
        getTileText(
            text: 'Careers',
            callback: () {
              _launchURL.call('https://careers.smh.com/careers/');
            },
            url: 'assets/images/careers.png'),
        line(),
        getTileText(
            text: 'Bill Pay',
            callback: () {
              _launchURL.call('https://smh.ci.healthpay24.cloud/');
            },
            url: 'assets/images/bill_pay.png'),
        line(),
        getTileText(
            text: 'Apps',
            callback: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => Apps()),
              );
            },
            url: 'assets/images/more_apps.png'),
        line(),
        getTileText(
            text: 'Social Media',
            callback: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => SocialMedia()),
              );
            },
            url: 'assets/images/social_media.png'),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new PrivacyPolicy(
                  url: "https://www.smh.com/privacy",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget getTileText({String text, Function callback, String url}) {
    return InkWell(
      onTap: () async {
        callback();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 45,
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: Image.asset(url))),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
          )
        ],
      ),
    );
  }

  line() {
    return Divider(
      thickness: 1,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, enableJavaScript: true, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
