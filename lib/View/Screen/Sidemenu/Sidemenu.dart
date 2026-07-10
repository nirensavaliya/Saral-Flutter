import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_Text.dart';

// import your controllers, routes, constants and font files
// import '../Controller/dashboard_controller.dart';
// import '../Controller/account_controller.dart';
// import '../Controller/auth_controller.dart';
// import '../Routes/app_routes.dart';
// import '../Utils/color_constants.dart';
// import '../Utils/font_family.dart';

class SideMenu extends StatelessWidget {
  SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xfff7f9fb),
      width: MediaQuery.of(context).size.width * 0.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
           UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.btnColors,
                ),
                currentAccountPicture: GestureDetector(
                  onTap: () {

                  },
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                  )
                ), accountName: null, accountEmail: null,
              ),

            ListTile(
              leading: const Icon(Icons.pedal_bike_sharp),
              title: CommonText(text:"Track Order",fontFamily: FontFamily.poppinsMedium,),
              onTap: () {
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: CommonText(text: "Pending Order",fontFamily: FontFamily.poppinsMedium),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: CommonText(text:"My Cart",fontFamily: FontFamily.poppinsMedium),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.addToCartScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: CommonText(text:"Contact Us",fontFamily: FontFamily.poppinsMedium),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.contactUsScreen);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: CommonText(text:"Sale Order",fontFamily: FontFamily.poppinsMedium),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.saleOrderScreen);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.btnColors,
              ),
              title: CommonText(text: "Logout",fontFamily: FontFamily.poppinsMedium,),
                onTap: () {
                  Get.back();
                  Get.defaultDialog(
                    title: "",
                    radius: 20,
                    backgroundColor: Colors.white,
                    titlePadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                          child: Center(
                            child: Icon(
                              Icons.priority_high,
                              color: Colors.deepOrange,
                              size: 35,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Confirm Logout",
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: FontFamily.poppinsBold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Are you sure you want to log out of your account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: FontFamily.poppinsRegular,
                          ),
                        ),
                        SizedBox(height: 30),
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
                                onPressed: () {
                                  Get.back();
                                },
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
                                  backgroundColor: AppColors.btnColors,
                                  elevation: 4,
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.back();
                                  Get.back();
                                  await GetStorageHelper.removeData(GetStorageHelper.token);
                                  await GetStorageHelper.removeData(GetStorageHelper.loginToken);
                                  await GetStorageHelper.removeData(GetStorageHelper.role);
                                  await GetStorageHelper.removeData(GetStorageHelper.isOtpVerified);
                                  await GetStorageHelper.saveBoolean(GetStorageHelper.isAdmin, false);
                                  await GetStorageHelper.saveBoolean(GetStorageHelper.isCustomer, false);
                                  await GetStorageHelper.saveBoolean(GetStorageHelper.isEmployee, false);
                                  Get.offAllNamed(AppRoutes.loginScreen);
                                },
                                child: Text(
                                  "Yes, Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FontFamily.poppinsSemiBold,
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
            ),
          ],
        ),
      ),
    );
  }
}