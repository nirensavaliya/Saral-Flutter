class QuotationModel {
  QuotationPdfData? data;
  int? statusCode;
  String? responseMsg;

  QuotationModel({this.data, this.statusCode, this.responseMsg});

  QuotationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new QuotationPdfData.fromJson(json['data']) : null;
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

class QuotationPdfData {
  String? downloadurl;

  QuotationPdfData({this.downloadurl});

  QuotationPdfData.fromJson(Map<String, dynamic> json) {
    downloadurl = json['downloadurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['downloadurl'] = this.downloadurl;
    return data;
  }
}
