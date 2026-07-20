import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/Service/sales_order_cart_service.dart';

class ProductDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt quantity = 1.obs;
  final List<int> qtyOptions = <int>[];
  final GlobalKey imageKey = GlobalKey();
  RxInt cartCount = 0.obs;
  final GlobalKey cartButtonKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  late AnimationController bounceController;
  late Animation<double> bounceAnimation;

  @override
  void onInit() {
    super.onInit();
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    bounceAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: bounceController, curve: Curves.easeOut));
  }

  void initQtyOptions(ItemListData? item) {
    // null / 0 → normal qty: 1, 2, 3, ...
    // e.g. 5 → 5, 10, 15, ...
    final interval = item?.orderQtyInterval;
    final int step = (interval == null || interval < 1) ? 1 : interval;
    qtyOptions
      ..clear()
      ..addAll(List.generate(20, (i) => step * (i + 1)));
    quantity.value = qtyOptions.first;
  }

  void setQuantity(int value) {
    quantity.value = value;
  }

  void animateCart() {
    cartCount.value++;
    bounceController.forward(from: 0);
  }

  /// Same calculation flow as Sale Order `calculateGstAndDiscountForSelectedItems`.
  Future<void> addProductToCart(ItemListData item) async {
    final int qty = quantity.value;
    final double itemPrice =
        double.tryParse(item.price?.toString() ?? "0") ?? 0;
    final double discountPercent = double.tryParse(
          (item.salesDiscountPER ?? item.discount)?.toString() ?? "0",
        ) ??
        0;

    // Prefer mapped gstTaxName; fallback lookup by gstCodeId.
    final String? gstTaxName = (item.gstTaxName != null &&
            item.gstTaxName!.trim().isNotEmpty)
        ? item.gstTaxName
        : ApiConstant.gstTaxNameForCode(item.gstCodeId);
    final double totalGstPercent = _parseGstPercent(gstTaxName);

    final double discountPerUnit = discountPercent / 100 * itemPrice;
    final double itemNetPrice = itemPrice - discountPerUnit;

    final double cgstPercent = totalGstPercent / 2;
    final double cgstPerUnit = itemNetPrice * cgstPercent / 100;
    final double sgstPerUnit = itemNetPrice * cgstPercent / 100;
    final double igstPerUnit = itemNetPrice * totalGstPercent / 100;

    final double lineDiscount = discountPerUnit * qty;
    final double lineCgst = cgstPerUnit * qty;
    final double lineSgst = sgstPerUnit * qty;
    final double lineIgst = igstPerUnit * qty;
    final double itemGrossAmount = qty * itemPrice;
    final double itemNetAmount =
        (itemNetPrice + cgstPerUnit + sgstPerUnit) * qty;
    final double itemTaxablePrice = itemGrossAmount - lineDiscount;

    final details = SaleOrderDetails(
      itemId: item.itemid,
      itemName: item.itemName,
      unit: item.unitCode,
      qty: double.parse(qty.toString()),
      price: double.parse(itemPrice.toString()),
      discountPer: double.parse(discountPercent.toString()),
      discount: double.parse(discountPerUnit.toString()),
      totalDiscount: double.parse(lineDiscount.toStringAsFixed(2)),
      gstcodeId: item.gstCodeId ?? 0,
      netPriceINCTax: double.parse(itemNetPrice.toString()),
      cgstPer: double.parse(cgstPercent.toString()),
      cgstAmount: double.parse(lineCgst.toStringAsFixed(2)),
      sgstPer: double.parse(cgstPercent.toString()),
      sgstAmount: double.parse(lineSgst.toStringAsFixed(2)),
      igstPer: double.parse(totalGstPercent.toString()),
      igstAmount: double.parse(lineIgst.toStringAsFixed(2)),
      taxableAmount: double.parse(itemTaxablePrice.toStringAsFixed(2)),
      netAmount: double.parse(itemNetAmount.toStringAsFixed(2)),
      grossAmount: double.parse(itemGrossAmount.toStringAsFixed(2)),
    );

    final double totalAmt = itemPrice * qty;
    await SalesOrderCartService.save(
      items: [details],
      total: totalAmt.toStringAsFixed(2),
      discountTotal: lineDiscount.toStringAsFixed(2),
      cGstTotal: lineCgst.toStringAsFixed(2),
      sGstTotal: lineSgst.toStringAsFixed(2),
      iGstTotal: lineIgst.toStringAsFixed(2),
      totalItem: "1",
      netTotal: itemNetAmount.toStringAsFixed(2),
      customerName: "Product Cart",
    );

    // Refresh Home cart badge without opening Cart screen.
    if (Get.isRegistered<AddToCartController>()) {
      Get.find<AddToCartController>().loadCarts();
    }
  }

  double _parseGstPercent(String? gstTaxName) {
    if (gstTaxName == null || gstTaxName.trim().isEmpty) return 0;
    final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(gstTaxName);
    if (match == null) return 0;
    return double.tryParse(match.group(1) ?? "0") ?? 0;
  }

  @override
  void onClose() {
    bounceController.dispose();
    super.onClose();
  }
}
