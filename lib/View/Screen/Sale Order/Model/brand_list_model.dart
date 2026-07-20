class GetBranddListModel {
  List<BranddData>? data;
  int? statusCode;
  String? responseMsg;

  GetBranddListModel({this.data, this.statusCode, this.responseMsg});

  GetBranddListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BranddData>[];
      json['data'].forEach((v) {
        data!.add(new BranddData.fromJson(v));
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

class BranddData {
  int? brandID;
  String? brandName;
  String? imageUrl;

  BranddData({this.brandID, this.brandName});

  BranddData.fromJson(Map<String, dynamic> json) {
    brandID = json['brandID'];
    brandName = json['brandName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandID'] = this.brandID;
    data['brandName'] = this.brandName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
