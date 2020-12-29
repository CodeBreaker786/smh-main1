class DoctorData {
  int totalRecords;
  List<Doctor> list;

  DoctorData({this.totalRecords, this.list});

  factory DoctorData.fromJson(Map<String, dynamic> parsedJson) {
    return DoctorData(
        totalRecords: parsedJson["TotalRecords"],
        list: (parsedJson['Data'] as List)
            .map((i) => Doctor.fromJson(i))
            .toList());
  }
}

class Doctor {
  final String accountId;
  final String availabelForreferral;
  final String fullName;
  final String id;
  final String mobilePhone;
  final String phone;
  final String image;
  final String specialities;
  final String boardCertifications;
  final String website;
  final Address address;
  final double latitude;
  final double longitude;
  final String medicalSchools;
  final String residencies;
  final String internships;
  final String fellowship;

  Doctor(
      {this.accountId,
      this.availabelForreferral,
      this.fullName,
      this.id,
      this.mobilePhone,
      this.phone,
      this.image,
      this.specialities,
      this.boardCertifications,
      this.website,
      this.address,
      this.latitude,
      this.longitude,
      this.medicalSchools,
      this.residencies,
      this.internships,
      this.fellowship});

  factory Doctor.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson != null) {
      RegExp exp =
          new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
      Iterable<RegExpMatch> matches =
          exp.allMatches(parsedJson['Provider_Image__c']);
      List urls = matches
          .map((urlMatch) => parsedJson['Provider_Image__c']
              .substring(urlMatch.start, urlMatch.end))
          .toList();
      return Doctor(
          accountId: parsedJson['AccountId'],
          availabelForreferral: parsedJson['Available_for_Referral__c'],
          fullName: parsedJson['Full_Name__c'],
          id: parsedJson['Id'],
          mobilePhone: parsedJson['MobilePhone'],
          phone: parsedJson['Phone'],
          image: urls[0],
          specialities: parsedJson['Website_Provider_Specialties__c'],
          //old: "Provider_Specialties__c"
          boardCertifications: parsedJson['Board_Certifications__c'],
          website: parsedJson['Import_website__c'],
          address: Address.fromJson(parsedJson['MailingAddress']),
          latitude: parsedJson['latitude'],
          longitude: parsedJson['longitude'],
          medicalSchools: parsedJson['Medical_Schools__c'],
          residencies: parsedJson['Residencies__c'],
          internships: parsedJson['Internships__c'],
          fellowship: parsedJson['Fellowships__c']);
    } else
      return null;
  }
}

class Address {
  String city;
  String country;
  String latitude;
  String longitude;
  String postalCode;
  String state;
  String street;

  Address(
      {this.city,
      this.country,
      this.latitude,
      this.longitude,
      this.postalCode,
      this.state,
      this.street});

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(
        city: parsedJson['city'],
        country: parsedJson['country'],
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
        postalCode: parsedJson['postalCode'],
        state: parsedJson['state'],
        street: parsedJson['street']);
  }
}
