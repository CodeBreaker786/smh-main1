import 'package:flutter/material.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctorlogin.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

import '../../uatheme.dart';
import 'doctorsearchresult.dart';

class DoctorSearch extends StatefulWidget {
  @override
  _DoctorSearchState createState() => _DoctorSearchState();
}

class _DoctorSearchState extends State<DoctorSearch> {
  final _formKey = GlobalKey<FormState>();

  //
  String _currentSelectedValue;

  //
  var _specialities = [];
  var _isLoading = true;
  var _isDoctorLoggedIn = false;
  var _showSecondarySearch = false;
  var _acceptingNewPatientSwitchValue = true;

  //
  TextEditingController _nameController = new TextEditingController(text: '');
  TextEditingController _zipCodeController =
      new TextEditingController(text: '');
  TextEditingController _keywordController =
      new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _getSpecialities();
  }

  _getSpecialities() async {
    var specialities = await WebServiceHelper.getSpecialities();
    var isDoctorLoggedIn = await FindDoctorPreferences.isDoctorLoggedIn();

    this.setState(() {
      _specialities = specialities;
      _specialities.sort();
      _isLoading = false;
      _isDoctorLoggedIn = isDoctorLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UALabel(
          text: Strings.doctorSearchTitle,
          size: UATheme.headingSize(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffe8e8e8), width: 2.0),
                              ),
                              hintText: Strings.firstOrLastName,
                            ),
                            validator: (value) {
                              if (value.length < 2 && value.length > 0) {
                                return Strings.nameLengthError;
                              }
                              return null;
                            })),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffe8e8e8), width: 2.0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(Strings.browseBYSpeciality),
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: _specialities.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextFormField(
                            controller: _zipCodeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffe8e8e8), width: 2.0),
                              ),
                              hintText: Strings.enterZipCode,
                            ),
                            validator: (value) {
                              if (value.length < 5 && value.length > 0) {
                                return Strings.zipCodeLengthError;
                              }
                              return null;
                            })),
                    _showKeywordSearch(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_nameController.text.isNotEmpty ||
                                _zipCodeController.text.isNotEmpty ||
                                _keywordController.text.isNotEmpty ||
                                _currentSelectedValue != null) {
                              _goToSearchResults();
                            } else {
                              UATheme.alert(Strings.noCriteriaSelected);
                            }
                          }
                        },
                        child: Text(Strings.search,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    _showAcceptingNewPatientsSwitch(),
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: RaisedButton(
                          color: _isDoctorLoggedIn
                              ? Colors.grey
                              : Color(0xff689d1f),
                          onPressed:
                              _isDoctorLoggedIn ? null : _goToDoctorLogin,
                          child: Text(
                              _isDoctorLoggedIn
                                  ? Strings.alreadyloggedin
                                  : Strings.login,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Padding _showKeywordSearch() {
    if (_showSecondarySearch) {
      return Padding(
          padding: EdgeInsets.all(16.0),
          child: TextFormField(
              controller: _keywordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe8e8e8), width: 2.0),
                ),
                hintText: Strings.enterKeyword,
              ),
              validator: (value) {
                if (value.length < 2 && value.length > 0) {
                  return Strings.keywordLengthError;
                }
                return null;
              }));
    }

    return Padding(
      padding: EdgeInsets.zero,
    );
  }

  Row _showAcceptingNewPatientsSwitch() {
    if (_showSecondarySearch) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Only Accepting New Patients',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _acceptingNewPatientSwitchValue,
            onChanged: (value) {
              setState(() {
                _acceptingNewPatientSwitchValue = value;
              });
            },
            activeTrackColor: Colors.green,
            activeColor: Colors.green,
          ),
        ],
      );
    }
    return Row();
  }

  _goToDoctorLogin() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => new DoctorLogin()),
    );
    if (result != null) {
      this.setState(() {
        this._isDoctorLoggedIn = true;
      });
    }
  }

  _goToSearchResults() async {
    final result = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) => new DoctorSearchResult(
            _showSecondarySearch,
            _nameController.text,
            _currentSelectedValue,
            _zipCodeController.text,
            _keywordController.text,
            _acceptingNewPatientSwitchValue),
      ),
    );

    if (result != null) {
      this.setState(() {
        this._showSecondarySearch = true;
      });
    }

    _nameController.clear();
    _zipCodeController.clear();
    _keywordController.clear();
    this.setState(() {
      _currentSelectedValue = null;
    });
  }
}
