import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sarasotaapp/model/doctor.dart';
import 'package:sarasotaapp/pages/FindADoctor/RequestAppointment.dart';
import 'package:sarasotaapp/pages/FindADoctor/helper.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';
import 'package:sarasotaapp/utils/customLoader.dart';
import 'package:sarasotaapp/utils/show_flushbar.dart';

class DoctorDetailView extends StatefulWidget {
  Doctor doctor;
  bool isDoctorLogin;
  DoctorDetailView({this.doctor, this.isDoctorLogin});

  @override
  _DoctorDetailViewState createState() => _DoctorDetailViewState();
}

class _DoctorDetailViewState extends State<DoctorDetailView> {
  double _latitude;
  double _longitude;
  bool isLoding = false;
  CustomLoader customLoader;
  @override
  void initState() {
    _getLocation();
    customLoader = CustomLoader();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 50),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back_ios_outlined)),
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 35,
                        )
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            widget.doctor.fullName,
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: MaterialButton(
                                  height: 40,
                                  minWidth: 0,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  onPressed: () async {
                                    await Helper.launchURL(
                                        'tel://${widget.doctor.phone.replaceAll(RegExp(r'[^0-9]'), '')}');
                                  },
                                  color: Colors.white,
                                  child: Icon(
                                    Icons.call,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              widget.isDoctorLogin
                                  ? MaterialButton(
                                      height: 40,
                                      minWidth: 0,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      onPressed: () async {
                                        await Helper.launchURL(
                                            'tel://${widget.doctor.mobilePhone.replaceAll(RegExp(r'[^0-9]'), '')}');
                                      },
                                      color: Colors.white,
                                      child: Icon(
                                        Icons.phone_android_outlined,
                                        color: Colors.green,
                                      ),
                                    )
                                  : SizedBox(),
                              widget.isDoctorLogin
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: MaterialButton(
                                          height: 40,
                                          minWidth: 0,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          onPressed: () async {
                                            customLoader.showLoader(context);
                                            bool isSuccessfull =
                                                await WebServiceHelper
                                                    .sendCell(
                                                        widget.doctor.id);
                                            if (isSuccessfull) {
                                              customLoader.hideLoader();
                                              showSnackBar(
                                                  context: context,
                                                  value:
                                                      'Cell is Sent Successfully',
                                                  icon: Icon(Icons.check));
                                            } else {
                                              customLoader.hideLoader();
                                              showSnackBar(
                                                  context: context,
                                                  isError: true,
                                                  value:
                                                      'Something go wrong please try again',
                                                  icon: Icon(Icons.error));
                                            }
                                          },
                                          color: Colors.green,
                                          child: Text(
                                            'Send Cell',
                                            style: TextStyle(
                                                color: Colors.white),
                                          )),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(minHeight: 150,minWidth: 50,maxWidth: 120),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.network(widget.doctor.image,
                            fit: BoxFit.cover, errorBuilder:
                                (BuildContext context, Object exception,
                                    StackTrace stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 100,
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                
                  child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
                      child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestAppointment()));
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Request Appointment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.doctor.address.street != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Address')
                                    : Container(),
                                widget.doctor.address.street != null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                            '${widget.doctor.address.street} ${widget.doctor.address.city} ${widget.doctor.address.state} ${widget.doctor.address.postalCode}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18)),
                                      )
                                    : Container(),
                                widget.doctor.specialities != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Specialties')
                                    : Container(),
                                widget.doctor.specialities != null
                                    ? getDoctorInformationTileSubTitle(
                                        subTitle: widget.doctor.specialities)
                                    : Container(),
                                widget.doctor.boardCertifications != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Board Certification')
                                    : Container(),
                                widget.doctor.boardCertifications != null
                                    ? getDoctorInformationTileSubTitle(
                                        subTitle:
                                            widget.doctor.boardCertifications)
                                    : Container(),
                                widget.doctor.medicalSchools != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Medical School')
                                    : Container(),
                                widget.doctor.medicalSchools != null
                                    ? getDoctorInformationTileSubTitle(
                                        subTitle: widget.doctor.medicalSchools)
                                    : Container(),
                                widget.doctor.internships != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Internship')
                                    : Container(),
                                widget.doctor.internships != null
                                    ? getDoctorInformationTileSubTitle(
                                        subTitle: widget.doctor.internships)
                                    : Container(),
                                widget.doctor.residencies != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Residency')
                                    : Container(),
                                widget.doctor.residencies != null
                                    ? getDoctorInformationTileSubTitle(
                                        subTitle: widget.doctor.residencies)
                                    : Container(),
                                widget.doctor.website != null
                                    ? getDoctorInformationTileTitle(
                                        title: 'Website')
                                    : Container(),
                                widget.doctor.website != null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: InkWell(
                                          onTap: () {
                                            Helper.launchURL(
                                                'https://${widget.doctor.website}');
                                          },
                                          child: Text(widget.doctor.website,
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18)),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ]));
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: CircularProgressIndicator(),
          content: new Text("Please wait"),
        );
      },
    );
  }

  _getLocation() async {
    var location = Location();
    bool enabled = await location.serviceEnabled();
    if (enabled) {
      try {
        LocationData locationData = await location.getLocation();
        setState(() {
          _latitude = locationData.latitude;
          _longitude = locationData.longitude;
        });
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

  getDoctorInformationTileTitle({String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  getDoctorInformationTileSubTitle({String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(subTitle, style: TextStyle(color: Colors.grey, fontSize: 18)),
    );
  }
}
