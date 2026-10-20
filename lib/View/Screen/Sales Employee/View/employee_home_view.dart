import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Sales Employee/Controller/employee_home_controller.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

import '../../../../Common/Tost.dart';

class EmployeeHomeView extends StatelessWidget {
  EmployeeHomeView({super.key});

  final EmployeeHomeController controller =
      Get.put(EmployeeHomeController());

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "",
      radius: 20,
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepOrange, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.priority_high,
                color: Colors.deepOrange,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Confirm Logout",
            style: TextStyle(
              fontSize: 22,
              fontFamily: FontFamily.poppinsBold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Are you sure you want to log out of your account?",
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
                  onPressed: () async {
                    Get.back();
                    await GetStorageData.removeData(GetStorageData.token);
                    await GetStorageData.removeData(GetStorageData.token);
                    await GetStorageData.removeData(GetStorageData.role);
                    await GetStorageData.removeData(
                        GetStorageData.isOtpVerified);
                    await GetStorageData.saveBoolean(
                        GetStorageData.isAdmin, false);
                    await GetStorageData.saveBoolean(
                        GetStorageData.isCustomer, false);
                    await GetStorageData.saveBoolean(
                        GetStorageData.isEmployee, false);
                    Get.offAllNamed(AppRoutes.loginScreen);
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Yes, Logout",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Home",
        showDrawer: false,
        showBackButton: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Material(
              color: Colors.white.withOpacity(0.18),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Get.toNamed(AppRoutes.profileScreen),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.white.withOpacity(0.18),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _showLogoutDialog,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: RefreshIndicator(
        color: AppColors.brandRed,
        onRefresh: controller.fetchPromotionalMessage,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Obx(() {
              if (controller.isPromoLoading.value) {
                return Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }
              if (!controller.hasPromo) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.deepOrange.shade400,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_offer_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 26,
                          child: Marquee(
                            text: controller.promoMessage.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: FontFamily.poppinsSemiBold,
                            ),
                            scrollAxis: Axis.horizontal,
                            blankSpace: 50,
                            velocity: 30,
                            pauseAfterRound: const Duration(seconds: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            CommonText(
              text: "Quick Access",
              fontFamily: FontFamily.poppinsSemiBold,
              fontSize: 16,
              color: Colors.black87,
            ),
            const SizedBox(height: 4),
            CommonText(
              text: "Select a module to continue",
              fontFamily: FontFamily.poppinsRegular,
              fontSize: 13,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            _EmployeeTile(
              icon: Icons.shopping_bag_outlined,
              title: "Product",
              subtitle: "Browse products by category",
              onTap: () => Get.toNamed(AppRoutes.adminProductListScreen),
            ),
            _EmployeeTile(
              icon: Icons.pending_actions_outlined,
              title: "Pending Sale Order",
              subtitle: "View and manage pending orders",
              onTap: () => Get.toNamed(AppRoutes.pendingSaleOrderScreen),
            ),
            _EmployeeTile(
              icon: Icons.inventory_2_outlined,
              title: "Item List",
              subtitle: "Browse items by category & brand",
              onTap: () => Get.toNamed(AppRoutes.itemListScreen),
            ),
            _EmployeeTile(
              icon: Icons.receipt_long_outlined,
              title: "Ledger Statement",
              subtitle: "View ledger statement report",
              onTap: () => Get.toNamed(AppRoutes.ledgerStatementScreen),
            ),
            _EmployeeTile(
              icon: Icons.payments_outlined,
              title: "Payment Wise Statement",
              subtitle: "View payment wise statement report",
              onTap: () {
                Utils().showToast(
                  context: context,
                  title: "Info",
                  message: "Payment Wise Statement coming soon",
                  isSuccess: true,
                );
              },
            ),
            _EmployeeTile(
              icon: Icons.groups_outlined,
              title: "Team Members",
              subtitle: "Add and edit team members",
              onTap: () => Get.toNamed(AppRoutes.teamMemberListScreen),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.brandRed, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: title,
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        text: subtitle,
                        fontFamily: FontFamily.poppinsRegular,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
