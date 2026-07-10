class GetReportItemListModel {
  List<ItemListData>? data;
  int? statusCode;
  String? responseMsg;

  GetReportItemListModel({this.data, this.statusCode, this.responseMsg});

  GetReportItemListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ItemListData>[];
      json['data'].forEach((v) {
        data!.add(new ItemListData.fromJson(v));
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

class ItemListData {
  String? itemName;
  String? itemCode;
  String? unitCode;
  String? unitCode1;
  Null? unitqty;
  double? price;
  double? purchasePrice;
  double? purchaseVATamt;
  double? discount;
  double? finalCost;
  String? designNo;
  String? defaultBarcodeNo;
  double? reminderQty;
  double? minQtyLevel;
  double? maxQtyLevel;
  double? maxQty;
  String? hsnCode;
  double? sellingPriceIncVAT;
  int? sellingPrice;
  double? salesDiscountPER;
  int? saleDiscountPER;
  String? alternateUnitCode;
  double? alternateUnitQty;
  int? alternateUnitStock;
  bool? isActive;
  double? saleMRP;
  int? mrp;
  int? categoryID;
  int? brandID;
  int? itemid;
  String? brandName;
  int? subCategoryID;
  double? stockQty;
  String? gstTaxName;
  String? subCategory;
  String? name;
  String? imageFileName;
  String? itemImage;
  Null? settingValue;
  Null? settingCode;
  double? minRequiredStock;
  double? maxRequiredStock;
  String? mUnitCode;

  ItemListData(
      {this.itemName,
        this.itemCode,
        this.unitCode,
        this.unitCode1,
        this.unitqty,
        this.price,
        this.purchasePrice,
        this.purchaseVATamt,
        this.discount,
        this.finalCost,
        this.designNo,
        this.defaultBarcodeNo,
        this.reminderQty,
        this.minQtyLevel,
        this.maxQtyLevel,
        this.maxQty,
        this.hsnCode,
        this.sellingPriceIncVAT,
        this.sellingPrice,
        this.salesDiscountPER,
        this.saleDiscountPER,
        this.alternateUnitCode,
        this.alternateUnitQty,
        this.alternateUnitStock,
        this.isActive,
        this.saleMRP,
        this.mrp,
        this.categoryID,
        this.brandID,
        this.itemid,
        this.brandName,
        this.subCategoryID,
        this.stockQty,
        this.gstTaxName,
        this.subCategory,
        this.name,
        this.imageFileName,
        this.itemImage,
        this.settingValue,
        this.settingCode,
        this.minRequiredStock,
        this.maxRequiredStock,
        this.mUnitCode});

  ItemListData.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemCode = json['itemCode'];
    unitCode = json['unitCode'];
    unitCode1 = json['unitCode1'];
    unitqty = json['unitqty'];
    price = json['price'];
    purchasePrice = json['purchasePrice'];
    purchaseVATamt = json['purchaseVATamt'];
    discount = json['discount'];
    finalCost = json['finalCost'];
    designNo = json['designNo'];
    defaultBarcodeNo = json['defaultBarcodeNo'];
    reminderQty = json['reminderQty'];
    minQtyLevel = json['minQtyLevel'];
    maxQtyLevel = json['maxQtyLevel'];
    maxQty = json['maxQty'];
    hsnCode = json['hsnCode'];
    sellingPriceIncVAT = json['sellingPriceIncVAT'];
    sellingPrice = json['sellingPrice'];
    salesDiscountPER = json['salesDiscountPER'];
    saleDiscountPER = json['saleDiscountPER'];
    alternateUnitCode = json['alternateUnitCode'];
    alternateUnitQty = json['alternateUnitQty'];
    alternateUnitStock = json['alternateUnitStock'];
    isActive = json['isActive'];
    saleMRP = json['saleMRP'];
    mrp = json['mrp'];
    categoryID = json['categoryID'];
    brandID = json['brandID'];
    itemid = json['itemid'];
    brandName = json['brandName'];
    subCategoryID = json['subCategoryID'];
    stockQty = json['stockQty'];
    gstTaxName = json['gstTaxName'];
    subCategory = json['subCategory'];
    name = json['name'];
    imageFileName = json['imageFileName'];
    itemImage = json['itemImage'];
    settingValue = json['settingValue'];
    settingCode = json['settingCode'];
    minRequiredStock = json['minRequiredStock'];
    maxRequiredStock = json['maxRequiredStock'];
    mUnitCode = json['mUnitCode'];
  }

  String? get displayImageUrl {
    if (itemImage != null && itemImage!.trim().isNotEmpty) {
      return itemImage!.trim();
    }
    if (imageFileName != null && imageFileName!.trim().isNotEmpty) {
      return imageFileName!.trim();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemCode'] = this.itemCode;
    data['unitCode'] = this.unitCode;
    data['unitCode1'] = this.unitCode1;
    data['unitqty'] = this.unitqty;
    data['price'] = this.price;
    data['purchasePrice'] = this.purchasePrice;
    data['purchaseVATamt'] = this.purchaseVATamt;
    data['discount'] = this.discount;
    data['finalCost'] = this.finalCost;
    data['designNo'] = this.designNo;
    data['defaultBarcodeNo'] = this.defaultBarcodeNo;
    data['reminderQty'] = this.reminderQty;
    data['minQtyLevel'] = this.minQtyLevel;
    data['maxQtyLevel'] = this.maxQtyLevel;
    data['maxQty'] = this.maxQty;
    data['hsnCode'] = this.hsnCode;
    data['sellingPriceIncVAT'] = this.sellingPriceIncVAT;
    data['sellingPrice'] = this.sellingPrice;
    data['salesDiscountPER'] = this.salesDiscountPER;
    data['saleDiscountPER'] = this.saleDiscountPER;
    data['alternateUnitCode'] = this.alternateUnitCode;
    data['alternateUnitQty'] = this.alternateUnitQty;
    data['alternateUnitStock'] = this.alternateUnitStock;
    data['isActive'] = this.isActive;
    data['saleMRP'] = this.saleMRP;
    data['mrp'] = this.mrp;
    data['categoryID'] = this.categoryID;
    data['brandID'] = this.brandID;
    data['itemid'] = this.itemid;
    data['brandName'] = this.brandName;
    data['subCategoryID'] = this.subCategoryID;
    data['stockQty'] = this.stockQty;
    data['gstTaxName'] = this.gstTaxName;
    data['subCategory'] = this.subCategory;
    data['name'] = this.name;
    data['imageFileName'] = this.imageFileName;
    data['itemImage'] = this.itemImage;
    data['settingValue'] = this.settingValue;
    data['settingCode'] = this.settingCode;
    data['minRequiredStock'] = this.minRequiredStock;
    data['maxRequiredStock'] = this.maxRequiredStock;
    data['mUnitCode'] = this.mUnitCode;
    return data;
  }
}
