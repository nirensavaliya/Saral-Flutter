
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart' as sales;

class QuotationListModel {
  List<QuotationData>? data;
  int? statusCode;
  String? responseMsg;

  QuotationListModel({this.data, this.statusCode, this.responseMsg});

  QuotationListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <QuotationData>[];
      json['data'].forEach((v) {
        data!.add(new QuotationData.fromJson(v));
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

class QuotationData {
  int? quoteId;
  int? salesOrderID;
  String? serialNo;
  String? orderNumber;
  String? date;
  String? customerName;
  String? contactNumber;
  String? invoiceType;
  double? netAmount;
  double? netPayableAmount;
  bool? allowEditEntry;
  bool? allowDeleteEntry;
  String? salesPerson;
  List<sales.SaleOrderDetails>? itemList;

  QuotationData(
      {this.quoteId,
        this.salesOrderID,
        this.serialNo,
        this.orderNumber,
        this.date,
        this.customerName,
        this.contactNumber,
        this.invoiceType,
        this.netAmount,
        this.netPayableAmount,
        this.allowEditEntry,
        this.allowDeleteEntry,
        this.salesPerson,
        this.itemList
      });

  QuotationData.fromJson(Map<String, dynamic> json) {
    quoteId = json['quoteId'];
    salesOrderID = json['salesOrderID'];
    serialNo = json['serialNo'];
    orderNumber = json['orderNumber'];
    date = json['date'];
    customerName = json['customerName'] ?? "N/A";
    contactNumber = json['contactNumber']?? "N/A";
    invoiceType = json['invoiceType'];
    netAmount = json['netAmount'];
    netPayableAmount = json['netPayableAmount'];
    allowEditEntry = json['allowEditEntry'];
    allowDeleteEntry = json['allowDeleteEntry'];
    salesPerson = json['salesPerson'];
    if (json['SaleOrderDetails'] != null) {
      itemList = (json['saleOrderDetails'] as List)
          .map((v) => sales.SaleOrderDetails.fromJson(v)).cast<sales.SaleOrderDetails>()
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quoteId'] = this.quoteId;
    data['salesOrderID'] = this.salesOrderID;
    data['serialNo'] = this.serialNo;
    data['orderNumber'] = this.orderNumber;
    data['date'] = this.date;
    data['customerName'] = this.customerName;
    data['contactNumber'] = this.contactNumber;
    data['invoiceType'] = this.invoiceType;
    data['netAmount'] = this.netAmount;
    data['netPayableAmount'] = this.netPayableAmount;
    data['allowEditEntry'] = this.allowEditEntry;
    data['allowDeleteEntry'] = this.allowDeleteEntry;
    data['salesPerson'] = this.salesPerson;
    if (itemList != null) {
      data['saleOrderDetails'] =
          itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
