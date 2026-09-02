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

  static List<int> qtyOptionsFor(ItemListData? item) {
    final interval = item?.orderQtyInterval;
    final int step = (interval == null || interval < 1) ? 1 : interval;
    return List.generate(20, (i) => step * (i + 1));
  }

  void initQtyOptions(ItemListData? item) {
    qtyOptions
      ..clear()
      ..addAll(qtyOptionsFor(item));
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
  Future<void> addProductToCart(ItemListData item, {int? qty}) async {
    await addProductsToCart([
      (item: item, qty: qty ?? quantity.value),
    ]);
  }

  Future<void> addProductsToCart(
    List<({ItemListData item, int qty})> entries,
  ) async {
    if (entries.isEmpty) return;

    final detailsList = <SaleOrderDetails>[];
    double totalAmt = 0;
    double discountTotal = 0;
    double cGstTotal = 0;
    double sGstTotal = 0;
    double iGstTotal = 0;
    double netTotal = 0;

    for (final entry in entries) {
      final details = _buildSaleOrderDetails(entry.item, entry.qty);
      detailsList.add(details);
      totalAmt += (entry.item.price ?? 0) * entry.qty;
      discountTotal += details.totalDiscount ?? 0;
      cGstTotal += details.cgstAmount ?? 0;
      sGstTotal += details.sgstAmount ?? 0;
      iGstTotal += details.igstAmount ?? 0;
      netTotal += details.netAmount ?? 0;
    }

    await SalesOrderCartService.save(
      items: detailsList,
      total: totalAmt.toStringAsFixed(2),
      discountTotal: discountTotal.toStringAsFixed(2),
      cGstTotal: cGstTotal.toStringAsFixed(2),
      sGstTotal: sGstTotal.toStringAsFixed(2),
      iGstTotal: iGstTotal.toStringAsFixed(2),
      totalItem: detailsList.length.toString(),
      netTotal: netTotal.toStringAsFixed(2),
      customerName: "Product Cart",
    );

    if (Get.isRegistered<AddToCartController>()) {
      Get.find<AddToCartController>().loadCarts();
    }
  }

  SaleOrderDetails _buildSaleOrderDetails(ItemListData item, int qty) {
    final double itemPrice =
        double.tryParse(item.price?.toString() ?? "0") ?? 0;
    final double discountPercent = double.tryParse(
          (item.salesDiscountPER ?? item.discount)?.toString() ?? "0",
        ) ??
        0;

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

    return SaleOrderDetails(
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
