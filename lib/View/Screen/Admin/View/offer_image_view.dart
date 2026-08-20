import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';

import '../Controller/offer_image_controller.dart';

class OfferImageView extends GetView<OfferImageController> {
  const OfferImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferImageController>(
      init: OfferImageController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: "Home Banner",
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
            child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: "Upload Banner",
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                const Gap(6),
                CommonText(
                  text: "Choose an image from camera or gallery",
                  fontFamily: FontFamily.poppinsRegular,
                  fontSize: 13,
                  color: Colors.grey,
                ),
                const Gap(16),
                Obx(
                  () => Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: controller.selectedImage.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.brandRed.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 36,
                                  color: AppColors.brandRed,
                                ),
                              ),
                              const Gap(12),
                              CommonText(
                                text: "No Image Selected",
                                fontFamily: FontFamily.poppinsSemiBold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              const Gap(4),
                              CommonText(
                                text: "Preview will appear here",
                                fontFamily: FontFamily.poppinsRegular,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ],
                          )
                        : Image.file(
                            controller.selectedImage.value!,
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                const Gap(18),
                Obx(() {
                  final pickingCamera = controller.isPickingCamera.value;
                  final pickingGallery = controller.isPickingGallery.value;
                  return Row(
                    children: [
                      Expanded(
                        child: _pickerButton(
                          icon: Icons.photo_camera_outlined,
                          label: "Camera",
                          isLoading: pickingCamera,
                          enabled: !pickingCamera && !pickingGallery,
                          onTap: controller.pickImageFromCamera,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _pickerButton(
                          icon: Icons.photo_library_outlined,
                          label: "Gallery",
                          isLoading: pickingGallery,
                          enabled: !pickingCamera && !pickingGallery,
                          onTap: controller.pickImageFromGallery,
                        ),
                      ),
                    ],
                  );
                }),
                const Gap(24),
                CommonButton(
                  btnName: "Save",
                  onTap: () {
                    controller.saveData();
                  },
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }

  Widget _pickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled && !isLoading ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.brandRed.withOpacity(0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.brandRed,
                          ),
                        )
                      : Icon(icon, color: AppColors.brandRed, size: 22),
                ),
                const Gap(8),
                CommonText(
                  text: isLoading ? "Opening..." : label,
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
