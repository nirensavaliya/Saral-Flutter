class SelectCompanyModel {
  Data? data;
  int? statusCode;
  String? responseMsg;

  SelectCompanyModel({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  SelectCompanyModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'statusCode': statusCode,
      'responseMsg': responseMsg,
    };
  }
}

class Data {
  String? token;

  Data({
    this.token,
  });

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}