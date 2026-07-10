import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Screen/Splash/Controller/Splash_Controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppImages.logoImg,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}