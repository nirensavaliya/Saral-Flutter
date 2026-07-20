import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Login/Model/is_admin_model.dart';
import 'package:saral/View/Screen/Sales Employee/Controller/employee_home_controller.dart';
import 'package:saral/View/Screen/Sales Employee/Model/promo_message_model.dart';

class PromoMessageController extends GetxController {
  final ApiService _apiService = ApiService();
  final TextEditingController addPromoController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  String get companyToken =>
      GetStorageData.readString(GetStorageData.token) ?? '';

  @override
  void onInit() {
    super.onInit();
    apiPromotionalMessage();
  }

  @override
  void onClose() {
    addPromoController.dispose();
    super.onClose();
  }

  Future<void> apiPromotionalMessage() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getRequest(
        ApiConstant.getPromotionalMessage,
        headers: {"Authorization": "Bearer $companyToken"},
      );

      if (response.statusCode == 200) {
        final model = PromotionalMessageModel.fromJson(response.data);
        final msg = model.data?.message?.trim();
        if (msg != null && msg.isNotEmpty) {
          ApiConstant.promoMessageModel = PromotionalMessageData(message: msg);
          addPromoController.text = msg;
          if (Get.isRegistered<EmployeeHomeController>()) {
            Get.find<EmployeeHomeController>().updatePromoMessage(msg);
          }
        } else {
          ApiConstant.promoMessageModel = PromotionalMessageData(
            message: 'No promotional message available.',
          );
          addPromoController.clear();
        }
      }
      update();
    } catch (_) {
      ApiConstant.promoMessageModel = PromotionalMessageData(
        message: 'Failed to load promotional message.',
      );
      update();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> apiSavePromotionalMessage(BuildContext context) async {
    final message = addPromoController.text.trim();
    if (message.isEmpty) {
      Utils().showToast(
        context: context,
        title: 'Error',
        message: 'Please enter a promo message',
        isSuccess: false,
      );
      return;
    }

    try {
      isSaving.value = true;
      CommonLoader.show(context);

      final response = await _apiService.postRequest(
        ApiConstant.SavePromoMessage,
        data: json.encode({"message": message}),
        headers: {"Authorization": "Bearer $companyToken"},
      );

      if (response.statusCode == 200) {
        IsAdminModel.fromJson(response.data);
        ApiConstant.promoMessageModel =
            PromotionalMessageData(message: message);
        if (Get.isRegistered<EmployeeHomeController>()) {
          Get.find<EmployeeHomeController>().updatePromoMessage(message);
        }
        Utils().showToast(
          context: context,
          title: 'Success',
          message: 'Promo message saved successfully!',
          isSuccess: true,
        );
        Get.back(result: message);
      } else {
        Utils().showToast(
          context: context,
          title: 'Error',
          message: 'Unable to save promo message',
          isSuccess: false,
        );
      }
    } catch (e) {
      Utils().showToast(
        context: context,
        title: 'Error',
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isSaving.value = false;
      CommonLoader.hide();
    }
  }
}
