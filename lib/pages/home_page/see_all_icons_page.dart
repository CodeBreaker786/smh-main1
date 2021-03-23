import 'package:flutter/material.dart';
import 'package:sarasotaapp/colors.dart';
import 'package:sarasotaapp/model/locationitem.dart';
import 'package:sarasotaapp/navigation.dart';
import 'package:sarasotaapp/pages/FindADoctor/getSpecilties.dart';
import 'package:sarasotaapp/pages/home_page/home.dart';
import 'package:sarasotaapp/pages/locations/locationdetails.dart';
import 'package:sarasotaapp/pages/services/ourservices.dart';
import 'package:sarasotaapp/pages/surgerystatus.dart';
import 'package:sarasotaapp/pages/symptom/step1.dart';

class MainIcons extends StatefulWidget {
  @override
  _MainIconsState createState() => _MainIconsState();
}

class _MainIconsState extends State<MainIcons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Nearest Locations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        color:UiColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: GridView.count(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 0,
           
            children: [
              buildListTile(
                padding: true,
                title: 'Find a Doctor',
                path: 'assets/images/main/find_a_doctor.png',
                callBack: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return GetSpecialties();
                    }),
                  );
                }),
             
              buildListTile(
                 padding: true,
                  title: 'Our Serives',
                  path: 'assets/images/main/our_serives.png',
                  callBack: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return OurServices();
                      }),
                    );
                  }),
              buildListTile(
                 padding: true,
                  title: 'Symptom Checker',
                  path: 'assets/images/main/sympton_checker.png',
                  callBack: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SymptomChecker();
                      }),
                    );
                  }),
              buildListTile(
                 padding: true,
                  title: 'Surgery Status',
                  path: 'assets/images/main/surgery_status.png',
                  callBack: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SurgeryStatus(
                          url: 'https://surgerystatus.smh.com',
                        );
                      }),
                    );
                  }),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
              buildListTile(
                 padding: true,
                  title: 'Find a Doctor',
                  path: 'assets/images/main/find_a_doctor.png'),
            ],
          ),
        ),
      ),
    );
  }
}
