import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/pages/FindADoctor/RequestAppointment.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctor_detail_view.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctordetail.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';

import '../../uatheme.dart';
import 'Webservices.dart';
import '../../model/doctor.dart';
import 'helper.dart';

// ignore: must_be_immutable
class DoctorSearchResult extends StatefulWidget {
  List<dynamic> specialties;
  DoctorSearchResult({this.specialties});

  @override
  _DoctorSearchResultState createState() => _DoctorSearchResultState();
}

class _DoctorSearchResultState extends State<DoctorSearchResult> {
  TextEditingController _nameController = new TextEditingController(text: '');
  String _currentSelectedValue;
  List<Doctor> _searchResults = [];
  bool _isLoading = false;
  int _page = 1;
  int _totalResultCount = 0;
  ScrollController _scrollController;
  bool _gettingMoreResults = false;
  int _sortBy = 0;
  bool creatingPDF = false;
  bool _sendingCell = false;
  bool _isDoctorLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _checkDoctorLoggedInState();
    _scrollController = ScrollController();
    // _getSearchResults();

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
     
      setState(() {
       
        _isLoading = true;
      });
      final data = await WebServiceHelper.getDoctors(
          isSecondarySearch: false,
          name: _nameController.text,
          speciality: _currentSelectedValue,
          zipCode: '',
          keyword: '',
          acceptingNewPatientSwitchValue: false,
          page: _page,
          sortBy: 0);

      _page++;

      setState(() {
        _isLoading = false;
        _totalResultCount = data.totalRecords;
        _searchResults = data == null ? [] : data.list;
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
        isSecondarySearch: false,
        name: _nameController.text,
        speciality: _currentSelectedValue,
        zipCode: '',
        keyword: '',
        acceptingNewPatientSwitchValue: false,
        page: _page,
        sortBy: 0);

    _page++;

    this.setState(() {
      _searchResults.addAll(data.list);
      _gettingMoreResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _searchResults.isEmpty
                      ? Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.search,
                                size: 100,
                                color: UiColors.primaryColor,
                              )))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                          itemCount: _searchResults.length +
                              (_gettingMoreResults ? 1 : 0),
                          itemBuilder: (BuildContext context, int position) {
                            if (position < _searchResults.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade50,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    leading: Container(
                                      width: 50,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(borderRadius:BorderRadius.circular(5) ),
                                      child: Image.network(
                                          _searchResults[position].image,fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                        return Icon(Icons.person)
                                        ;
                                      }),
                                    ),
                                    title: Text(
                                      _searchResults[position].fullName,
                                    ),
                                    subtitle: Text(
                                      _searchResults[position].specialities,
                                      maxLines: 2,
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                            return DoctorDetailView(doctor:_searchResults[position]);
                                          }),
                                        );
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Theme.of(context).primaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('View Profile'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
                height: 300,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18, right: 18, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_ios_outlined)),
                      Text(
                        'Search Doctor',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 25,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 3,
                              width: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
            left: 12,
            right: 12,
            height: MediaQuery.of(context).size.height * 0.22,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'SEARCH',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Search doctor',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 8, // HERE THE IMPORTANT PART
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.7),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          //  prefixIcon: Icon(Icons.search,)
                        ),
                        onChanged: (value) {
                           _totalResultCount = 0;
                           _page = 1;
                           _searchResults.clear();
                          _getSearchResults();
                        },
                      ),
                    ),
                    Container(
                      height: 55,
                      child: DropdownSearch(
                        mode: Mode.MENU,
                        // labelStyle: TextStyle(
                        //     color: Theme.of(context).textSelectionColor,
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 12),
                        label: "Branches",
                        selectedItem: _currentSelectedValue,

                        items: [...widget.specialties.map((e) => e.toString())],
                        onChanged: (value) async {
                           _totalResultCount = 0;
                           _page = 1;
                           _searchResults.clear();
                           _currentSelectedValue = value;                       
                           _getSearchResults();
                          
                        },
                        searchBoxDecoration: InputDecoration(
                            suffix: Container(
                          height: 30,
                          child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Theme.of(context).accentColor,
                            child: Icon(Icons.add),
                          ),
                        )),
                        // autofocus: true,
                        // backgroundColor: Theme.of(context).cardColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
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
