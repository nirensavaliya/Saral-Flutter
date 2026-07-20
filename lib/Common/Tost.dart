import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:toastification/toastification.dart';

class Utils{


  noDataFound(BuildContext context,bool isShow) {
    return Center(
      child: Text(
        isShow == true ? "No Data Found" : "",
        style: TextStyle(
          color: Colors.grey.withOpacity(0.6),
          fontFamily: FontFamily.poppinsMedium,
          fontSize: 16,
        ),
      ),
    );
  }
  void showToast({
    required BuildContext context,
    required String title,
    required String message,
    bool isSuccess = true,
  }) {
    // Clear any toast that is mid-dismiss so Dismissible is not left in the tree
    // (common when toast + Get.back / route pop happen together).
    toastification.dismissAll(delayForAnimation: false);

    toastification.show(
      // Do not pass page context — ToastificationWrapper in main.dart owns the overlay.
      // Passing a route context that gets popped causes:
      // "A dismissed Dismissible widget is still part of the tree."
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: FontFamily.poppinsBold,
        ),
      ),

      description: Text(
        message,
        style: TextStyle(
          color: Colors.black,
          fontFamily: FontFamily.poppinsBold,
        ),
      ),

      type: isSuccess
          ? ToastificationType.success
          : ToastificationType.error,

      style: ToastificationStyle.flatColored,

      autoCloseDuration: const Duration(seconds: 3),

      icon: Icon(
        isSuccess
            ? Icons.check_circle_outline
            : Icons.error_outline,
        color: Colors.black,
      ),

      showIcon: true,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: false,
      dismissDirection: DismissDirection.none,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
