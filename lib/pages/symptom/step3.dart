import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sarasotaapp/model/diagnosis.dart';
import 'package:sarasotaapp/model/user.dart';
import 'package:sarasotaapp/networking.dart';
import 'package:sarasotaapp/pages/symptom/step2.dart';
import 'package:sarasotaapp/pages/symptom/step4.dart';
import 'package:sarasotaapp/pages/smhevents.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/roundedbutton.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

class Step3 extends StatefulWidget {
  final User user;

  Step3(this.user);

  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  bool isLoading = true;
  int symptomsTime = 1;
  Diagnosis diagnosis;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    diagnosis = await NetworkHelper.getDiagnosis(widget.user);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: UALabel(
            text: 'Symptom Checker',
            size: UATheme.headingSize(),
            color: Colors.grey.shade900,
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: UALabel(
                text: 'Likely Diagnoses',
                size: UATheme.largeSize(),
                color: Colors.grey.shade900,
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BubbleTabIndicator(
                          indicatorHeight: 30.0,
                          indicatorRadius: 10,
                          indicatorColor: Color(0xff639EC7),
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xff639EC7),
                        labelStyle: TextStyle(
                            fontSize: UATheme.normalSize(),
                            color: Color(0xff639EC7)),
                        unselectedLabelStyle: TextStyle(
                          fontSize: UATheme.normalSize(),
                        ),
                        tabs: <Widget>[
                          Tab(
                            text: 'Common',
                          ),
                          Tab(
                            text: 'Red Flags',
                          ),
                          Tab(
                            text: 'Show All',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          ListView(
                            children: listTiles(1),
                          ),
                          ListView(
                            children: listTiles(2),
                          ),
                          ListView(
                            children: listTiles(3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RoundedButton(
                      text: 'Previous step',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Step2(widget.user)));
                      },
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Step4(widget.user)));
                      },
                      text: 'Next step',
                      color: Color(0xff639EC7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  listTiles(int flag) {
    List<Widget> list = new List();

    if (diagnosis != null)
      for (int i = 0; i < diagnosis.diagnosis_checklist.diagnoses.length; i++) {
        if (flag == 1) {
          if (diagnosis.diagnosis_checklist.diagnoses[i].common_diagnosis ==
              "true")
            list.add(
              Container(
                  child: ListTile(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SMHEvents(
                          url: diagnosis.diagnosis_checklist.diagnoses[i]
                              .knowledge_window_url)));
                },
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: UALabel(
                        text: diagnosis
                            .diagnosis_checklist.diagnoses[i].diagnosis_name,
                        size: UATheme.normalSize(),
                      ),
                    ),
                    Icon(
                      Icons.flag,
                      color:
                          diagnosis.diagnosis_checklist.diagnoses[i].red_flag ==
                                  "true"
                              ? Colors.red
                              : Colors.transparent,
                    ),
                    Visibility(
                      visible: diagnosis.diagnosis_checklist.diagnoses[i]
                                  .common_diagnosis ==
                              "true"
                          ? true
                          : false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.cyan,
                          child: UALabel(
                            text: 'Common',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            );
        } else if (flag == 2) {
          if (diagnosis.diagnosis_checklist.diagnoses[i].red_flag == "true")
            list.add(
              Container(
                  child: ListTile(
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SMHEvents(
                          url: diagnosis.diagnosis_checklist.diagnoses[i]
                              .knowledge_window_url)));
                },
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: UALabel(
                        text: diagnosis
                            .diagnosis_checklist.diagnoses[i].diagnosis_name,
                        size: UATheme.normalSize(),
                      ),
                    ),
                    Visibility(
                      visible: diagnosis.diagnosis_checklist.diagnoses[i]
                                  .common_diagnosis ==
                              "true"
                          ? true
                          : false,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.cyan,
                          child: UALabel(
                            text: 'Common',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.flag,
                      color:
                          diagnosis.diagnosis_checklist.diagnoses[i].red_flag ==
                                  "true"
                              ? Colors.red
                              : Colors.transparent,
                    ),
                  ],
                ),
              )),
            );
        } else
          list.add(
            Container(
                child: ListTile(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new SMHEvents(
                        url: diagnosis.diagnosis_checklist.diagnoses[i]
                            .knowledge_window_url)));
              },
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: UALabel(
                      text: diagnosis
                          .diagnosis_checklist.diagnoses[i].diagnosis_name,
                      size: UATheme.normalSize(),
                    ),
                  ),
                  Icon(
                    Icons.flag,
                    color:
                        diagnosis.diagnosis_checklist.diagnoses[i].red_flag ==
                                "true"
                            ? Colors.red
                            : Colors.transparent,
                  ),
                  Visibility(
                    visible: diagnosis.diagnosis_checklist.diagnoses[i]
                                .common_diagnosis ==
                            "true"
                        ? true
                        : false,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.cyan,
                        child: UALabel(
                          text: 'Common',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
      }
    return list;
  }
}
