import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sarasotaapp/pages/FindADoctor/RequestAppointment.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctordetail.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

import '../../uatheme.dart';
import 'Webservices.dart';
import 'doctor.dart';
import 'helper.dart';

class DoctorSearchResult extends StatefulWidget {
  final bool isSecondarySearch;
  final String name;
  final String speciality;
  final String zipCode;
  final String keyword;
  final bool showResultsAcceptingNewpatients;

  DoctorSearchResult(this.isSecondarySearch, this.name, this.speciality,
      this.zipCode, this.keyword, this.showResultsAcceptingNewpatients);

  @override
  _DoctorSearchResultState createState() => _DoctorSearchResultState();
}

class _DoctorSearchResultState extends State<DoctorSearchResult> {
  List<Doctor> _searchResults = [];
  bool _isLoading = true;
  int _page = 1;
  int _totalResultCount = 0;
  ScrollController _scrollController = ScrollController();
  bool _gettingMoreResults = false;
  int _sortBy = 0;
  bool creatingPDF = false;
  bool _sendingCell = false;
  bool _isDoctorLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _checkDoctorLoggedInState();

    _getSearchResults();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.40;

      if ((maxScroll - currentScroll) < delta) {
        _getMoreSearchResults();
      }
    });
  }

  _checkDoctorLoggedInState() async {
    _isDoctorLoggedIn = await FindDoctorPreferences.isDoctorLoggedIn();
  }

  _getSearchResults() async {
    _isLoading = true;
    final data = await WebServiceHelper.getDoctors(
        isSecondarySearch: this.widget.isSecondarySearch,
        name: this.widget.name,
        speciality: this.widget.speciality,
        zipCode: this.widget.zipCode,
        keyword: this.widget.keyword,
        acceptingNewPatientSwitchValue:
            this.widget.showResultsAcceptingNewpatients,
        page: _page,
        sortBy: _sortBy);

    _page++;

    this.setState(() {
      _totalResultCount = data.totalRecords;
      _searchResults = data == null ? [] : data.list;
      _isLoading = false;
    });
  }

  _getMoreSearchResults() async {
    if (_searchResults.length == _totalResultCount) {
      return;
    }

    if (_gettingMoreResults) {
      return;
    }

    this.setState(() {
      _gettingMoreResults = true;
    });

    final data = await WebServiceHelper.getDoctors(
        isSecondarySearch: this.widget.isSecondarySearch,
        name: this.widget.name,
        speciality: this.widget.speciality,
        zipCode: this.widget.zipCode,
        keyword: this.widget.keyword,
        acceptingNewPatientSwitchValue:
            this.widget.showResultsAcceptingNewpatients,
        page: _page,
        sortBy: _sortBy);

    _page++;

    this.setState(() {
      _searchResults.addAll(data.list);
      _gettingMoreResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UALabel(
          text: Strings.doctorSearchResultsTitle,
          size: UATheme.headingSize(),
        ),
        actions: _totalResultCount <= 10
            ? null
            : <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffe8e8e8)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        value: _sortBy,
                        items: [
                          DropdownMenuItem(
                              child: Text(Strings.sortBy), value: 0),
                          DropdownMenuItem(
                              child: Text(Strings.fullName), value: 1),
                          DropdownMenuItem(
                              child: Text(Strings.firstName), value: 2),
                          DropdownMenuItem(
                              child: Text(Strings.lastName), value: 3)
                        ],
                        onChanged: (int value) {
                          this.setState(() {
                            _sortBy = value;
                          });
                          if (value == 0) {
                            return;
                          }
                          _page = 1;

                          _getSearchResults();
                        },
                      ),
                    ),
                  ),
                )
              ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: new RichText(
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: Strings.notFound,
                            style: new TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                          new TextSpan(
                            text: Strings.clickHere,
                            style: new TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 16),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context, "secondarySearch");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _searchResults.isEmpty
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Strings.noSearchResult,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                            itemCount: _searchResults.length +
                                (_gettingMoreResults ? 1 : 0),
                            itemBuilder: (BuildContext context, int position) {
                              if (position < _searchResults.length) {
                                return _buildRow(position);
                              }
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRow(int i) {
    return Card(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                        child: CachedNetworkImage(
                          imageUrl: _searchResults[i].image,
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _builDoctorDetailColumn(_searchResults[i]),
                    ),
                  ),
                ]),
            Container(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _searchResults[i].availabelForreferral == "Yes"
                      ? RaisedButton(
                          color: Color(0xff7e7e7e),
                          onPressed: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    new RequestAppointment(
                                        doctorId: _searchResults[i].id),
                              ),
                            );
                          },
                          child: Text(Strings.requestAppointment,
                              style: TextStyle(color: Colors.white)),
                        )
                      : Padding(
                          padding: EdgeInsets.zero,
                        ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new DoctorDetail(_searchResults[i].id),
                        ),
                      );
                    },
                    child: Text(Strings.detailedProfile,
                        style: TextStyle(color: Colors.white)),
                  ),
                  _isDoctorLoggedIn
                      ? RaisedButton(
                          onPressed: () {
                            _sendCell(_searchResults[i].id);
                          },
                          color: Color(
                            0xff8CC63E,
                          ),
                          child: Text(
                              _sendingCell ? Strings.sending : Strings.sendCell,
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        )
                      : Padding(
                          padding: EdgeInsets.zero,
                        ),
                ],
              ),
            ),
          ],
        ));
  }

  List<Widget> _builDoctorDetailColumn(Doctor doctor) {
    var widgets = [
      Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 8, 8),
          child: Text(
            "${doctor.fullName}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ))
    ];

    //telephone
    if (doctor.phone != null) {
      widgets.add(
          Helper.buildRichText(title: Strings.telephone, body: doctor.phone));
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

    //board certification
    if (doctor.boardCertifications != null) {
      widgets.add(Helper.buildRichText(
          title: Strings.boardCertifications,
          body: doctor.boardCertifications));
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
                  ..onTap = () {
                    Helper.launchURL('https://${doctor.website}');
                  },
              ),
            ],
          ),
        ),
      ));
    }

    return widgets;
  }

  _sendCell(doctorId) async {
    this.setState(() {
      _sendingCell = true;
    });

    var success = await WebServiceHelper.sendCell(doctorId);
    if (success) {
      UATheme.alert(Strings.cellSent);
    }

    this.setState(() {
      _sendingCell = false;
    });
  }
}
