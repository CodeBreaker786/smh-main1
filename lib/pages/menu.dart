import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';

import 'package:sarasotaapp/pages/privacypolicy.dart';

import 'package:url_launcher/url_launcher.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getTileText(
          'Call SMH',
          () {
            _launchURL.call('tel://9419179000');
          },
          Icons.call,
        ),
        line(),

        getTileText(
          'Patient Portal',
          () {
            _launchURL.call('tel://9419179000');
          },
          Icons.dashboard,
        ),
        line(),
         getTileText(
          'Careers',
          () {
            _launchURL.call('tel://9419179000');
          },
          Icons.next_plan,
        ),
        line(),
        getTileText(
          'Bill Pay',
          () {
            _launchURL.call('tel://9419179000');
          },
          Icons.payment,
        ),
        line(),
        getTileText(
          'Social Media',
          () {
            _launchURL.call('tel://9419179000');
          },
          Icons.open_in_browser_outlined,
        ),
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

  Widget getTileText(String text, Function callback, IconData iconData) {
    return InkWell(
      onTap: () async {
        callback();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              iconData,
              size: 30,
              color: UiColors.primaryColor,
            ),
          ),
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
