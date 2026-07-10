class GetGstTaxListModel {
  List<GetGstData>? data;
  int? statusCode;
  String? responseMsg;

  GetGstTaxListModel({this.data, this.statusCode, this.responseMsg});

  GetGstTaxListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetGstData>[];
      json['data'].forEach((v) {
        data!.add(new GetGstData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['responseMsg'] = this.responseMsg;
    return data;
  }
}

class GetGstData {
  int? gstCodeId;
  String? gstTaxName;

  GetGstData({this.gstCodeId, this.gstTaxName});

  GetGstData.fromJson(Map<String, dynamic> json) {
    gstCodeId = json['gstCodeId'];
    gstTaxName = json['gstTaxName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gstCodeId'] = this.gstCodeId;
    data['gstTaxName'] = this.gstTaxName;
    return data;
  }
}
