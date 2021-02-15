import 'package:flutter/material.dart';
import 'package:sarasotaapp/appsettings.dart';
import 'package:sarasotaapp/model/serviceitem.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/smhevents.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/uabutton.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceItem info;

  ServiceDetails({this.info});

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: UALabel(
            text: 'Services',
            size: UATheme.headingSize(),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(widget.info.image),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UALabel(
                      text: widget.info.title,
                      color: Colors.grey,
                      paddingLeft: 20,
                      paddingBottom: 10,
                      paddingTop: 20,
                      paddingRight: 20,
                      bold: true,
                      size: UATheme.headingSize(),
                    ),
                    UALabel(
                      text: widget.info.description,
                      color: Colors.grey,
                      paddingLeft: 20,
                      paddingBottom: 20,
                      paddingTop: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: UAButton(
                        paddingLeft: 40,
                        paddingRight: 40,
                        onPressed: () {
                          Navigation.open(
                              context,
                              SMHEvents(
                                url: widget.info.url,
                              ));
                        },
                        text: 'LEARN MORE',
                        height: 50,
                        color: AppSettings.primaryColor,
                        textColor: AppSettings.appBackground,
                        paddingBottom: 10,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
