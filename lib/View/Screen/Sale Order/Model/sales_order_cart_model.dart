import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';

class SalesOrderCartModel {
  SalesOrderCartModel({
    required this.cartId,
    required this.items,
    required this.total,
    required this.discountTotal,
    required this.cGstTotal,
    required this.sGstTotal,
    required this.iGstTotal,
    required this.totalItem,
    required this.netTotal,
    this.orderNo,
    this.customerId,
    this.customerName,
    this.savedAt,
  });

  final String cartId;
  final List<SaleOrderDetails> items;
  final String total;
  final String discountTotal;
  final String cGstTotal;
  final String sGstTotal;
  final String iGstTotal;
  final String totalItem;
  final String netTotal;
  final String? orderNo;
  final int? customerId;
  final String? customerName;
  final String? savedAt;

  factory SalesOrderCartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = <SaleOrderDetails>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(SaleOrderDetails.fromJson(item));
        } else if (item is Map) {
          items.add(SaleOrderDetails.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return SalesOrderCartModel(
      cartId: json['cartId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      total: json['total']?.toString() ?? '0',
      discountTotal: json['discountTotal']?.toString() ?? '0',
      cGstTotal: json['cGstTotal']?.toString() ?? '0',
      sGstTotal: json['sGstTotal']?.toString() ?? '0',
      iGstTotal: json['iGstTotal']?.toString() ?? '0',
      totalItem: json['totalItem']?.toString() ?? '0',
      netTotal: json['netTotal']?.toString() ?? '0',
      orderNo: json['orderNo']?.toString(),
      customerId: json['customerId'] is int
          ? json['customerId'] as int
          : int.tryParse(json['customerId']?.toString() ?? ''),
      customerName: json['customerName']?.toString(),
      savedAt: json['savedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'discountTotal': discountTotal,
      'cGstTotal': cGstTotal,
      'sGstTotal': sGstTotal,
      'iGstTotal': iGstTotal,
      'totalItem': totalItem,
      'netTotal': netTotal,
      'orderNo': orderNo,
      'customerId': customerId,
      'customerName': customerName,
      'savedAt': savedAt,
    };
  }
}
