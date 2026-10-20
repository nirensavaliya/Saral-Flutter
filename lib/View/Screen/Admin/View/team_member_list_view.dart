import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/team_member_controller.dart';
import 'package:saral/View/Screen/Admin/Model/team_member_model.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class TeamMemberListView extends GetView<TeamMemberController> {
  const TeamMemberListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Team Members",
        showDrawer: false,
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.brandRed,
        onPressed: () async {
          controller.prepareForm();
          await Get.toNamed(AppRoutes.teamMemberFormScreen);
        },
        icon: const Icon(Icons.group_add, color: Colors.white),
        label: CommonText(
          text: "Add",
          fontFamily: FontFamily.poppinsSemiBold,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Obx(() {
          if (controller.isLoading.value && controller.members.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.brandRed,
                size: 50,
              ),
            );
          }
          if (controller.members.isEmpty) {
            return Center(
              child: CommonText(
                text: "No team members found",
                fontFamily: FontFamily.poppinsMedium,
                color: Colors.grey,
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.brandRed,
            onRefresh: controller.fetchMembers,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: controller.members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _MemberCard(
                  member: controller.members[index],
                  onEdit: () async {
                    controller.prepareForm(member: controller.members[index]);
                    await Get.toNamed(AppRoutes.teamMemberFormScreen);
                  },
                  onDelete: () => _confirmDelete(controller.members[index]),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _confirmDelete(TeamMemberData member) {
    Get.defaultDialog(
      title: "Delete Member",
      titleStyle: TextStyle(
        fontFamily: FontFamily.poppinsSemiBold,
        fontSize: 18,
      ),
      radius: 16,
      content: CommonText(
        text: "Remove ${member.name ?? 'this member'}?",
        fontFamily: FontFamily.poppinsRegular,
        fontSize: 14,
        color: Colors.grey.shade700,
        textAlign: TextAlign.center,
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandRed),
        onPressed: () {
          Get.back();
          controller.deleteMember(member);
        },
        child: const Text("Delete", style: TextStyle(color: Colors.white)),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  final TeamMemberData member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final image = member.displayImage;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            spreadRadius: 0.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 64,
                height: 64,
                child: _memberPhoto(image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: member.name ?? "--",
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 15,
                    color: Colors.black87,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  CommonText(
                    text: (member.description ?? "").trim().isEmpty
                        ? "--"
                        : member.description!,
                    fontFamily: FontFamily.poppinsRegular,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _roundAction(
                  icon: Icons.edit_outlined,
                  onTap: onEdit,
                ),
                const SizedBox(height: 8),
                _roundAction(
                  icon: Icons.delete_outline,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.brandRed.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.brandRed, size: 18),
        ),
      ),
    );
  }

  Widget _memberPhoto(String? image) {
    const placeholder = CatalogImagePlaceholder(
      width: 64,
      height: 64,
      showLabel: false,
    );
    if (image == null || image.trim().isEmpty) return placeholder;
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    try {
      final raw = image.contains(',') ? image.split(',').last : image;
      return Image.memory(
        base64Decode(raw),
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } catch (_) {
      return placeholder;
    }
  }
}
