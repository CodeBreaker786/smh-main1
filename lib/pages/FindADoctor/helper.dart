import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static Widget buildRichText({String title, String body}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: title, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: body),
          ],
        ),
      ),
    );
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
