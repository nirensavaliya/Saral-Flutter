class PendingSaleOrder {
  String? orderNo;
  String? customerName;
  String? itemName;
  double? ordered;
  double? delivered;
  double? pending;
  String? remarks;

  PendingSaleOrder({
    this.orderNo,
    this.customerName,
    this.itemName,
    this.ordered,
    this.delivered,
    this.pending,
    this.remarks,
  });

  factory PendingSaleOrder.fromJson(Map<String, dynamic> json) {
    return PendingSaleOrder(
      orderNo: json['orderNo'],
      customerName: json['customerName'],
      itemName: json['itemName'],
      ordered: (json['ordered'] as num?)?.toDouble(),
      delivered: (json['delivered'] as num?)?.toDouble(),
      pending: (json['pending'] as num?)?.toDouble(),
      remarks: json['remarks'],
    );
  }
}

class PendingSaleOrderResponse {
  List<PendingSaleOrder>? data;
  int? statusCode;
  String? responseMsg;

  PendingSaleOrderResponse({this.data, this.statusCode, this.responseMsg});

  factory PendingSaleOrderResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return PendingSaleOrderResponse(
      data: raw is List
          ? raw.map((e) => PendingSaleOrder.fromJson(
                e is Map<String, dynamic>
                    ? e
                    : Map<String, dynamic>.from(e as Map),
              )).toList()
          : [],
      statusCode: json['statusCode'],
      responseMsg: json['responseMsg'],
    );
  }
}
