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
    final raw = json["data"] ?? json["Data"];
    return CategoryListModel(
      data: raw is List
          ? raw
              .whereType<Map>()
              .map((x) => CategoryListData.fromJson(
                    Map<String, dynamic>.from(x),
                  ))
              .toList()
          : [],
      statusCode: json["statusCode"] ?? json["StatusCode"],
      responseMsg: json["responseMsg"] ?? json["ResponseMsg"],
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
      categoryID: _readInt(
        json["categoryID"] ?? json["CategoryId"] ?? json["categoryId"],
      ),
      categoryName: json["categoryName"]?.toString() ??
          json["CategoryName"]?.toString(),
      imageUrl: json["imageUrl"]?.toString() ?? json["ImageUrl"]?.toString(),
    );
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      "categoryID": categoryID,
      "categoryName": categoryName,
      "imageUrl": imageUrl,
    };
  }
}