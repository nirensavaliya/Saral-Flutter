class NextSerialNoModel {
  SerialData? data;
  int? statusCode;
  String? responseMsg;

  NextSerialNoModel({this.data, this.statusCode, this.responseMsg});

  NextSerialNoModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SerialData.fromJson(json['data']) : null;
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

class SerialData {
  int? serialNumber;
  int? orderNumber;

  SerialData({this.serialNumber,this.orderNumber});

  SerialData.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serialNumber'];
    orderNumber = json['orderNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serialNumber'] = this.serialNumber;
    data['orderNumber'] = this.orderNumber;
    return data;
  }
}
