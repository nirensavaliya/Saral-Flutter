class MonthlyTotalPurchaseModel {
  List<MonhtlyPurchaseData>? data;
  int? statusCode;
  String? responseMsg;

  MonthlyTotalPurchaseModel({this.data, this.statusCode, this.responseMsg});

  MonthlyTotalPurchaseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MonhtlyPurchaseData>[];
      json['data'].forEach((v) {
        data!.add(new MonhtlyPurchaseData.fromJson(v));
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

class MonhtlyPurchaseData {
  int? voucherNo;
  String? date;
  String? partyname;
  Null? purchaseType;
  int? creditLimit;
  double? discount;
  String? supplierVoucherNo;
  double? payableAmount;
  double? purchaseAmount;
  String? invoiceType;
  double? paid;
  double? totalOutstanding;
  double? totalRoundOffAmount;
  double? taxableAmountTotal;
  String? remarks;
  double? additionalCharges;
  double? netPayable;
  double? igstPer;
  double? igstAmt;
  double? cgstPer;
  double? cgstAmt;
  double? sgstPer;
  double? sgstAmt;
  String? taxMode;
  String? gstType;

  MonhtlyPurchaseData(
      {this.voucherNo,
        this.date,
        this.partyname,
        this.purchaseType,
        this.creditLimit,
        this.discount,
        this.supplierVoucherNo,
        this.payableAmount,
        this.purchaseAmount,
        this.invoiceType,
        this.paid,
        this.totalOutstanding,
        this.totalRoundOffAmount,
        this.taxableAmountTotal,
        this.remarks,
        this.additionalCharges,
        this.netPayable,
        this.igstPer,
        this.igstAmt,
        this.cgstPer,
        this.cgstAmt,
        this.sgstPer,
        this.sgstAmt,
        this.taxMode,
        this.gstType});

  MonhtlyPurchaseData.fromJson(Map<String, dynamic> json) {
    voucherNo = json['voucherNo'];
    date = json['date'];
    partyname = json['partyname'];
    purchaseType = json['purchaseType'];
    creditLimit = json['creditLimit'];
    discount = json['discount'];
    supplierVoucherNo = json['supplierVoucherNo'];
    payableAmount = json['payableAmount'];
    purchaseAmount = json['purchaseAmount'];
    invoiceType = json['invoiceType'];
    paid = json['paid'];
    totalOutstanding = json['totalOutstanding'];
    totalRoundOffAmount = json['totalRoundOffAmount'];
    taxableAmountTotal = json['taxableAmountTotal'];
    remarks = json['remarks'];
    additionalCharges = json['additionalCharges'];
    netPayable = json['netPayable'];
    igstPer = json['igstPer'];
    igstAmt = json['igstAmt'];
    cgstPer = json['cgstPer'];
    cgstAmt = json['cgstAmt'];
    sgstPer = json['sgstPer'];
    sgstAmt = json['sgstAmt'];
    taxMode = json['taxMode'];
    gstType = json['gstType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voucherNo'] = this.voucherNo;
    data['date'] = this.date;
    data['partyname'] = this.partyname;
    data['purchaseType'] = this.purchaseType;
    data['creditLimit'] = this.creditLimit;
    data['discount'] = this.discount;
    data['supplierVoucherNo'] = this.supplierVoucherNo;
    data['payableAmount'] = this.payableAmount;
    data['purchaseAmount'] = this.purchaseAmount;
    data['invoiceType'] = this.invoiceType;
    data['paid'] = this.paid;
    data['totalOutstanding'] = this.totalOutstanding;
    data['totalRoundOffAmount'] = this.totalRoundOffAmount;
    data['taxableAmountTotal'] = this.taxableAmountTotal;
    data['remarks'] = this.remarks;
    data['additionalCharges'] = this.additionalCharges;
    data['netPayable'] = this.netPayable;
    data['igstPer'] = this.igstPer;
    data['igstAmt'] = this.igstAmt;
    data['cgstPer'] = this.cgstPer;
    data['cgstAmt'] = this.cgstAmt;
    data['sgstPer'] = this.sgstPer;
    data['sgstAmt'] = this.sgstAmt;
    data['taxMode'] = this.taxMode;
    data['gstType'] = this.gstType;
    return data;
  }
}
