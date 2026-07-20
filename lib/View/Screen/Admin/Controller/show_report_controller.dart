import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Screen/Admin/Model/monthly_total_purchase_model.dart';
import 'package:saral/View/Screen/Admin/Model/monthly_total_sale_model.dart';

class ShowReportController extends GetxController {
  final ApiService _apiService = ApiService();

  List<MonthlySaleData> monthlySaleList = [];
  List<MonhtlyPurchaseData> monthlyPurchaseList = [];

  final RxBool isLoading = false.obs;
  String reportType = '';
  bool _isFetching = false;
  bool _initialLoadDone = false;

  String get companyToken =>
      GetStorageData.readString(GetStorageData.token) ?? '';

  bool get isPurchaseReport =>
      reportType == AppString.todayPurchase ||
      reportType == AppString.monthlyPurchase;

  String get reportTitle {
    switch (reportType) {
      case AppString.todayTotal:
        return "Today's Sales";
      case AppString.monthlyTotal:
        return 'Monthly Sales';
      case AppString.todayPurchase:
        return "Today's Purchase";
      case AppString.monthlyPurchase:
        return 'Monthly Purchase';
      default:
        return 'Show Report';
    }
  }

  @override
  void onInit() {
    super.onInit();
    reportType = (Get.arguments ?? '').toString();
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialLoadDone) {
        _initialLoadDone = true;
        _loadByType();
      }
    });
  }

  @override
  void onClose() {
    CommonLoader.hide();
    super.onClose();
  }

  Future<void> refresh() => _loadByType();

  Future<void> _loadByType() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (reportType == AppString.todayTotal) {
        await todaySaleApiCall();
      } else if (reportType == AppString.monthlyTotal) {
        await monthlySaleApiCall();
      } else if (reportType == AppString.todayPurchase) {
        await todayTotalPurchaseApiCall();
      } else {
        await monthlyTotalPurchaseApiCall();
      }
    } finally {
      _isFetching = false;
    }
  }

  Future<void> monthlySaleApiCall() async {
    await _fetchSales(ApiConstant.monthlyTotalSale);
  }

  Future<void> todaySaleApiCall() async {
    await _fetchSales(ApiConstant.todayTotalSale);
  }

  Future<void> todayTotalPurchaseApiCall() async {
    await _fetchPurchases(ApiConstant.todaysTotalpurchase);
  }

  Future<void> monthlyTotalPurchaseApiCall() async {
    await _fetchPurchases(ApiConstant.monthlyTotalpurchase);
  }

  Future<void> _showAppLoader() async {
    final ctx = Get.overlayContext ?? Get.context;
    if (ctx == null || !ctx.mounted) return;
    CommonLoader.show(ctx);
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<void> _fetchSales(String url) async {
    try {
      isLoading.value = true;
      await _showAppLoader();

      final response = await _apiService.getRequest(
        url,
        headers: {"Authorization": "Bearer $companyToken"},
      );

      final model = MonthlyTotalSaleModel.fromJson(response.data);
      if (model.statusCode == 200) {
        monthlySaleList = model.data ?? [];
        monthlyPurchaseList = [];
        update();
      }
    } catch (e) {
      debugPrint('ShowReport sales error: $e');
    } finally {
      isLoading.value = false;
      CommonLoader.hide();
    }
  }

  Future<void> _fetchPurchases(String url) async {
    try {
      isLoading.value = true;
      await _showAppLoader();

      final response = await _apiService.getRequest(
        url,
        headers: {"Authorization": "Bearer $companyToken"},
      );

      final model = MonthlyTotalPurchaseModel.fromJson(response.data);
      if (model.statusCode == 200) {
        monthlyPurchaseList = model.data ?? [];
        monthlySaleList = [];
        update();
      }
    } catch (e) {
      debugPrint('ShowReport purchase error: $e');
    } finally {
      isLoading.value = false;
      CommonLoader.hide();
    }
  }
}
