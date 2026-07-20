import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Sale Order/Model/dashboardModel.dart';

class AdminHomeController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString todaySales = "0.00".obs;
  final RxString monthlySales = "0.00".obs;
  final RxString todayPurchase = "0.00".obs;
  final RxString monthlyPurchase = "0.00".obs;

  String get todayLabel =>
      DateFormat("dd MMM yyyy").format(DateTime.now());

  String get companyToken =>
      GetStorageData.readString(GetStorageData.token) ?? "";

  @override
  void onReady() {
    super.onReady();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadDashboardElements(),
        // _loadTodaySales(),
        // _loadMonthlySales(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDashboardElements() async {
    try {
      final response = await _apiService.getRequest(
        ApiConstant.dashboardElements,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      if (response.statusCode != 200) return;

      final model = DashboardModel.fromJson(response.data);
      final list = model.data ?? [];

      for (final item in list) {
        final title = (item.elementTitle ?? "").toLowerCase();
        final value = _formatAmount(item.value);

        if (title.contains("today") && title.contains("sale")) {
          todaySales.value = value;
        } else if (title.contains("month") && title.contains("sale")) {
          monthlySales.value = value;
        } else if (title.contains("today") && title.contains("purchase")) {
          todayPurchase.value = value;
        } else if (title.contains("month") && title.contains("purchase")) {
          monthlyPurchase.value = value;
        }
      }
    } catch (e) {
      debugPrint("Admin dashboardElements error: $e");
    }
  }

  Future<void> _loadTodaySales() async {
    try {
      final response = await _apiService.getRequest(
        ApiConstant.todayTotalSale,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      if (response.statusCode != 200) return;
      final data = response.data["data"];
      if (data != null) {
        todaySales.value = data.toString();
      }
    } catch (e) {
      debugPrint("Admin today sales error: $e");
    }
  }

  Future<void> _loadMonthlySales() async {
    try {
      final response = await _apiService.getRequest(
        ApiConstant.monthlyTotalSale,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      if (response.statusCode != 200) return;
      final data = response.data["data"];
      if (data != null) {
        monthlySales.value = data.toString();
      }
    } catch (e) {
      debugPrint("Admin monthly sales error: $e");
    }
  }

  String _formatAmount(dynamic raw) {
    if (raw == null) return "0.00";
    final parsed = double.tryParse(raw.toString().replaceAll(",", ""));
    if (parsed == null) return raw.toString();
    return parsed.toStringAsFixed(2);
  }
}
