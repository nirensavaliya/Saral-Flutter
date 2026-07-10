import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';

class ProductDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt quantity = 1.obs;
  final GlobalKey imageKey = GlobalKey();
  RxInt cartCount = 0.obs;
  final GlobalKey cartButtonKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  late AnimationController bounceController;
  late Animation<double> bounceAnimation;

  // RxInt itemId=0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    bounceAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: bounceController, curve: Curves.easeOut));
  }

  void animateCart() {
    cartCount.value++;
    bounceController.forward(from: 0);
  }

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  @override
  void onClose() {
    bounceController.dispose();
    super.onClose();
  }

    // catch (e) {
    //   print("product Detail Api Error --- $e");
    // } finally {
    //   isProductDetailLoading.value = false;
    // }
  // }

}
