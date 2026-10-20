import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Model/team_member_model.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class CustomerTeamMembersView extends GetView<HomeController> {
  const CustomerTeamMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "About Us",
        showDrawer: false,
        showBackButton: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Obx(() {
          if (controller.isTeamMembersLoading.value &&
              controller.teamMembers.isEmpty) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/app_loader.json',
                width: 145,
                height: 145,
                fit: BoxFit.contain,
                repeat: true,
              ),
            );
          }
          final members = controller.teamMembers;
          if (members.isEmpty) {
            return Center(
              child: CommonText(
                text: "No team members found",
                fontFamily: FontFamily.poppinsMedium,
                color: Colors.grey,
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            itemCount: members.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final member = members[index];
              return Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.brandRed,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: _photo(member.displayImage),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.name ?? "--",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _photo(String? image) {
    const placeholder = CatalogImagePlaceholder(
      width: 72,
      height: 72,
      showLabel: false,
    );
    if (image == null || image.trim().isEmpty) return placeholder;
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    try {
      final raw = image.contains(',') ? image.split(',').last : image;
      return Image.memory(
        base64Decode(raw),
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } catch (_) {
      return placeholder;
    }
  }
}
