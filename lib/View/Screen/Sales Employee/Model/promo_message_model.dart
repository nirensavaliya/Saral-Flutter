class PromotionalMessageModel {
  PromotionalMessageData? data;
  int? statusCode;
  String? responseMsg;

  PromotionalMessageModel({this.data, this.statusCode, this.responseMsg});

  PromotionalMessageModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = PromotionalMessageData.fromJson(json['data']);
    }
    statusCode = json['statusCode'];
    responseMsg = json['responseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['responseMsg'] = this.responseMsg;
    return data;
  }
}

class PromotionalMessageData {
  String? message;

  PromotionalMessageData({this.message});

  PromotionalMessageData.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = this.message;
    return data;
  }
}