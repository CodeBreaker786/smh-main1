import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sarasotaapp/model/user.dart';
import 'package:sarasotaapp/pages/symptom/step10.dart';
import 'package:sarasotaapp/pages/symptom/step7.dart';
import 'package:sarasotaapp/pages/symptom/step8.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:sarasotaapp/widgets/roundedbutton.dart';

class Step9 extends StatefulWidget {
  final User user;

  Step9(this.user);

  @override
  _Step9State createState() => _Step9State();
}

class _Step9State extends State<Step9> {
  bool isLoading = true;
  int symptomsTime = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: UALabel(
                        text:
                            'Do you feel better after taking medication for your symptoms?',
                        size: UATheme.largeSize(),
                        color: Colors.grey.shade900,
                      ),
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: symptomsTime,
                      onChanged: (newValue) =>
                          setState(() => symptomsTime = newValue),
                      title: UALabel(
                        text: 'Not taking any',
                        color: Colors.black,
                        size: UATheme.normalSize(),
                      ),
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: symptomsTime,
                      onChanged: (newValue) =>
                          setState(() => symptomsTime = newValue),
                      title: UALabel(
                        text: 'Yes',
                        color: Colors.black,
                        size: UATheme.normalSize(),
                      ),
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: symptomsTime,
                      onChanged: (newValue) =>
                          setState(() => symptomsTime = newValue),
                      title: UALabel(
                        text: 'No',
                        color: Colors.black,
                        size: UATheme.normalSize(),
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
                                    new Step8(widget.user)));
                      },
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      onPressed: () {
                        widget.user.q6 = symptomsTime;
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Step10(widget.user)));
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
}
