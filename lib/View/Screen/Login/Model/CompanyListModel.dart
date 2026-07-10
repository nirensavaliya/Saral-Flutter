class CompanyListModel {
  List<CompanyData>? data;
  int? statusCode;
  String? responseMsg;

  CompanyListModel({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CompanyData>[];
      json['data'].forEach((v) {
        data!.add(CompanyData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    dataMap['statusCode'] = statusCode;
    dataMap['responseMsg'] = responseMsg;

    return dataMap;
  }
}

class CompanyData {
  int? companyId;
  String? companyName;

  CompanyData({
    this.companyId,
    this.companyName,
  });

  CompanyData.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'companyName': companyName,
    };
  }
}