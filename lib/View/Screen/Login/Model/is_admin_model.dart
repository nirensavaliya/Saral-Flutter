class IsAdminModel {
  dynamic data;
  int? statusCode;
  String? responseMsg;

  IsAdminModel({this.data, this.statusCode, this.responseMsg});

  IsAdminModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is bool) {
      data = json['data']; // Assign the boolean directly
    } else if (json['data'] is Map<String, dynamic>) {
      data = OtpData.fromJson(json['data']); // Parse as `OtpData`
    }
    statusCode = json['statusCode'] as int?;
    responseMsg = json['responseMsg'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data is OtpData) {
      data['data'] = (this.data as OtpData).toJson();
    } else {
      data['data'] = this.data; // Assign the boolean directly
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['otpResponse'] = otpResponse;
    return data;
  }
}