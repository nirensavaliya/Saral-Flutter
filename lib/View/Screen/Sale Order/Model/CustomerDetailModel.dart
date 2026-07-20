class CustomerDetailResponse {
  final CustomerDetail? data;
  final int? statusCode;
  final String? responseMsg;

  CustomerDetailResponse({
    this.data,
    this.statusCode,
    this.responseMsg,
  });

  factory CustomerDetailResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailResponse(
      data: json['data'] != null ? CustomerDetail.fromJson(json['data']) : null,
      statusCode: json['statusCode'],
      responseMsg: json['responseMsg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'statusCode': statusCode,
      'responseMsg': responseMsg,
    };
  }
}

class CustomerDetail {
  final int? customerID;
  final String? customerName;
  final String? contactNo;
  final String? gstinNumber;
  final String? gstType;

  CustomerDetail({
    this.customerID,
    this.customerName,
    this.contactNo,
    this.gstinNumber,
    this.gstType,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      customerID: json['customerID'],
      customerName: json['customerName'],
      contactNo: json['contactNo'],
      gstinNumber: json['gstinNumber'],
      gstType: json['gstType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': customerID,
      'customerName': customerName,
      'contactNo': contactNo,
      'gstinNumber': gstinNumber,
      'gstType': gstType,
    };
  }
}