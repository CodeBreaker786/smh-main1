import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sarasotaapp/model/doctor.dart';
import 'package:sarasotaapp/pages/FindADoctor/strings.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FindADoctor extends StatefulWidget {
  List<dynamic> specialties;
  FindADoctor({this.specialties});
  @override
  _FindADoctorState createState() => _FindADoctorState();
}

class _FindADoctorState extends State<FindADoctor> {
  ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  TextEditingController _nameController = new TextEditingController(text: '');
  String _currentSelectedValue;
  List<Doctor> _searchResults = [];
  int _page = 1;
  // int _totalResultCount = 0;
  bool _isLoading = true;
  bool _hasMore = false;
  // int _sortBy = 0;
  bool creatingPDF = false;
  // bool _sendingCell = false;
  // bool _isDoctorLoggedIn = false;

  void initState() {
    super.initState();
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
              child: _searchResults.isEmpty                  
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          Strings.noSearchResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ))
                  : Container(                    
                      child: ScrollablePositionedList.builder(
                          itemScrollController: _scrollController,
                          itemPositionsListener: itemPositionsListener,
                          scrollDirection: Axis.vertical,
                          itemCount: _hasMore
                              ? _searchResults.length + 1
                              : _searchResults.length,
                          itemBuilder: (context, index) {
                            if (index >= _searchResults.length) {
                              return circularbar();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  leading: Container(
                                    height: 100,
                                    width: 60,
                                  ),
                                  title: Text('Harvey , Jasmine , MD'),
                                  subtitle: Text('Radiology'),
                                  trailing: InkWell(
                                    onTap: () {},
                                    child: Material(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Select'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )

              // return ListView.builder(
              //   itemBuilder: (context, index) {

              //   },
              // );

              ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 30),
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
                      onSubmitted: (value) {
                        _loadMore();
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
                        // await widget
                        //     .businessRuleDao
                        //     .updateBussinessRule(
                        //     businessRuleData
                        //         .copyWith(
                        //         value:
                        //         value));
                        setState(() {
                          _currentSelectedValue = value;
                        });
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
    ));
  }

  void _loadMore() async {
    //  setState(() {
    //     _hasMore = true;
    //  });
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

    if (data.list.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _searchResults.addAll(data.list);
      });
    }
  }

  Widget circularbar() {
     _loadMore();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              ))),
    );
  }
}
