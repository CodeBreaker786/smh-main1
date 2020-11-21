import 'package:flutter/material.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/privacypolicy.dart';
import 'package:sarasotaapp/pages/socialmedia.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'file:///D:/develapment/USA/lib/pages/home_page/home.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        cacheExtent: 10,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          Container(
            color: Color(0xff639EC7),
            child: ListTile(
              title: new UALabel(size: 30.0, text: 'smh', color: Colors.white),
            ),
          ),
          ListTile(
            onTap: () {
              Navigation.close(context);
              Navigation.closeOpen(context, Home());
            },
            title: UALabel(
              text: 'Back to Home',
              paddingTop: 15,
              paddingBottom: 15,
              color: Colors.grey.shade700,
            ),
          ),
          line(),
          ListTile(
            onTap: () async {
              _launchURL.call('tel://9419179000');
            },
            title: UALabel(
              text: 'Call SMH',
              paddingTop: 15,
              paddingBottom: 15,
              color: Colors.grey.shade700,
            ),
          ),
          line(),
          ListTile(
            onTap: () {
              Navigation.closeOpen(context, SocialMedia());
            },
            title: UALabel(
              text: 'Social Media',
              paddingTop: 15,
              paddingBottom: 15,
              color: Colors.grey.shade700,
            ),
          ),
          // line(),
          // ListTile(
          //   onTap: () {
          //     Navigation.closeOpen(context, Favorites());
          //   },
          //   title: UALabel(
          //     text: 'Favorites',
          //     paddingTop: 15,
          //     paddingBottom: 15,
          //     color: Colors.grey.shade700,
          //   ),
          // ),
          line(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) => new PrivacyPolicy(
                    url: "https://www.smh.com/privacy",
                  ),
                ),
              );
            },
            title: UALabel(
              text: 'Privacy Statement',
              paddingTop: 15,
              paddingBottom: 15,
              color: Colors.grey.shade700,
            ),
          ),
          line(),
          SizedBox(
            height: 300.0,
          ),
          GestureDetector(
            onTap: () {
              _launchURL('https://smh.com');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/smhblueicon.png',
                  height: 150.0,
                  width: 150.0,
                ),
              ],
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
      await launch(url, enableJavaScript: true, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
