class MonthlyTotalSaleModel {
  List<MonthlySaleData>? data;
  int? statusCode;
  String? responseMsg;

  MonthlyTotalSaleModel({this.data, this.statusCode, this.responseMsg});

  MonthlyTotalSaleModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MonthlySaleData>[];
      json['data'].forEach((v) {
        data!.add(new MonthlySaleData.fromJson(v));
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

class MonthlySaleData {
  String? date;
  String? billSrNo;
  String? custName;
  String? saleType;
  String? shipTo;
  String? contactNo;
  String? invoiceType;
  int? creditDays;
  String? taxMode;
  String? gstType;
  String? gstinNumber;
  String? customerGSTType;
  double? discount;
  double? grossAmount;
  double? netAmount;
  double? saleAmountExDiscount;
  double? totalItemDiscount;
  double? saleAmountIncDiscount;
  double? netPayableAmount;
  double? paid;
  double? totalOutstanding;
  double? igstPer;
  double? igstAmt;
  double? cgstPer;
  double? cgstAmt;
  double? sgstPer;
  double? sgstAmt;
  double? saleTaxableAmt;

  MonthlySaleData(
      {this.date,
        this.billSrNo,
        this.custName,
        this.saleType,
        this.shipTo,
        this.contactNo,
        this.invoiceType,
        this.creditDays,
        this.taxMode,
        this.gstType,
        this.gstinNumber,
        this.customerGSTType,
        this.discount,
        this.grossAmount,
        this.netAmount,
        this.saleAmountExDiscount,
        this.totalItemDiscount,
        this.saleAmountIncDiscount,
        this.netPayableAmount,
        this.paid,
        this.totalOutstanding,
        this.igstPer,
        this.igstAmt,
        this.cgstPer,
        this.cgstAmt,
        this.sgstPer,
        this.sgstAmt,
        this.saleTaxableAmt});

  MonthlySaleData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    billSrNo = json['billSrNo'];
    custName = json['custName'];
    saleType = json['saleType'];
    shipTo = json['shipTo'];
    contactNo = json['contactNo'];
    invoiceType = json['invoiceType'];
    creditDays = json['creditDays'];
    taxMode = json['taxMode'];
    gstType = json['gstType'];
    gstinNumber = json['gstinNumber'];
    customerGSTType = json['customerGSTType'];
    discount = json['discount'];
    grossAmount = json['grossAmount'];
    netAmount = json['netAmount'];
    saleAmountExDiscount = json['saleAmountExDiscount'];
    totalItemDiscount = json['totalItemDiscount'];
    saleAmountIncDiscount = json['saleAmountIncDiscount'];
    netPayableAmount = json['netPayableAmount'];
    paid = json['paid'];
    totalOutstanding = json['totalOutstanding'];
    igstPer = json['igstPer'];
    igstAmt = json['igstAmt'];
    cgstPer = json['cgstPer'];
    cgstAmt = json['cgstAmt'];
    sgstPer = json['sgstPer'];
    sgstAmt = json['sgstAmt'];
    saleTaxableAmt = json['saleTaxableAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['billSrNo'] = this.billSrNo;
    data['custName'] = this.custName;
    data['saleType'] = this.saleType;
    data['shipTo'] = this.shipTo;
    data['contactNo'] = this.contactNo;
    data['invoiceType'] = this.invoiceType;
    data['creditDays'] = this.creditDays;
    data['taxMode'] = this.taxMode;
    data['gstType'] = this.gstType;
    data['gstinNumber'] = this.gstinNumber;
    data['customerGSTType'] = this.customerGSTType;
    data['discount'] = this.discount;
    data['grossAmount'] = this.grossAmount;
    data['netAmount'] = this.netAmount;
    data['saleAmountExDiscount'] = this.saleAmountExDiscount;
    data['totalItemDiscount'] = this.totalItemDiscount;
    data['saleAmountIncDiscount'] = this.saleAmountIncDiscount;
    data['netPayableAmount'] = this.netPayableAmount;
    data['paid'] = this.paid;
    data['totalOutstanding'] = this.totalOutstanding;
    data['igstPer'] = this.igstPer;
    data['igstAmt'] = this.igstAmt;
    data['cgstPer'] = this.cgstPer;
    data['cgstAmt'] = this.cgstAmt;
    data['sgstPer'] = this.sgstPer;
    data['sgstAmt'] = this.sgstAmt;
    data['saleTaxableAmt'] = this.saleTaxableAmt;
    return data;
  }
}
