import 'package:flutter/material.dart';

import 'package:store_redirect/store_redirect.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  TextEditingController mobileTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Apps',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Image.asset(
              'assets/images/smh_icon.jpg',
            ),
            title: Text(
              'Sarasota Memorial',
            ),
            subtitle: Text(
              'Download',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onTap: () {
              StoreRedirect.redirect(
                  androidAppId:
                      "com.soln.SE35BCA74A3BE95A854E67E90FEB1DBB3&hl=en_US",
                  iOSAppId: "397478168");
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/smh_icon.jpg',
            ),
            title: Text(
              'SMH Wayfinder',
            ),
            subtitle: Text(
              'Download',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onTap: () {
              StoreRedirect.redirect(
                  androidAppId:
                      "com.soln.SE35BCA74A3BE95A854E67E90FEB1DBB3&hl=en_US",
                  iOSAppId: "397478168");
            },
          ),
        ],
      ),
    );
  }
}
