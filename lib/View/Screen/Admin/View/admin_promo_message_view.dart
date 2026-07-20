import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/promo_message_controller.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class PromoMessageView extends GetView<PromoMessageController> {
  const PromoMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromoMessageController>(
      init: PromoMessageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: "Promo Message",
            showDrawer: false,
            showBackButton: true,
          ),
          body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              clipBehavior: Clip.antiAlias,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.brandRed),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.brandRed
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.campaign_outlined,
                                  color: AppColors.brandRed,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText(
                                      text: "Promotional Message",
                                      fontFamily: FontFamily.poppinsSemiBold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    const SizedBox(height: 2),
                                    CommonText(
                                      text:
                                          "This message shows on Employee home as a banner",
                                      fontFamily: FontFamily.poppinsRegular,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          CommonTextField(
                            borderRadius: 12,
                            controller: controller.addPromoController,
                            isTitle: true,
                            title: "Enter Promo Message",
                            hintText: "Type your promotional message here...",
                            maxLine: 5,
                            textInputType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                          const Gap(24),
                          CommonButton(
                            btnName: "Save Promo Message",
                            onTap: controller.isSaving.value
                                ? null
                                : () => controller
                                    .apiSavePromotionalMessage(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
