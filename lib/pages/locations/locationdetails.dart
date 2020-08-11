import 'dart:io' show Platform;

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarasotaapp/appsettings.dart';
import 'package:sarasotaapp/model/locationitem.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/uabutton.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../webview.dart';

class LocationDetails extends StatefulWidget {
  final LocationItem info;
  final String distance;
  final double latitude;
  final double longitude;
  final String address;

  LocationDetails(
      {this.info, this.distance, this.longitude, this.latitude, this.address});

  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: UALabel(
            text: 'Location',
            size: UATheme.headingSize(),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                widget.info.image,
                width: UATheme.screenWidth,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UALabel(
                      text: widget.info.title,
                      paddingLeft: 20,
                      paddingTop: 20,
                      bold: true,
                      size: UATheme.headingSize(),
                      color: Colors.grey.shade500,
                    ),
                    UALabel(
                      text: widget.distance,
                      paddingLeft: 20,
                      paddingBottom: 20,
                      paddingTop: 10,
                      color: AppSettings.primaryColor,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    UALabel(
                      text: widget.info.address,
                      paddingLeft: 20,
                      paddingBottom: 10,
                      paddingTop: 20,
                      color: Colors.grey.shade500,
                    ),
                    UAButton(
                      paddingLeft: 20,
                      text: 'Get directions',
                      size: UATheme.headingSize(),
                      paddingBottom: 10,
                      color: Colors.transparent,
                      textColor: AppSettings.primaryColor,
                      onPressed: () async {
                        // print(widget.address.substring(0, 20));
                        final address = await Geocoder.local
                            .findAddressesFromCoordinates(
                                Coordinates(widget.latitude, widget.longitude));
                        // print(address.first.toMap());
                        String origin = ""; // lat,long like 123.34,68.56
                        String destination =
                            '${widget.latitude},${widget.longitude}';
                        if (Platform.isAndroid) {
                          PermissionGroup.locationAlways;
                          final AndroidIntent intent = new AndroidIntent(
                              action: 'action_view',
                              data: Uri.encodeFull(
                                  "https://www.google.com/maps/place/${widget.address}"),
                              package: 'com.google.android.apps.maps');
                          intent.launch();
                        } else {
                          PermissionGroup.locationAlways;

                          //  print(address.first.toMap());
                          final destination =
                              "https://www.google.com/maps/place/${widget.address}";
                          print(destination);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebView(
                                        url: destination,
                                        title: 'Directions',
                                      )));
                        }
                      },
                    ),
                    Container(
                      width: 200,
                      child: UAButton(
                        paddingLeft: 20,
                        onPressed: () {
                          _launchURL('tel://${widget.info.url}');
                        },
                        text: 'CALL',
                        height: 50,
                        color: AppSettings.primaryColor,
                        textColor: AppSettings.appBackground,
                      ),
                    ),
                    UALabel(
                      text: widget.info.description,
                      paddingLeft: 20,
                      paddingBottom: 20,
                      paddingTop: 20,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
