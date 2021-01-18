import 'package:flutter/material.dart';
import 'package:sarasotaapp/pages/menu.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UALabel(
          text: 'Social',
          size: UATheme.headingSize(),
        ),
      ),
      
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              _launchURL('https://www.facebook.com/SarasotaMemorialHospital/');
            },
            title: UALabel(
              paddingBottom: 20,
              paddingTop: 20,
              paddingLeft: 20,
              text: 'Facebook',
            ),
          ),
          line(),
          ListTile(
            onTap: () async {
              _launchURL('https://twitter.com/SMHCS');
            },
            title: UALabel(
              paddingBottom: 20,
              paddingTop: 20,
              paddingLeft: 20,
              text: 'Twitter',
            ),
          ),
          line(),
          ListTile(
            onTap: () async {
              _launchURL('https://www.youtube.com/user/SMHCS');
            },
            title: UALabel(
              paddingBottom: 20,
              paddingTop: 20,
              paddingLeft: 20,
              text: 'YouTube',
            ),
          ),
          line(),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  line() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}
