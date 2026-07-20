class GetLedgerStatementModel {
  List<ledgerData>? data;
  int? statusCode;
  String? responseMsg;

  GetLedgerStatementModel({this.data, this.statusCode, this.responseMsg});

  GetLedgerStatementModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ledgerData>[];
      json['data'].forEach((v) {
        data!.add(new ledgerData.fromJson(v));
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

class ledgerData {
  String? zoomPkValue;
  String? glDate;
  String? description;
  String? account;
  String? transaction;
  String? transChannel;
  String? serialNumber;
  String? remarks;
  double? cr;
  double? dr;
  String? balance;

  ledgerData(
      {        this.zoomPkValue,
        this.glDate,
        this.description,
        this.account,
        this.transaction,
        this.transChannel,
        this.serialNumber,
        this.remarks,
        this.cr,
        this.dr,
        this.balance});

  ledgerData.fromJson(Map<String, dynamic> json) {
    glDate = json['glDate'];
    zoomPkValue=  json['zoomPkValue'] ?? '';
    description = json['description'];
    account = json['account'];
    transaction = json['transaction'];
    transChannel = json['transChannel'];
    serialNumber = json['serialNumber'];
    remarks = json['remarks'];
    cr = json['cr'];
    dr = json['dr'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zoomPkValue'] = this.zoomPkValue;
    data['glDate'] = this.glDate;
    data['description'] = this.description;
    data['account'] = this.account;
    data['transaction'] = this.transaction;
    data['transChannel'] = this.transChannel;
    data['serialNumber'] = this.serialNumber;
    data['remarks'] = this.remarks;
    data['cr'] = this.cr;
    data['dr'] = this.dr;
    data['balance'] = this.balance;
    return data;
  }
}
