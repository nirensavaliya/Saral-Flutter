import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class AdminReportView extends StatelessWidget {
  const AdminReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Report",
        showDrawer: false,
        showBackButton: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          CommonText(
            text: "Select a report to view details",
            fontFamily: FontFamily.poppinsRegular,
            fontSize: 13,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          _ReportTile(
            icon: Icons.inventory_2_outlined,
            title: "Item List",
            subtitle: "View items report",
            onTap: () {
              Get.toNamed(AppRoutes.itemListScreen);
            },
          ),
          _ReportTile(
            icon: Icons.receipt_long_outlined,
            title: "Ledger Statement",
            subtitle: "View ledger statement report",
            onTap: () {
              Get.toNamed(AppRoutes.ledgerStatementScreen);
            },
          ),
          _ReportTile(
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
          _ReportTile(
            icon: Icons.groups_outlined,
            title: "Team Members",
            subtitle: "Add and edit team members",
            onTap: () {
              Get.toNamed(AppRoutes.teamMemberListScreen);
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
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
