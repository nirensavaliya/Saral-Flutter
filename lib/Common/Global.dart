import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../View/Constant/App_Colors.dart';
import '../View/Constant/App_font.dart';
import '../View/Utils/App_Routes.dart';
import 'Get_Storage.dart';

class Global {
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Appends [customerId] as a query parameter to API paths.
  static String withCustomerId(String path, int customerId) {
  final sep = path.contains('?') ? '&' : '?';
  return '$path${sep}customerId=$customerId';
  }

  Future<void> requestStoragePermission() async {
    if (!Platform.isAndroid) return;

    if (await Permission.storage.isGranted) return;

    final status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  static bannerShimmer({bool withShadow = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: withShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 180,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static showLoginRequiredDialog() {
    Get.defaultDialog(
      title: "",
      radius: 20,
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.brandRed,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.brandRed,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Login Required",
            style: TextStyle(
              fontSize: 22,
              fontFamily: FontFamily.poppinsBold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Please login to continue.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontFamily: FontFamily.poppinsRegular,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.poppinsMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandRed,
                    elevation: 4,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.toNamed(AppRoutes.loginScreen);
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Login Now",
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

bool get isLoggedIn {
  final token = GetStorageData.readString(GetStorageData.token);
  final otp = GetStorageData.readString(GetStorageData.isOtpVerified);
  return token is String && token.isNotEmpty && otp == "true";
}