import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

import '../../uatheme.dart';

class RequestAppointment extends StatefulWidget {
  final String doctorId;

  RequestAppointment({this.doctorId});

  @override
  _RequestAppointmentState createState() => _RequestAppointmentState();
}

class _RequestAppointmentState extends State<RequestAppointment> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController(text: '');
  TextEditingController _emailController = new TextEditingController(text: '');
  TextEditingController _phonrNumberController =
      new TextEditingController(text: '');
  TextEditingController _reasonController = new TextEditingController(text: '');

  bool _sendingRequest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UALabel(
          text: Strings.requestAppointment,
          size: UATheme.headingSize(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: RichText(
                          text: TextSpan(
                              text: Strings.yourName,
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red))
                              ]),
                        ),
                      ),
                      TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe8e8e8), width: 2.0),
                            ),
                            hintText: Strings.enterYourName,
                          ),
                          validator: (value) {
                            if (value.length < 2 && value.length > 0) {
                              return Strings.nameLengthError;
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: RichText(
                          text: TextSpan(
                              text: Strings.yourEmail,
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red))
                              ]),
                        ),
                      ),
                      TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe8e8e8), width: 2.0),
                            ),
                            hintText: Strings.enterYourEmail,
                          ),
                          validator: (value) {
                            return _validateEmail(value);
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: RichText(
                          text: TextSpan(
                              text: Strings.phoneNumber,
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red))
                              ]),
                        ),
                      ),
                      TextFormField(
                          controller: _phonrNumberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe8e8e8), width: 2.0),
                            ),
                            hintText: Strings.enterYourPhoneNumber,
                          ),
                          validator: (value) {
                            return _validatePhoneNumber(value);
                          }),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: RichText(
                          text: TextSpan(
                              text: Strings.reasonForAppointment,
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red))
                              ]),
                        ),
                      ),
                      TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe8e8e8), width: 2.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.length < 2 && value.length > 0) {
                              return Strings.nameLengthError;
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: _sendingRequest
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState.validate()) {
                              if (_nameController.text.isNotEmpty &&
                                  _emailController.text.isNotEmpty &&
                                  _phonrNumberController.text.isNotEmpty &&
                                  _reasonController.text.isNotEmpty) {
                                this.setState(() {
                                  _sendingRequest = true;
                                });

                                var message =
                                    await WebServiceHelper.requestAppointment(
                                        id: this.widget.doctorId,
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        phoneNumber:
                                            _phonrNumberController.text,
                                        reason: _reasonController.text);

                                _showSuccessAlert(message);
                                _nameController.clear();
                                _emailController.clear();
                                _phonrNumberController.clear();
                                _reasonController.clear();
                                this.setState(() {
                                  _sendingRequest = false;
                                });
                              } else {
                                UATheme.alert(Strings.allFieldsAreMandatory);
                              }
                            }
                          },
                          child: Text(Strings.requestAppointment,
                              style: TextStyle(color: Colors.white)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSuccessAlert(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: UATheme.normalSize(),
    );
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) && value.length > 0)
      return Strings.invalidEmailError;
    else
      return null;
  }

  String _validatePhoneNumber(String value) {
    Pattern pattern = r'^-?[0-9]+$';
    RegExp regex = new RegExp(pattern);
    if ((!regex.hasMatch(value) || (value.length < 10)) && value.length > 0)
      return Strings.invalidMobileError;
    else
      return null;
  }
}
