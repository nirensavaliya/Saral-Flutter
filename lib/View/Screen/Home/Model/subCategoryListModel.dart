class SubCategoryListModel {
  final List<SubCategoryListData>? data;
  final int? statusCode;
  final String? responseMsg;

  SubCategoryListModel({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryListModel(
      data: json["data"] == null
          ? []
          : List<SubCategoryListData>.from(
              json["data"].map((x) => SubCategoryListData.fromJson(x)),
            ),
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

class SubCategoryListData {
  final int? subCategoryID;
  final String? subCategoryName;
  final String? imageUrl;

  SubCategoryListData({
    this.subCategoryID,
    this.subCategoryName,
    this.imageUrl,
  });

  factory SubCategoryListData.fromJson(Map<String, dynamic> json) {
    return SubCategoryListData(
      subCategoryID: json["subCategoryID"] ??
          json["SubCategoryId"] ??
          json["subCategoryId"],
      subCategoryName: json["subCategoryName"] ??
          json["SubCategoryName"] ??
          json["subCategory"],
      imageUrl: json["imageUrl"] ?? json["ImageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subCategoryID": subCategoryID,
      "subCategoryName": subCategoryName,
      "imageUrl": imageUrl,
    };
  }
}
