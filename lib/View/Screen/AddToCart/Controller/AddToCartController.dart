import 'package:get/get.dart';

class AddToCartController extends GetxController {
  RxInt quantity = 1.obs;
  RxBool isCartEmpty = false.obs;

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void clearCart() {
    isCartEmpty.value = true;
  }
}