import 'package:flutter/material.dart';
import 'package:sarasotaapp/model/doctor.dart';
import 'package:sarasotaapp/pages/FindADoctor/helper.dart';

class DoctorDetailView extends StatelessWidget {
  Doctor doctor;
  DoctorDetailView({this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_ios_outlined)),
                      Text(
                        'Information',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            doctor.fullName,
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.call_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.message_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10)),
                    height: 150,
                    width: 120,
                    child: Image.network(doctor.image, fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 100,
                      );
                    }),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 20),
                    child: MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Make Appointment',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              doctor.address.street != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Address')
                                  : Container(),
                              doctor.address.street != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                          '${doctor.address.street} ${doctor.address.city} ${doctor.address.state} ${doctor.address.postalCode}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18)),
                                    )
                                  : Container(),
                              doctor.specialities != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Specialties')
                                  : Container(),
                              doctor.specialities != null
                                  ? getDoctorInformationTileSubTitle(
                                      subTitle: doctor.specialities)
                                  : Container(),
                              doctor.boardCertifications != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Board Certification')
                                  : Container(),
                              doctor.boardCertifications != null
                                  ? getDoctorInformationTileSubTitle(
                                      subTitle: doctor.boardCertifications)
                                  : Container(),
                              doctor.medicalSchools != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Medical School')
                                  : Container(),
                              doctor.medicalSchools != null
                                  ? getDoctorInformationTileSubTitle(
                                      subTitle: doctor.medicalSchools)
                                  : Container(),
                              doctor.internships != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Internship')
                                  : Container(),
                              doctor.internships != null
                                  ? getDoctorInformationTileSubTitle(
                                      subTitle: doctor.internships)
                                  : Container(),
                              doctor.residencies != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Residency')
                                  : Container(),
                              doctor.residencies != null
                                  ? getDoctorInformationTileSubTitle(
                                      subTitle: doctor.residencies)
                                  : Container(),
                              doctor.website != null
                                  ? getDoctorInformationTileTitle(
                                      title: 'Website')
                                  : Container(),
                              doctor.website != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: InkWell(
                                        onTap: () {
                                            Helper.launchURL('https://${doctor.website}');
                                        },
                                        child: Text(doctor.website,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18)),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
        ));
  }

  getDoctorInformationTileTitle({String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  getDoctorInformationTileSubTitle({String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(subTitle, style: TextStyle(color: Colors.grey, fontSize: 18)),
    );
  }
}
