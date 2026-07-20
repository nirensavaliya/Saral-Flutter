import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/offer_image_controller.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Common/Global.dart';
import '../../../Constant/App_Images.dart';
import '../Controller/AdminHomeController.dart';

class AdminHomeView extends StatelessWidget {
  AdminHomeView({super.key});

  final AdminHomeController controller = Get.put(AdminHomeController());

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
              border: Border.all(
                color: Colors.deepOrange,
                width: 2,
              ),
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
                    // await GetStorageData.removeData(GetStorageData.loginToken);
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
        title: "Dashboard",
        showDrawer: false,
        showBackButton: false,
        showCartButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Material(
              color: Colors.white.withOpacity(0.18),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  Get.toNamed(AppRoutes.profileScreen);
                },
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
                onTap: () => _showLogoutDialog(),
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
      drawer: SideMenu(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: RefreshIndicator(
        strokeWidth: 2.0,
        color: AppColors.brandRed,
        onRefresh: controller.loadDashboard,
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.todaySales.value == "0.00" &&
              controller.monthlySales.value == "0.00") {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                // _header(),
                const SizedBox(height: 16),
                _metricsShimmer(),
                const SizedBox(height: 20),
                _sectionTitle("Quick Actions"),
                const SizedBox(height: 10),
                _actionsShimmer(),
              ],
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // _header(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      title: "Today's Sales",
                      value: controller.todaySales.value,
                      icon: Icons.trending_up_rounded,
                      accent: AppColors.brandRed,
                      onTap: () => Get.toNamed(
                        AppRoutes.showReportScreen,
                        arguments: AppString.todayTotal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricCard(
                      title: "Monthly Sales",
                      value: controller.monthlySales.value,
                      icon: Icons.calendar_month_rounded,
                      accent: const Color(0xFF3B82F6),
                      onTap: () => Get.toNamed(
                        AppRoutes.showReportScreen,
                        arguments: AppString.monthlyTotal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _metricCard(
                      title: "Today's Purchase",
                      value: controller.todayPurchase.value,
                      icon: Icons.shopping_bag_outlined,
                      accent: const Color(0xFFF59E0B),
                      onTap: () => Get.toNamed(
                        AppRoutes.showReportScreen,
                        arguments: AppString.todayPurchase,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricCard(
                      title: "Monthly Purchase",
                      value: controller.monthlyPurchase.value,
                      icon: Icons.inventory_2_outlined,
                      accent: const Color(0xFF22C55E),
                      onTap: () => Get.toNamed(
                        AppRoutes.showReportScreen,
                        arguments: AppString.monthlyPurchase,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _sectionTitle("Quick Actions"),
              const SizedBox(height: 10),
              _actionTile(
                icon: Icons.pending_actions_outlined,
                title: "Order",
                subtitle: "Review customer orders",
                onTap: () => Get.toNamed(AppRoutes.pendingSaleOrderScreen),
              ),
              // _actionTile(
              //   icon: Icons.receipt_long_outlined,
              //   title: "Sale Order",
              //   subtitle: "Create and manage sale orders",
              //   onTap: () => Get.toNamed(AppRoutes.saleOrderScreen),
              // ),
              GetBuilder(
                builder: (HomeController controller) {
                  return _actionTile(
                    icon: Icons.image_outlined,
                    title: "Change offer image",
                    subtitle: "View current promotional banner",
                    onTap: () async {
                      final result = await Get.toNamed(AppRoutes.offerImageScreen);
                      if (result != null && result is String) {
                        controller.apiOfferImageMessage();
                        controller.update();
                      }
                    },
                  );
                },
              ),
              _actionTile(
                icon: Icons.campaign_outlined,
                title: "Change promotional message",
                subtitle: "Update employee home promo banner text",
                onTap: () => Get.toNamed(AppRoutes.promoMessageScreen),
              ),

              GetBuilder(
                builder: (HomeController controller) {
                  return Obx(() {
                    final offerUrl = controller.offerImage.value.trim();
                    final hasCategory =
                        controller.selectedCategory.value != null;
                    // if (hasCategory) {
                    //   return const SizedBox.shrink();
                    // }
                    if (controller.isOfferImageLoading.value) {
                      return Global.bannerShimmer();
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: offerUrl.isEmpty
                              ? Image.asset(
                            AppImages.Img1,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            offerUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Global.bannerShimmer(withShadow: false);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppImages.Img1,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),

            ],
          );
        }),
      ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: "Dashboard",
                fontFamily: FontFamily.poppinsSemiBold,
                fontSize: 20,
                color: Colors.black87,
              ),
              const SizedBox(height: 2),
              CommonText(
                text: controller.todayLabel,
                fontFamily: FontFamily.poppinsMedium,
                fontSize: 13,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.brandRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.dashboard_customize_outlined,
            color: AppColors.brandRed,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return CommonText(
      text: title,
      fontFamily: FontFamily.poppinsSemiBold,
      fontSize: 16,
      color: Colors.black87,
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 18, color: accent),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CommonText(
                text: title,
                fontFamily: FontFamily.poppinsMedium,
                fontSize: 12,
                color: Colors.black54,
              ),
              const SizedBox(height: 6),
              CommonText(
                text: "₹ $value",
                fontFamily: FontFamily.poppinsBold,
                fontSize: 16,
                color: Colors.black87,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.brandRed, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: title,
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 14,
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

  Widget _metricsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _shimmerBox(height: 110)),
              const SizedBox(width: 12),
              Expanded(child: _shimmerBox(height: 110)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _shimmerBox(height: 110)),
              const SizedBox(width: 12),
              Expanded(child: _shimmerBox(height: 110)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          _shimmerBox(height: 72),
          const SizedBox(height: 10),
          _shimmerBox(height: 72),
          const SizedBox(height: 10),
          _shimmerBox(height: 72),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
