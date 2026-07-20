import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Pending Sale Order/Model/pending_sale_order_model.dart';
import 'package:saral/View/Utils/App_Pages.dart';

import '../../../Utils/App_Routes.dart';
import '../../Sale Order/Model/quoation_list_model.dart';

class PendingSaleOrderController extends GetxController {
  RxList<PendingSaleOrder> orderList = <PendingSaleOrder>[].obs;
  RxBool isLoading = false.obs;
  final ApiService _apiService = ApiService();
  bool isData = false;
  String startDate = "";
  String endDate = "";
  TextEditingController invoiceController = TextEditingController();

  String? get _token => GetStorageData.readString(GetStorageData.token);
  var quotationList = <QuotationData>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    salesOrderListApi();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    update();
    try {
      final response = await _apiService.getRequest(
        ApiConstant.PendingSalesOrder,
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        final orderResponse =
            PendingSaleOrderResponse.fromJson(response.data);
        orderList.value = orderResponse.data ?? [];
      } else if (Get.context != null) {
        Utils().showToast(
          title: "Error",
          message: "Failed to load orders",
          context: Get.context!,
          isSuccess: false,
        );
      }
    } catch (e) {
      if (Get.context != null) {
        Utils().showToast(
          title: "Error",
          message: "$e",
          context: Get.context!,
          isSuccess: false,
        );
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void genaratePDFApi() async {
    final data = await _apiService.getRequest(
      ApiConstant.pendingSalesOrderPDFurl,
      headers: {"Authorization": "Bearer $_token"},
    );

    print('data ---- ${await data}');
    Get.toNamed(AppRoutes.pdfViewScreen, arguments: {
      "html": data,
      "fileName": "Pending_Sales_Order"
    });
  }

  Future<void> salesOrderListApi() async {
    isData = false;
    isLoading.value = true;
    update();

    final ctx = Get.overlayContext ?? Get.context;
    if (ctx != null && ctx.mounted) {
      CommonLoader.show(ctx);
      await Future.delayed(const Duration(milliseconds: 50));
    }

    try {
      String dataRaw = jsonEncode({
        "startDate":
            startDate.isNotEmpty ? startDate : DateTime.now().toIso8601String(),
        "endDate":
            endDate.isNotEmpty ? endDate : DateTime.now().toIso8601String(),
        "invoiceType":
            invoiceController.text.isNotEmpty ? invoiceController.text : "",
        "customerId": 0
      });

      final response = await _apiService.postRequest(
        ApiConstant.saleOrderList,
        data: dataRaw,
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        QuotationListModel model = QuotationListModel.fromJson(response.data);
        isData = true;
        quotationList.clear();
        quotationList.value = model.data ?? [];
      }
    } finally {
      isLoading.value = false;
      CommonLoader.hide();
      update();
    }
  }
}
