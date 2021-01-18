import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

import '../../uatheme.dart';
import 'webservices.dart';

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  TextEditingController cellController = new TextEditingController();
  TextEditingController dictationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: UALabel(
            text: 'Login',
            size: UATheme.headingSize(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: _isLoading
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: cellController,
                    decoration: const InputDecoration(
                      labelText: 'Cell',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffe8e8e8), width: 2.0),
                      ),
                      hintText: Strings.cellPlaceholder,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.noCellError;
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: dictationController,
                    decoration: const InputDecoration(
                      labelText: 'Dictation',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffe8e8e8), width: 2.0),
                      ),
                      hintText: Strings.dictationPlaceholder,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.noDictationError;
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                      color: UiColors.primaryColor,
                        onPressed: () async {
                          

                          if (_formKey.currentState.validate()) {
                            // Process data.
                            this.setState(() {
                              _isLoading = true;
                            });
                            var isLoginSuccessful =
                                await WebServiceHelper.login(
                                    cellController.text,
                                    dictationController.text);

                            if (isLoginSuccessful) {
                              Navigator.pop(context,true);
                            } else {
                              UATheme.alert('Login parameters not correct');
                            }

                            this.setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text(Strings.submit,
                            style: TextStyle(color: Colors.white)),
                      ),
              ),
            ],
          ),
        ));
  }
}
