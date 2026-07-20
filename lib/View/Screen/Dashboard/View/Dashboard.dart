import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Screen/Admin/View/admin_home_view.dart';
import 'package:saral/View/Screen/Admin/View/admin_product_view.dart';
import 'package:saral/View/Screen/Admin/View/admin_report_view.dart';
import 'package:saral/View/Screen/ContactUs/view/ContactUs.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/Pending%20Sale%20Order/View/pending_sale_order_view.dart';
import 'package:saral/View/Screen/Profile/view/ProfileScreen.dart';
import 'package:saral/View/Widget/Bottombar.dart';

import '../../Pending Sale Order/Controller/pedning_sale_order_controller.dart';
import '../../Profile/controller/ProfileController.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key}) {
    Get.put(HomeController());
    if (GetStorageData.readBoolean(GetStorageData.isCustomer) ||
        !GetStorageData.readBoolean(GetStorageData.isAdmin)) {
      if (Get.isRegistered<PendingSaleOrderController>()) {
        Get.delete<PendingSaleOrderController>(force: true);
      }
      Get.put(PendingSaleOrderController());
    }
    if (GetStorageData.readBoolean(GetStorageData.isCustomer)) {
      Get.put(ProfileController());
    }
  }

  HomeController get dashboardController => Get.find<HomeController>();

  final bool isAdmin = GetStorageData.readBoolean(GetStorageData.isAdmin);

  List<Widget> get screens => [
        isAdmin ? AdminHomeView() : HomeView(),
        isAdmin ? AdminProductView() : PendingSaleOrderView(),
        Contactus(showBackButton: false),
        isAdmin ? const AdminReportView() : ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: screens[dashboardController.selectedIndex.value],
          bottomNavigationBar: CustomBottomBar(
            currentIndex: dashboardController.selectedIndex.value,
            onTap: dashboardController.changeTab,
            isAdmin: isAdmin,
          ),
        ));
  }
}
