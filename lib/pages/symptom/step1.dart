import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sarasotaapp/model/agegroups.dart';
import 'package:sarasotaapp/model/regions.dart';
import 'package:sarasotaapp/model/user.dart';
import 'package:sarasotaapp/networking.dart';
import 'package:sarasotaapp/pages/symptom/step2.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/roundedbutton.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';

class SymptomChecker extends StatefulWidget {
  @override
  _SymptomCheckerState createState() => _SymptomCheckerState();
}

class _SymptomCheckerState extends State<SymptomChecker> {
  bool isLoading = true;
  int isMale = 1;
  int isPregnant = 0;
  AgeGroups ageGroups;
  Regions regions;
  String selectedAge = "Select Age";
  String selectedRegion = "North America";
  String selectedRegionId = "0";
  String ageGroupId = "0";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    ageGroups = await NetworkHelper.getAgeGroups();

    regions = await NetworkHelper.getRegions();

    print(selectedRegion);

    isLoading = false;
    setState(() {});

    //print(regions.travelHistory.region[0].region_name);

    //Pregnancies pregnancies = await NetworkHelper.getPregnancies();
    //print(pregnancies.pregnancies.pregnancy[0].pregnancy_name);

    //Diagnosis diagnosis = await NetworkHelper.getDiagnosis();
    //print(diagnosis.diagnosis_checklist.diagnoses[0].diagnosis_name);
    //print(diagnosis.diagnosis_checklist.specialtyUrls[0].specialty);
    //print(diagnosis.diagnosis_checklist.queryResultDetails.age_group);
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: UALabel(
          text: 'Symptom Checker',
          size: UATheme.headingSize(),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120.0),
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: UALabel(
                        text: 'Enter Your Information',
                        size: UATheme.largeSize(),
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        hint: UALabel(
                          text: selectedAge,
                          color: Colors.grey.shade900,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade900,
                        ),
                        underline: Container(),
                        isExpanded: true,
                        items: ageGroups != null
                            ? ageGroups.ageGroup1.ageGroup
                                .map(
                                  (map) => DropdownMenuItem(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: UALabel(
                                        text: map.name +
                                            " (" +
                                            map.yr_from +
                                            "-" +
                                            map.yr_to +
                                            ")",
                                      ),
                                    ),
                                    value: map.name,
                                  ),
                                )
                                .toList()
                            : [],
                        onChanged: (String val) {
                          selectedAge = val;
                          setState(() {
                            selectedAge = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              value: 0,
                              groupValue: isMale,
                              onChanged: (newValue) =>
                                  setState(() => isMale = newValue),
                              title: UALabel(
                                text: 'Female',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              groupValue: isMale,
                              onChanged: (newValue) =>
                                  setState(() => isMale = newValue),
                              title: UALabel(
                                text: 'Male',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isMale == 0,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            UALabel(
                              text: 'Are you Pregnant?',
                              color: Colors.black,
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: 1,
                                groupValue: isPregnant,
                                onChanged: (newValue) =>
                                    setState(() => isPregnant = newValue),
                                title: UALabel(
                                  text: 'Yes',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: 0,
                                groupValue: isPregnant,
                                onChanged: (newValue) =>
                                    setState(() => isPregnant = newValue),
                                title: UALabel(
                                  text: 'No',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        items: regions != null
                            ? regions.travelHistory.region
                                .map(
                                  (map) => DropdownMenuItem(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: UALabel(
                                        text: map.region_name,
                                      ),
                                    ),
                                    value: map.region_name,
                                  ),
                                )
                                .toList()
                            : [],
                        hint: UALabel(
                          text: selectedRegion,
                          color: Colors.grey.shade900,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade900,
                        ),
                        underline: Container(),
                        isExpanded: true,
                        onChanged: (String val) {
                          selectedRegion = val;
                          setState(() {
                            selectedRegion = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                ],
              ),
                  )),
            ),
            Container(
              color: Colors.grey.shade300,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: RoundedButton(
                      onPressed: () {
                        if (selectedAge != "Select Age" &&
                            selectedRegion != "Region") {
                          getRegionId();
                          getAgeGroupId();
                          User user = new User();
                          user.gender = isMale == 1 ? "m" : "f";
                          user.pregnant = isPregnant == 1 ? "y" : "n";
                          user.age = ageGroupId;
                          user.region = selectedRegionId;
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Step2(user)));
                        } else
                          UATheme.alert("Please enter all details");
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

  getRegionId() {
    for (int i = 0; i < regions.travelHistory.region.length; i++) {
      if (selectedRegion == regions.travelHistory.region[i].region_name) {
        selectedRegionId = regions.travelHistory.region[i].region_id;
        break;
      }
    }
  }

  getAgeGroupId() {
    for (int i = 0; i < ageGroups.ageGroup1.ageGroup.length; i++) {
      if (selectedAge == ageGroups.ageGroup1.ageGroup[i].name) {
        ageGroupId = ageGroups.ageGroup1.ageGroup[i].agegroup_id;
        break;
      }
    }
  }
}
