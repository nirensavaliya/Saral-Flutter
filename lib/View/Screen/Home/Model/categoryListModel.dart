class CategoryListModel {
  final List<CategoryListData>? data;
  final int? statusCode;
  final String? responseMsg;

  CategoryListModel({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
      data: json["data"] == null
          ? []
          : List<CategoryListData>.from(
          json["data"].map((x) => CategoryListData.fromJson(x))),
      statusCode: json["statusCode"],
      responseMsg: json["responseMsg"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data == null
          ? []
          : List<dynamic>.from(data!.map((x) => x.toJson())),
      "statusCode": statusCode,
      "responseMsg": responseMsg,
    };
  }
}

class CategoryListData {
  final int? categoryID;
  final String? categoryName;
  final String? imageUrl;

  CategoryListData({
    this.categoryID,
    this.categoryName,
    this.imageUrl,
  });

  factory CategoryListData.fromJson(Map<String, dynamic> json) {
    return CategoryListData(
      categoryID: json["categoryID"],
      categoryName: json["categoryName"],
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "categoryID": categoryID,
      "categoryName": categoryName,
      "imageUrl": imageUrl,
    };
  }
}