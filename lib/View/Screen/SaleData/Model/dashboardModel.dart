class DashboardModel {
  List<DashboardData>? data;
  int? statusCode;
  String? responseMsg;

  DashboardModel({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DashboardData>[];
      json['data'].forEach((v) {
        data!.add(DashboardData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};

    if (data != null) {
      dataMap['data'] = data!.map((e) => e.toJson()).toList();
    }

    dataMap['statusCode'] = statusCode;
    dataMap['responseMsg'] = responseMsg;

    return dataMap;
  }
}

class DashboardData {
  String? elementTitle;
  String? value;

  DashboardData({
    this.elementTitle,
    this.value,
  });

  DashboardData.fromJson(Map<String, dynamic> json) {
    elementTitle = json['elementTitle'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    return {
      'elementTitle': elementTitle,
      'value': value,
    };
  }
}