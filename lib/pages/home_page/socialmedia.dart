import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sarasotaapp/pages/home_page/menu.dart';
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
            leading: Icon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
            ),
            onTap: () async {
              _launchURL('https://www.facebook.com/SarasotaMemorialHospital/');
            },
            title: UALabel(
              text: 'Facebook',
            ),
          ),
          line(),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.twitter,
              color: Colors.blue,
            ),
            onTap: () async {
              _launchURL('https://twitter.com/SMHCS');
            },
            title: UALabel(
              text: 'Twitter',
            ),
          ),
          line(),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.youtube,
              color: Colors.red,
            ),
            onTap: () async {
              _launchURL('https://www.youtube.com/user/SMHCS');
            },
            title: Text(
              'YouTube',
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
