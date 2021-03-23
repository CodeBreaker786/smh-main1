import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sarasotaapp/model/user.dart';
import 'package:sarasotaapp/pages/symptom/step6.dart';
import 'package:sarasotaapp/pages/symptom/step8.dart';
import 'package:sarasotaapp/uatheme.dart';
import 'package:sarasotaapp/widgets/ualabel.dart';
import 'package:sarasotaapp/widgets/roundedbutton.dart';

class Step7 extends StatefulWidget {
  final User user;

  Step7(this.user);

  @override
  _Step7State createState() => _Step7State();
}

class _Step7State extends State<Step7> {
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
                        text: 'How much pain or discomfort are you in?',
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
                        text: 'None',
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
                        text: 'Mild Discomfort',
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
                        text: 'Very uncomfortable',
                        color: Colors.black,
                        size: UATheme.normalSize(),
                      ),
                    ),
                    RadioListTile(
                      value: 4,
                      groupValue: symptomsTime,
                      onChanged: (newValue) =>
                          setState(() => symptomsTime = newValue),
                      title: UALabel(
                        text: 'Unbearable',
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
                                    new Step6(widget.user)));
                      },
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      onPressed: () {
                        widget.user.q4 = symptomsTime;
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Step8(widget.user)));
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
