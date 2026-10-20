import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Sale Order/Model/CustomerDetailModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/customer_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/new_serial_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/sales_order_cart_model.dart';
import 'package:saral/View/Screen/Sale Order/Service/sales_order_cart_service.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_form_ui.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/common_textfild.dart';

import '../../../../Common/Global.dart';

class AddToCartController extends GetxController {
  List<SalesOrderCartModel> carts = [];

  final TextEditingController customerController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController gstTypeController = TextEditingController();

  int customerId = 0;
  bool isCustomer = false;
  bool isPlacingOrder = false;
  CustomerDetailResponse customerDetail = CustomerDetailResponse();

  final ApiService _apiService = ApiService();
  final String companyToken = GetStorageData.readString(
    GetStorageData.token,
  );

  @override
  void onInit() {
    isCustomer = GetStorageData.readBoolean(GetStorageData.isCustomer);
    loadCarts();
    super.onInit();
  }

  @override
  void onReady() {
    _ensureCustomersLoaded();
    if (isCustomer) {
      _loadCustomerDetail();
    }
    super.onReady();
  }

  @override
  void onClose() {
    customerController.dispose();
    searchController.dispose();
    contactNumberController.dispose();
    gstTypeController.dispose();
    super.onClose();
  }

  void loadCarts() {
    carts = SalesOrderCartService.loadAll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isClosed) update();
    });
  }

  int get cartItemCount {
    int count = 0;

    for (final cart in carts) {
      count += cart.items.length;
    }

    return count;
  }

  Map<String, String> get grandTotals {
    double totalAmt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalNetAmount = 0;
    int totalItemCount = 0;

    for (final cart in carts) {
      for (final item in cart.items) {
        totalAmt += (item.price ?? 0) * (item.qty ?? 1);
        totalDiscount += item.totalDiscount ?? 0;
        totalCGST += item.cgstAmount ?? 0;
        totalSGST += item.sgstAmount ?? 0;
        totalIGST += item.igstAmount ?? 0;
        totalNetAmount += item.netAmount ?? 0;
      }
      totalItemCount += cart.items.length;
    }

    return {
      'total': totalAmt.toStringAsFixed(2),
      'discountTotal': totalDiscount.toStringAsFixed(2),
      'cGstTotal': totalCGST.toStringAsFixed(2),
      'sGstTotal': totalSGST.toStringAsFixed(2),
      'iGstTotal': totalIGST.toStringAsFixed(2),
      'totalItem': totalItemCount.toString(),
      'netTotal': totalNetAmount.toStringAsFixed(2),
    };
  }

  Map<String, String> cartTotals(SalesOrderCartModel cart) {
    double totalAmt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalNetAmount = 0;

    for (final item in cart.items) {
      totalAmt += (item.price ?? 0) * (item.qty ?? 1);
      totalDiscount += item.totalDiscount ?? 0;
      totalCGST += item.cgstAmount ?? 0;
      totalSGST += item.sgstAmount ?? 0;
      totalIGST += item.igstAmount ?? 0;
      totalNetAmount += item.netAmount ?? 0;
    }

    return {
      'total': totalAmt.toStringAsFixed(2),
      'discountTotal': totalDiscount.toStringAsFixed(2),
      'cGstTotal': totalCGST.toStringAsFixed(2),
      'sGstTotal': totalSGST.toStringAsFixed(2),
      'iGstTotal': totalIGST.toStringAsFixed(2),
      'totalItem': cart.items.length.toString(),
      'netTotal': totalNetAmount.toStringAsFixed(2),
    };
  }

  Future<void> clearCart() async {
    SalesOrderCartService.clear();
    loadCarts();
  }

  Future<void> removeCart(String cartId) async {
    await SalesOrderCartService.removeCart(cartId);
    loadCarts();
  }

  Future<void> removeItem(String cartId, int itemIndex) async {
    await SalesOrderCartService.removeItem(cartId, itemIndex);
    loadCarts();
  }

  Future<void> updateItemQty(
    String cartId,
    int itemIndex,
    double newQty,
  ) async {
    await SalesOrderCartService.updateItemQty(cartId, itemIndex, newQty);
    loadCarts();
  }

  int get cartCount => carts.length;

  List<SaleOrderDetails> get allCartItems {
    final items = <SaleOrderDetails>[];
    for (final cart in carts) {
      items.addAll(cart.items);
    }
    return items;
  }

  Future<void> _ensureCustomersLoaded() async {
    if (ApiConstant.customerList.isNotEmpty) return;
    try{
      final response = await _apiService.getRequest(
        ApiConstant.getCustomerList,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      if (response.statusCode == 200) {
        final model = CustomerModel.fromJson(response.data);
        ApiConstant.customerList = model.data ?? [];
        update();
      }
    }catch (e) {
      debugPrint("Customer list failed: $e");
      // optional: toast "No internet connection"
    }

  }

  Future<void> _loadCustomerDetail() async {
    final response = await _apiService.getRequest(
      ApiConstant.GetCustomerDetails,
      headers: {"Authorization": "Bearer $companyToken"},
    );
    if (response.statusCode == 200) {
      customerDetail = CustomerDetailResponse.fromJson(response.data);
      if (customerDetail.data != null) {
        customerController.text = customerDetail.data!.customerName ?? "";
        contactNumberController.text = customerDetail.data!.contactNo ?? "";
        gstTypeController.text = customerDetail.data!.gstType ?? "";
        customerId = customerDetail.data!.customerID ?? 0;
        update();
      }
    }
  }

  void selectCustomer() {
    filteredCustomer = ApiConstant.customerList;
    searchController.clear();
    Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<AddToCartController>(
        builder: (controller) {
          return Container(
            height: Get.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SalesOrderSheetHeader(
                  title: "Select Customer",
                  subtitle: "Search and choose a customer",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: CommonTextField(
                    controller: searchController,
                    borderRadius: 12,
                    prefix: const Icon(Icons.search, color: Color(0xffC8102E)),
                    hintText: "Search customer",
                    onChanged: (value) {
                      _filterCustomers(value);
                    },
                  ),
                ),
                Expanded(
                  child: filteredCustomer.isEmpty
                      ? const Center(child: Text("No customers found"))
                      : ListView.builder(
                          itemCount: filteredCustomer.length,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          itemBuilder: (context, index) {
                            final customer = filteredCustomer[index];
                            final name = customer.customerName ?? '';
                            final phone = customer.contactNo ?? '';
                            final title = phone.isNotEmpty
                                ? "$name - $phone"
                                : name;
                            return SalesOrderSheetOptionTile(
                              title: title,
                              subtitle: customer.contactNo,
                              onTap: () {
                                customerController.text = title;
                                customerId = customer.customerID ?? 0;
                                contactNumberController.text =
                                    customer.contactNo ?? "";
                                gstTypeController.text =
                                    customer.gstType ?? "";
                                Get.back();
                                update();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomer = ApiConstant.customerList;
    } else {
      filteredCustomer = ApiConstant.customerList
          .where((c) =>
              (c.customerName ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (c.contactNo ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  Future<void> goToShippingScreen({BuildContext? context}) async {
    final ctx = context ?? Get.context;

    if (carts.isEmpty || allCartItems.isEmpty) {
      if (ctx != null) {
        Utils().showToast(
          context: ctx,
          title: "Error",
          message: "Cart is empty",
          isSuccess: false,
        );
      }
      return;
    }

    if(!isLoggedIn){}else{
      if (customerId == 0 || customerController.text.trim().isEmpty) {
        if (ctx != null) {
          Utils().showToast(
            context: ctx,
            title: "Error",
            message: "Please select customer",
            isSuccess: false,
          );
        }
        return;
      }
    }


    Get.toNamed(AppRoutes.shippingAddressScreen);
  }

  Future<void> placeOrder({
    BuildContext? context,
    String shippingAddress = "",
    DateTime? deliveryDate,
    DateTime? poDate,
    String remarks = "",
  }) async {
    final ctx = context ?? Get.context;

    if (!isLoggedIn) {
      Global.showLoginRequiredDialog();
      return;
    }

    if (carts.isEmpty || allCartItems.isEmpty) {
      if (ctx != null) {
        Utils().showToast(
          context: ctx,
          title: "Error",
          message: "Cart is empty",
          isSuccess: false,
        );
      }
      return;
    }

    if (customerId == 0 || customerController.text.trim().isEmpty) {
      if (ctx != null) {
        Utils().showToast(
          context: ctx,
          title: "Error",
          message: "Please select customer",
          isSuccess: false,
        );
      }
      return;
    }

    isPlacingOrder = true;
    update();

    if (ctx != null) {
      CommonLoader.show(ctx);
      // Let overlay paint before API work starts.
      await Future.delayed(const Duration(milliseconds: 50));
    }

    try {
      int tempCustomerId = 0;
      String apiURL = "";
      if (isCustomer == false) {
        tempCustomerId = customerId;
        apiURL = ApiConstant.saveSaleOrder;
      } else {
        tempCustomerId = customerDetail.data?.customerID ?? customerId;
        apiURL = ApiConstant.SaveSaleOrderfromcustomer;
      }

      final orderNo = await _fetchNextOrderNo();
      final totals = grandTotals;
      final now = DateTime.now();
      final dateIso = _postmanStyleUtc(now);
      final deliveryIso = deliveryDate != null
          ? _postmanStyleUtc(deliveryDate)
          : dateIso;
      final poDateIso = poDate != null ? _postmanStyleUtc(poDate) : dateIso;

      final dataa = {
        "date": dateIso,
        "taxMode": "GST",
        "invoiceType": "",
        "orderNo": orderNo,
        "customerId": tempCustomerId,
        "customerName": customerController.text,
        "contactNumber": contactNumberController.text,
        "shippingAddress": shippingAddress,
        "deliveryDate": deliveryIso,
        "poDate": poDateIso,
        "poNumber": "",
        "transport": "",
        "status": "",
        "remarks": remarks,
        "gstType": gstTypeController.text.isEmpty
            ? "CGST_SGST"
            : gstTypeController.text,
        "total": _parseAmount(totals['total']),
        "discountTotal": _parseAmount(totals['discountTotal']),
        "cgstTotal": _parseAmount(totals['cGstTotal']),
        "sgstTotal": _parseAmount(totals['sGstTotal']),
        "igstTotal": _parseAmount(totals['iGstTotal']),
        "netTotal": _parseAmount(totals['netTotal']),
        "saleOrderDetails":
            allCartItems.map((e) => e.toJson()).toList(),
      };

      final response = await _apiService.postRequest(
        apiURL,
        headers: {"Authorization": "Bearer $companyToken"},
        data: json.encode(dataa),
      );

      CommonLoader.hide();

      if (response.statusCode == 200) {
        final successArgs = {
          'orderNo': orderNo,
          'netTotal': totals['netTotal'] ?? '0.00',
          'totalItem': totals['totalItem'] ?? '0',
          'customerName': customerController.text.trim(),
          'date': DateTime.now(),
        };
        await clearCart();
        Get.offNamed(
          AppRoutes.orderSuccessScreen,
          arguments: successArgs,
        );
      } else {
        if (ctx != null) {
          Utils().showToast(
            context: ctx,
            title: "Error",
            message: "Failed to place order",
            isSuccess: false,
          );
        }
      }
    } catch (_) {
      CommonLoader.hide();
      if (ctx != null) {
        Utils().showToast(
          context: ctx,
          title: "Error",
          message: "Failed to place order",
          isSuccess: false,
        );
      }
    } finally {
      isPlacingOrder = false;
      update();
    }
  }

  Future<int> _fetchNextOrderNo() async {
    try {
      final response = await _apiService.getRequest(
        "${ApiConstant.nextOrderNo}/Bill of Supply",
        headers: {"Authorization": "Bearer $companyToken"},
      );
      if (response.statusCode == 200) {
        final model = NextSerialNoModel.fromJson(response.data);
        return model.data?.orderNumber ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  double _parseAmount(String? value) {
    if (value == null || value.isEmpty || value == "0.0" || value == "0.00") {
      return 0;
    }
    return double.tryParse(value) ?? 0;
  }

  String _postmanStyleUtc(DateTime local) {
    final u = local.toUtc();
    return '${u.year.toString().padLeft(4, '0')}-'
        '${u.month.toString().padLeft(2, '0')}-'
        '${u.day.toString().padLeft(2, '0')}T'
        '${u.hour.toString().padLeft(2, '0')}:'
        '${u.minute.toString().padLeft(2, '0')}:'
        '${u.second.toString().padLeft(2, '0')}.'
        '${u.millisecond.toString().padLeft(3, '0')}Z';
  }
}
