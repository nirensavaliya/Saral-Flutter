class GetCategoryBrandListModel {
  List<CategoryBrandData>? data;
  int? statusCode;
  String? responseMsg;

  GetCategoryBrandListModel({this.data, this.statusCode, this.responseMsg});

  GetCategoryBrandListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryBrandData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryBrandData.fromJson(v));
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

class CategoryBrandData {
  int? brandID;
  int? categoryID;
  String? brandName;
  String? categoryName;
  String? imageUrl;

  CategoryBrandData({this.brandID, this.brandName});

  CategoryBrandData.fromJson(Map<String, dynamic> json) {
    brandID = json['brandID'];
    brandName = json['brandName'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandID'] = this.brandID;
    data['brandName'] = this.brandName;
    data['categoryID'] = this.categoryID;
    data['categoryName'] = this.categoryName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
