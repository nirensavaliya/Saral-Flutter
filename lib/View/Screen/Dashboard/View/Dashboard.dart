import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Screen/AddToCart/view/AddToCart.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/Product/view/ProductScreen.dart';
import 'package:saral/View/Screen/ProductDetail/view/productDetailView.dart';
import 'package:saral/View/Screen/Profile/view/ProfileScreen.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Widget/Bottombar.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  HomeController dashboardController=Get.put(HomeController());
  List<Widget> screens = [
    Home(),
    ProductScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      extendBody: true,
      body: screens[dashboardController.selectedIndex.value],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: dashboardController.selectedIndex.value,
        onTap: dashboardController.changeTab,
      ),
     )
    );
  }
}
