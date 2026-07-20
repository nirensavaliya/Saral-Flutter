import 'dart:developer';

import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Sales Employee/Model/promo_message_model.dart';

class EmployeeHomeController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isPromoLoading = false.obs;
  final RxString promoMessage = ''.obs;

  static const String _noPromo = 'No promotional message available.';

  bool get hasPromo {
    final msg = promoMessage.value.trim();
    return msg.isNotEmpty && msg != _noPromo;
  }

  @override
  void onReady() {
    super.onReady();
    fetchPromotionalMessage();
  }

  void updatePromoMessage(String message) {
    promoMessage.value = message;
  }
  Future<void> fetchPromotionalMessage() async {
    isPromoLoading.value = true;
    try {
      final token =
          GetStorageData.readString(GetStorageData.token) ?? '';
      final response = await _apiService.getRequest(
        ApiConstant.getPromotionalMessage,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final model = PromotionalMessageModel.fromJson(response.data);
        final msg = model.data?.message?.trim();
        if (msg != null && msg.isNotEmpty) {
          promoMessage.value = msg;
          ApiConstant.promoMessageModel =
              PromotionalMessageData(message: msg);
        } else {
          promoMessage.value = _noPromo;
          ApiConstant.promoMessageModel =
              PromotionalMessageData(message: _noPromo);
        }
      } else {
        promoMessage.value = _noPromo;
      }
    } catch (e) {
      log('Employee promo message error: $e');
      promoMessage.value = _noPromo;
    } finally {
      isPromoLoading.value = false;
    }
  }
}
