class GlAccountModel {
  List<GlAccountData>? data;
  int? statusCode;
  String? responseMsg;

  GlAccountModel({this.data, this.statusCode, this.responseMsg});

  GlAccountModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GlAccountData>[];
      json['data'].forEach((v) {
        data!.add(new GlAccountData.fromJson(v));
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

class GlAccountData {
  int? glAccountNumber;
  String? glAccountName;

  GlAccountData({this.glAccountNumber, this.glAccountName});

  GlAccountData.fromJson(Map<String, dynamic> json) {
    glAccountNumber = json['glAccountNumber'];
    glAccountName = json['glAccountName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['glAccountNumber'] = this.glAccountNumber;
    data['glAccountName'] = this.glAccountName;
    return data;
  }
}
