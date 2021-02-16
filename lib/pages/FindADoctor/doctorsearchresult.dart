import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/pages/FindADoctor/RequestAppointment.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctor_detail_view.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctordetail.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctorlogin.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/utils/customLoader.dart';
import 'package:sarasotaapp/utils/show_flushbar.dart';

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
  CustomLoader customLoader;
  bool _isLoading = false;
  int _page = 1;
  int _totalResultCount = 0;
  ScrollController _scrollController;
  bool _gettingMoreResults = false;
  int _sortBy = 0;
  bool creatingPDF = false;
  bool _sendingCell = false;
  bool _isDoctorLoggedIn = false;
  bool isLoginLoding = true;

  @override
  void initState() {
    super.initState();
    customLoader = CustomLoader();
    widget.specialties.sort();
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
    await FindDoctorPreferences.isDoctorLoggedIn().then((e) {
      setState(() {
        isLoginLoding = false;
        _isDoctorLoggedIn = e;
      });
    });
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
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            bottom: _isDoctorLoggedIn ? 0 : 70,
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
                                    horizontal: 25, vertical: 5),
                                child: Card(
                                  //clipBehavior: Clip.antiAlias,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 130,
                                    child: Row(children: [
                                      Container(
                                        width: 80,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Image.network(
                                            _searchResults[position].image,
                                            fit: BoxFit.cover, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace stackTrace) {
                                          return Icon(Icons.person);
                                        }),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: ListTile(
                                            title: Text(
                                              _searchResults[position].fullName,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              _searchResults[position]
                                                          .specialities ==
                                                      null
                                                  ? "No Speciality Found"
                                                  : _searchResults[position]
                                                      .specialities,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                      return DoctorDetailView(
                                                        doctor: _searchResults[
                                                            position],
                                                        isDoctorLogin:
                                                            _isDoctorLoggedIn,
                                                      );
                                                    }),
                                                  );
                                                },
                                                child: Material(
                                                  elevation: 1.5,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text('View Profile'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              _isDoctorLoggedIn
                                                  ? InkWell(
                                                      onTap: () async {
                                                        customLoader.showLoader(
                                                            context);
                                                        bool isSuccessfull =
                                                            await WebServiceHelper
                                                                .sendCell(
                                                                    _searchResults[
                                                                            position]
                                                                        .id);
                                                        if (isSuccessfull) {
                                                          customLoader
                                                              .hideLoader();
                                                          showSnackBar(
                                                              context: context,
                                                              value:
                                                                  'Cell is Sent Successfully',
                                                              icon: Icon(
                                                                  Icons.check));
                                                        } else {
                                                          customLoader
                                                              .hideLoader();
                                                          showSnackBar(
                                                              context: context,
                                                              isError: true,
                                                              value:
                                                                  'Something go wrong please try again',
                                                              icon: Icon(
                                                                  Icons.error));
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Material(
                                                            //  padding: EdgeInsets.symmetric(vertical: 12),

                                                            elevation: 1.5,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            color: Colors.green,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      16),
                                                              child: Text(
                                                                'Send Cell',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
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
                        'Find A Doctor or Provider',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        width: 35,
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
            left: 12,
            right: 12,
            height: 150,
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
                        label: "Specialties",
                        selectedItem: _currentSelectedValue,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
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
      bottomSheet: isLoginLoding
          ? SizedBox()
          : _isDoctorLoggedIn
              ? SizedBox()
              : Container(
                  constraints: BoxConstraints.expand(height: 70),
                  child: MaterialButton(
                    onPressed: () async {
                      bool islogin = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorLogin()));
                      if (islogin) {
                        showSnackBar(
                            context: context,
                            value: "You Login Successfully",
                            icon: Icon(Icons.login));
                        setState(() {
                          _isDoctorLoggedIn = true;
                        });
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not Signed In',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          'Click to login',
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
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
