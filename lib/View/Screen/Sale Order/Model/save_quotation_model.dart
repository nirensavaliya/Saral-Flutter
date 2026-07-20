class SaveQuotationModel {
  Data? data;
  int? statusCode;
  String? responseMsg;

  SaveQuotationModel({this.data, this.statusCode, this.responseMsg});

  SaveQuotationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? quoteId;
  int? salesOrderId;

  Data({
    this.quoteId,
    this.salesOrderId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    quoteId = json['quoteId'];
    salesOrderId = json['salesOrderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quoteId'] = this.quoteId;
    data['salesOrderId'] = this.salesOrderId;
    return data;
  }
}
