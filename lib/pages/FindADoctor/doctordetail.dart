import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sarasotaapp/appsettings.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctor.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';
import 'package:sarasotaapp/uatheme.dart';

import 'RequestAppointment.dart';
import 'helper.dart';

class DoctorDetail extends StatefulWidget {
  final String doctorId;

  DoctorDetail(this.doctorId);

  @override
  _DoctorDetailState createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  Doctor doctor;

// 1
  Completer<GoogleMapController> _controller = Completer();

  var _isDoctorLoggedIn = false;
  var _sendingCell = false;
  var _isLoading = true;
  double _latitude;
  double _longitude;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getDoctorDetail();
  }

  _getDoctorDetail() async {
    _isDoctorLoggedIn = await FindDoctorPreferences.isDoctorLoggedIn();

    Doctor doctorDetail =
        await WebServiceHelper.getDoctorDetail(this.widget.doctorId);
    this.setState(() {
      this.doctor = doctorDetail;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffe8e8e8),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: CachedNetworkImage(
                              imageUrl: doctor.image,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                "${doctor.fullName}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppSettings.primaryColor),
                                textAlign: TextAlign.left,
                              )),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildDetail()),
                          _getDirection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _buildDetail() {
    var widgets = <Padding>[];

    if (doctor.phone != null) {
      widgets.add(
          Helper.buildRichText(title: Strings.telephone, body: doctor.phone));
    }

    if (_isDoctorLoggedIn) {
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: RaisedButton(
            onPressed: _sendCell,
            color: Color(
              0xff8CC63E,
            ),
            child: Text(_sendingCell ? Strings.sending : Strings.sendCell,
                style: TextStyle(
                  color: Colors.white,
                ))),
      ));
    }

    //address
    if (doctor.address != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.address,
          body:
              "${doctor.address.street}, ${doctor.address.city}, ${doctor.address.state}, ${doctor.address.postalCode}"));
    }

    //specialities
    if (doctor.specialities != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.specialities, body: doctor.specialities));
    }

    //board certifications
    if (doctor.boardCertifications != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.boardCertifications,
          body: doctor.boardCertifications));
    }

    //medical schools
    if (doctor.medicalSchools != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.medicalSchools, body: doctor.medicalSchools));
    }

    //internships
    if (doctor.internships != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.internship, body: doctor.internships));
    }

    //residencies
    if (doctor.residencies != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.residency, body: doctor.residencies));
    }

    //fellowship
    if (doctor.fellowship != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.fellowship, body: doctor.fellowship));
    }

    //website
    if (doctor.website != null) {
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            children: [
              TextSpan(
                  text: Strings.website,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text: doctor.website,
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Helper.launchURL('https://${doctor.website}');
                  },
              ),
            ],
          ),
        ),
      ));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          doctor.availabelForreferral == "Yes"
              ? Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: RaisedButton(
                      color: Color(0xff7e7e7e),
                      onPressed: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                new RequestAppointment(
                              doctorId: doctor.id,
                            ),
                          ),
                        );
                      },
                      child: Text(Strings.requestAppointment,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.zero,
                ),
          Expanded(
            flex: 0,
            child: RaisedButton(
              onPressed: () {
                Helper.launchURL(
                    'tel://${doctor.phone.replaceAll(new RegExp(r'[^0-9]'), '')}');
              },
              child: Text(Strings.callDoctor,
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ));

    widgets.add(
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: GoogleMap(
            // 2
            initialCameraPosition: CameraPosition(
              zoom: 12,
              target: LatLng(doctor.latitude ?? 0.0, doctor.longitude ?? 0.0),
            ),
            // 3
            mapType: MapType.normal,
            // 4
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.from([
              Marker(
                  position:
                      LatLng(doctor.latitude ?? 0.0, doctor.longitude ?? 0.0),
                  markerId: MarkerId('')),
            ]),
          ),
        ),
      ),
    );

    return widgets;
  }

  Container _getDirection() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      alignment: Alignment.topLeft,
      color: AppSettings.primaryColor,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: Strings.getDirection,
                style: new TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 16),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Helper.launchURL(
                        'https://www.google.com/maps/dir/$_latitude,$_longitude/${doctor.latitude ?? 0},${doctor.longitude ?? 0}');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getLocation() async {
    var location = new Location();
    bool enabled = await location.serviceEnabled();
    if (enabled) {
      try {
        LocationData locationData = await location.getLocation();
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
      } on Exception {
        _latitude = 0;
        _longitude = 0;
      }
    } else {
      bool gotEnabled = await location.requestService();
      if (gotEnabled) {
        await _getLocation();
      } else {
        _latitude = 0;
        _longitude = 0;
      }
    }
  }

  _sendCell() async {
    this.setState(() {
      _sendingCell = true;
    });

    var success = await WebServiceHelper.sendCell(doctor.id);
    if (success) {
      UATheme.alert(Strings.cellSent);
    }

    this.setState(() {
      _sendingCell = false;
    });
  }
}
