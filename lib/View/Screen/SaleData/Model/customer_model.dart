class CustomerModel {
  List<CustomerData>? data;
  int? statusCode;
  String? responseMsg;

  CustomerModel({this.data, this.statusCode, this.responseMsg});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CustomerData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerData.fromJson(v));
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

class CustomerData {
  int? customerID;
  String? customerName;
  String? contactNo;
  String? gstinNumber;
  String? gstType;

  CustomerData(
      {this.customerID,
        this.customerName,
        this.contactNo,
        this.gstinNumber,
        this.gstType});

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerID = json['customerID'];
    customerName = json['customerName'];
    contactNo = json['contactNo'];
    gstinNumber = json['gstinNumber'];
    gstType = json['gstType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerID'] = this.customerID;
    data['customerName'] = this.customerName;
    data['contactNo'] = this.contactNo;
    data['gstinNumber'] = this.gstinNumber;
    data['gstType'] = this.gstType;
    return data;
  }
}
