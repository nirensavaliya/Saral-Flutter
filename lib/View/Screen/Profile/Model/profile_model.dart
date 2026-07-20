class ProfileModel {
  ProfileData? data;
  int? statusCode;
  String? responseMsg;

  ProfileModel({this.data, this.statusCode, this.responseMsg});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      statusCode: json['statusCode'],
      responseMsg: json['responseMsg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data?.toJson(),
      "statusCode": statusCode,
      "responseMsg": responseMsg,
    };
  }
}

class ProfileData {
  String? customerName;
  String? address1;
  String? address2;
  String? city;
  String? area;
  String? zipcode;
  String? state;
  String? countryName;
  String? contact1;
  String? contact2;
  String? email;
  String? contactPerson;
  String? panNumber;
  String? gstinNumber;
  String? customerGSTType;

  ProfileData({
    this.customerName,
    this.address1,
    this.address2,
    this.city,
    this.area,
    this.zipcode,
    this.state,
    this.countryName,
    this.contact1,
    this.contact2,
    this.email,
    this.contactPerson,
    this.panNumber,
    this.gstinNumber,
    this.customerGSTType,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      customerName: json["customerName"],
      address1: json["address1"],
      address2: json["address2"],
      city: json["city"],
      area: json["area"],
      zipcode: json["zipcode"],
      state: json["state"],
      countryName: json["countryName"],
      contact1: json["contact1"],
      contact2: json["contact2"],
      email: json["email"],
      contactPerson: json["contactPerson"],
      panNumber: json["panNumber"],
      gstinNumber: json["gstinNumber"],
      customerGSTType: json["customerGSTType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName,
      "address1": address1,
      "address2": address2,
      "city": city,
      "area": area,
      "zipcode": zipcode,
      "state": state,
      "countryName": countryName,
      "contact1": contact1,
      "contact2": contact2,
      "email": email,
      "contactPerson": contactPerson,
      "panNumber": panNumber,
      "gstinNumber": gstinNumber,
      "customerGSTType": customerGSTType,
    };
  }
}
