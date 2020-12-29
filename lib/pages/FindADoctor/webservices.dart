import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sarasotaapp/model/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

 

class WebServiceConstants {
  static final baseURL =
      'https://yj1hczi4wj.execute-api.us-east-1.amazonaws.com/dev/doctor';

  //prod URL https://qc8wrbd1o9.execute-api.us-east-1.amazonaws.com/prod/doctor
  //dev URL - https://yj1hczi4wj.execute-api.us-east-1.amazonaws.com/dev/doctor

  static final loginPath = '/login';
  static final specialitiesPath = '/getSpecialities';
  static final doctorPrimarySearchPath = '/list';
  static final doctorSecondarySearchPath = '/secondrylist';
  static final sendCellPath = '/sendcell';
  static final requestAppointment = '/requestAppointment';
}

class WebServiceHelper {
  static login(String cell, String dictation) async {
    print('in login');
    final http.Response response = await http.post(
      WebServiceConstants.baseURL + WebServiceConstants.loginPath,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'phone': cell, 'providerId': dictation}),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      var loginData = json.decode(response.body);
      if (loginData['body']['status']) {
        FindDoctorPreferences.saveLoginData(loginData['body']['message']);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  static getSpecialities() async {
    var response = await http.get(
        WebServiceConstants.baseURL + WebServiceConstants.specialitiesPath);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var specialities = data["body"]["message"];
      return specialities;
    }

    return [];
  }

  static getDoctors(
      {bool isSecondarySearch,
      String name,
      String speciality,
      String zipCode,
      String keyword,
      bool acceptingNewPatientSwitchValue,
      int page,
      int sortBy}) async {
    String sort = "name";

    switch (sortBy) {
      case 0:
        {
          sort = "name";
        }
        break;
      case 1:
        {
          sort = "Full_Name__c";
        }
        break;
      case 2:
        {
          sort = "FirstName";
        }
        break;
      default:
        sort = "LastName";
    }

    var url =
        "${WebServiceConstants.baseURL}${isSecondarySearch ? WebServiceConstants.doctorSecondarySearchPath : WebServiceConstants.doctorPrimarySearchPath}?page=$page&sort=$sort";

    if (name != null && name.isNotEmpty) {
      url = url + "&name=$name";
    }

    if (speciality != null && speciality.isNotEmpty) {
      url = url + "&doctorSpeciality=$speciality";
    }

    if (zipCode != null && zipCode.isNotEmpty) {
      url = url + "&location=$zipCode";
    }

    if (keyword != null && keyword.isNotEmpty) {
      url = url + "&keyword=$keyword";
    }

    if (isSecondarySearch) {
      url = url + "&includeProviders=$acceptingNewPatientSwitchValue";
    }

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      DoctorData doctorData = new DoctorData.fromJson(data["body"]["message"]);
      return doctorData;
    }
    return null;
  }

  static getDoctorDetail(String id) async {
    var response = await http.get(WebServiceConstants.baseURL + '/$id');

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var doctor = new Doctor.fromJson(data["body"]["message"]);
      return doctor;
    }

    return null;
  }

  static sendCell(String id) async {
    var token = await FindDoctorPreferences.getDoctorToken();

    final http.Response response = await http.post(
      WebServiceConstants.baseURL + WebServiceConstants.sendCellPath,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
      body: jsonEncode(<String, String>{'id': id}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static requestAppointment({
    String id,
    String name,
    String email,
    String phoneNumber,
    String reason,
  }) async {
    final http.Response response = await http.post(
      WebServiceConstants.baseURL +
          WebServiceConstants.requestAppointment +
          '/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'message': reason,
        'name': name,
        'phone': phoneNumber
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['body']['message'];
    } else {
      return data['message'];
    }
  }
}

class FindDoctorPreferences {
  static saveLoginData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDoctorLoggedIn', true);
    prefs.setString('doctorToken', token);
  }

  static Future<String> getDoctorToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('doctorToken');
  }

  static Future<bool> isDoctorLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isDoctorLoggedIn = prefs.getBool('isDoctorLoggedIn');
    return isDoctorLoggedIn == null ? false : true;
  }
}
