class GetItemListModel {
  List<ItemData>? data;
  int? statusCode;
  String? responseMsg;

  GetItemListModel({this.data, this.statusCode, this.responseMsg});

  GetItemListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(new ItemData.fromJson(v));
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

class ItemData {
  int? itemid;
  String? itemName;
  int? gstCodeId;
  String? unitCode;
  String? imageUrl;
  double? price;
  double? salesDiscountper;

  ItemData(
      {this.itemid,
        this.itemName,
        this.gstCodeId,
        this.unitCode,
        this.price,
        this.salesDiscountper,
        this.imageUrl,});

  ItemData.fromJson(Map<String, dynamic> json) {
    itemid = json['itemid'];
    itemName = json['itemName'];
    gstCodeId = json['gstCodeId'];
    unitCode = json['unitCode'];
    price = (json['price'] != null) ? (json['price'] as num).toDouble() : null;
    salesDiscountper = json['salesDiscountper'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemid'] = this.itemid;
    data['itemName'] = this.itemName;
    data['gstCodeId'] = this.gstCodeId;
    data['unitCode'] = this.unitCode;
    data['price'] = this.price;
    data['salesDiscountper'] = this.salesDiscountper;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
