import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/team_member_controller.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class TeamMemberFormView extends GetView<TeamMemberController> {
  const TeamMemberFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: controller.isEdit ? "Edit Team Member" : "Add Team Member",
        showDrawer: false,
        showBackButton: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                text: "Photo",
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
              const Gap(12),
              Obx(() {
                final file = controller.selectedImage.value;
                final existing = controller.existingImage.value;
                return Container(
                  width: double.infinity,
                  height: 220,
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
                  child: file != null
                      ? Image.file(file, fit: BoxFit.contain)
                      : _existingPhoto(existing),
                );
              }),
              const Gap(14),
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: _pickerButton(
                        icon: Icons.photo_camera_outlined,
                        label: "Camera",
                        isLoading: controller.isPickingCamera.value,
                        onTap: controller.pickImageFromCamera,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _pickerButton(
                        icon: Icons.photo_library_outlined,
                        label: "Gallery",
                        isLoading: controller.isPickingGallery.value,
                        onTap: controller.pickImageFromGallery,
                      ),
                    ),
                  ],
                );
              }),
              const Gap(18),
              CommonTextField(
                controller: controller.nameController,
                title: "Name",
                isTitle: true,
                hintText: "Enter name",
                borderRadius: 12,
              ),
              const Gap(14),
              CommonTextField(
                controller: controller.descriptionController,
                title: "Description",
                isTitle: true,
                hintText: "Enter description",
                maxLine: 4,
                borderRadius: 12,
              ),
              const Gap(24),
              Obx(
                () => CommonButton(
                  btnName: controller.isEdit ? "Update" : "Save",
                  isLoading: controller.isSaving.value,
                  onTap: controller.saveMember,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _existingPhoto(String existing) {
    if (existing.trim().isEmpty) {
      return const Center(child: CatalogImagePlaceholder(showLabel: true));
    }
    if (existing.startsWith('http')) {
      return Image.network(
        existing,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const CatalogImagePlaceholder(showLabel: false),
      );
    }
    try {
      final raw = existing.contains(',') ? existing.split(',').last : existing;
      return Image.memory(
        base64Decode(raw),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const CatalogImagePlaceholder(showLabel: false),
      );
    } catch (_) {
      return const Center(child: CatalogImagePlaceholder(showLabel: true));
    }
  }

  Widget _pickerButton({
    required IconData icon,
    required String label,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.brandRed,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: AppColors.brandRed, size: 18),
                    const SizedBox(width: 6),
                    CommonText(
                      text: label,
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
