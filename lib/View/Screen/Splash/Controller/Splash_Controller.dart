import 'dart:async';

import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Utils/App_Routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() {
    Timer(const Duration(seconds: 3), () {
      String? token = GetStorageHelper.readString(GetStorageHelper.loginToken);
      String? otp = GetStorageHelper.readString(GetStorageHelper.isOtpVerified);

      print("Splash Token : $token");
      if (token != null && otp == "true") {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.offAllNamed(AppRoutes.loginScreen);
      }
    });
  }
}
