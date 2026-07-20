import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Profile/controller/ProfileController.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_textfild.dart';

import '../../../Utils/App_Routes.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return GetBuilder<ProfileController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: "Profile",
            showDrawer: false,
            showBackButton: Navigator.canPop(context) ||
                profileController.isAdmin ||
                profileController.isEmployee,
            actions: [
              if (profileController.isCustomer)
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmation(context, profileController);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24,
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
            child: Obx(() {
            if (profileController.isLoading.value &&
                !profileController.hasProfileData) {
              return const SizedBox.shrink();
            }

            if (!profileController.hasProfileData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      text: "No profile data found",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          profileController.loadProfile(force: true),
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          color: AppColors.brandRed,
                          fontFamily: FontFamily.poppinsSemiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                child: Form(
                  key: profileController.profileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!profileController.isCustomer) ...[
                        CommonText(
                          text: profileController.isAdmin
                              ? "Admin Account"
                              : "Employee Account",
                          fontFamily: FontFamily.poppinsSemiBold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 8),
                      CommonTextField(
                        isTitle: true,
                        title: "Name",
                        textCapitalization: TextCapitalization.words,
                        textInputType: TextInputType.text,
                        prefix: const Icon(Icons.person),
                        readOnly: true,
                        showCursor: false,
                        hintText: "Name",
                        textInputAction: TextInputAction.next,
                        controller: profileController.nameController,
                      ),
                      const SizedBox(height: 15),
                      CommonTextField(
                        isTitle: true,
                        title:
                            profileController.isCustomer ? "Email" : "Role",
                        textCapitalization: TextCapitalization.words,
                        textInputType: TextInputType.text,
                        prefix: Icon(
                          profileController.isCustomer
                              ? Icons.email
                              : Icons.badge_outlined,
                        ),
                        readOnly: true,
                        showCursor: false,
                        hintText: profileController.isCustomer
                            ? "Email"
                            : "Role",
                        textInputAction: TextInputAction.next,
                        controller: profileController.emailController,
                      ),
                      const SizedBox(height: 15),
                      CommonTextField(
                        isTitle: true,
                        title: "Number",
                        readOnly: true,
                        showCursor: false,
                        textCapitalization: TextCapitalization.words,
                        textInputType: TextInputType.text,
                        prefix: const Icon(Icons.call),
                        hintText: "Number",
                        textInputAction: TextInputAction.next,
                        controller: profileController.contactController,
                      ),
                      const SizedBox(height: 15),
                      if (profileController.isCustomer) ...[
                        CommonTextField(
                          isTitle: true,
                          title: "Address",
                          readOnly: true,
                          showCursor: false,
                          prefix: const Icon(Icons.location_on_outlined),
                          hintText: "Address",
                          controller: profileController.addressController,
                        ),
                        const SizedBox(height: 15),
                        CommonTextField(
                          isTitle: true,
                          title: "Area",
                          readOnly: true,
                          showCursor: false,
                          prefix: const Icon(Icons.map_outlined),
                          hintText: "Area",
                          controller: profileController.areaController,
                        ),
                        const SizedBox(height: 15),
                        CommonTextField(
                          isTitle: true,
                          title: "State",
                          readOnly: true,
                          showCursor: false,
                          prefix: const Icon(Icons.flag_outlined),
                          hintText: "State",
                          controller: profileController.stateController,
                        ),
                        const SizedBox(height: 15),
                        CommonTextField(
                          isTitle: true,
                          title: "Zipcode",
                          readOnly: true,
                          showCursor: false,
                          prefix: const Icon(Icons.pin_drop_outlined),
                          hintText: "Zipcode",
                          controller: profileController.zipcodeController,
                        ),
                      ],
                      const SizedBox(height: 15),
                      // ListTile(
                      //   leading: const Icon(Icons.contact_page),
                      //   title: CommonText(text:"Contact Us",fontFamily: FontFamily.poppinsMedium),
                      //   onTap: () {
                      //     Get.toNamed(AppRoutes.contactUsScreen);
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ProfileController controller,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Account Request',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: FontFamily.poppinsBold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(
              fontFamily: FontFamily.poppinsLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onPressed: () async {
                await controller.apiCallDeleteCustomer(context: context);
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
