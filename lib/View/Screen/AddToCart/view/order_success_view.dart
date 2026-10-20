import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({super.key});

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cardController;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardFade;

  Map<String, dynamic> get _args {
    final raw = Get.arguments;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    _cardFade = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOut,
    );
    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _continue() {
    final isAdmin = GetStorageData.readBoolean(GetStorageData.isAdmin);
    final isEmployee = GetStorageData.readBoolean(GetStorageData.isEmployee);
    if (isEmployee && !isAdmin) {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    } else {
      Get.offAllNamed(AppRoutes.dashboardScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderNo = _args['orderNo']?.toString() ?? '--';
    final netTotal = _args['netTotal']?.toString() ?? '0.00';
    final totalItem = _args['totalItem']?.toString() ?? '0';
    final customerName = _args['customerName']?.toString() ?? '--';
    final date = _args['date'] is DateTime
        ? _args['date'] as DateTime
        : DateTime.now();
    final dateLabel = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: SlideTransition(
                      position: _cardSlide,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(22, 28, 22, 22),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 24,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.brandRed
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.receipt_long_rounded,
                                            color: AppColors.brandRed,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonText(
                                                text: "Order Confirmed",
                                                fontFamily:
                                                    FontFamily.poppinsBold,
                                                fontSize: 20,
                                                color: Colors.black87,
                                              ),
                                              const SizedBox(height: 2),
                                              CommonText(
                                                text: dateLabel,
                                                fontFamily:
                                                    FontFamily.poppinsRegular,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF8F8F8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: CommonText(
                                        text:
                                            "Thank you. Your sale order has been placed successfully.",
                                        fontFamily: FontFamily.poppinsRegular,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    _dashedDivider(),
                                    const SizedBox(height: 14),
                                    _row("Order No.", "#$orderNo"),
                                    _row("Customer", customerName),
                                    _row("Items", totalItem),
                                    const SizedBox(height: 8),
                                    _dashedDivider(),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        CommonText(
                                          text: "Net Total",
                                          fontFamily:
                                              FontFamily.poppinsSemiBold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        const Spacer(),
                                        CommonText(
                                          text: "₹ $netTotal",
                                          fontFamily: FontFamily.poppinsBold,
                                          fontSize: 18,
                                          color: AppColors.brandRed,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -12,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandRed,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.brandRed
                                            .withOpacity(0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "CONFIRMED",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: FontFamily.poppinsBold,
                                      fontSize: 11,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              CommonButton(
                btnName: "Continue Shopping",
                onTap: _continue,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          Flexible(
            child: CommonText(
              text: value,
              fontFamily: FontFamily.poppinsSemiBold,
              fontSize: 13,
              color: Colors.black87,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final count =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1.2,
              margin: const EdgeInsets.only(right: dashSpace),
              color: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}
