import 'dart:async';

import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Utils/App_Routes.dart';

import '../../Login/Controller/Company_Controller.dart';

class SplashController extends GetxController {
  final CompanyController companyCodeController =
  Get.isRegistered<CompanyController>()
      ? Get.find<CompanyController>()
      : Get.put(CompanyController());

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() {
    Timer(const Duration(seconds: 3), () async {
      final rawToken = GetStorageData.readString(GetStorageData.token);
      final String token = rawToken is String ? rawToken : '';

      final rawOtp = GetStorageData.readString(GetStorageData.isOtpVerified);
      final String? otp = rawOtp is String ? rawOtp : null;

      final bool isAdmin =
          GetStorageData.readBoolean(GetStorageData.isAdmin);
      final bool isEmployee =
          GetStorageData.readBoolean(GetStorageData.isEmployee);

      print(
          "Splash Token : $token | isAdmin : $isAdmin | isEmployee : $isEmployee");

      if (token != null && token.isNotEmpty && otp == "true") {
        if (isEmployee && !isAdmin) {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        } else {
          // Admin / Customer: Dashboard with bottom bar
          Get.offAllNamed(AppRoutes.dashboardScreen);
        }
      } else {
        await companyCodeController.autoLogin(Get.context!);

        await GetStorageData.saveBoolean(GetStorageData.isAdmin, false);
        await GetStorageData.saveBoolean(GetStorageData.isEmployee, false);
        await GetStorageData.saveBoolean(GetStorageData.isCustomer, true); // guest
        Get.offAllNamed(AppRoutes.dashboardScreen);
        // Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }
}
