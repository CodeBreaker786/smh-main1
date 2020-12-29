import 'package:flutter/material.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctorsearch.dart';
import 'package:sarasotaapp/pages/FindADoctor/doctorsearchresult.dart';
import 'package:sarasotaapp/pages/FindADoctor/find_a_doctor.dart';
import 'package:sarasotaapp/pages/FindADoctor/webservices.dart';

class GetSpecialties extends StatelessWidget {
  const GetSpecialties({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder(
        future:WebServiceHelper.getSpecialities() ,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DoctorSearchResult(specialties: snapshot.data);
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
