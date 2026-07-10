class OtpModel {
  OtpData? data;
  int? statusCode;
  String? responseMsg;

  OtpModel({this.data, this.statusCode, this.responseMsg});

  OtpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OtpData.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['responseMsg'] = this.responseMsg;
    return data;
  }
}

class OtpData {
  String? otp;
  String? otpResponse;

  OtpData({this.otp, this.otpResponse});

  OtpData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    otpResponse = json['otpResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['otpResponse'] = this.otpResponse;
    return data;
  }
}
