import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class ShippingAddressView extends StatefulWidget {
  const ShippingAddressView({super.key});

  @override
  State<ShippingAddressView> createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  final AddToCartController cartController = Get.find<AddToCartController>();
  final TextEditingController remarksController = TextEditingController();

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    cartController.placeOrder(
      context: context,
      remarks: remarksController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.brandRed,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBar(
          title: "Shipping Details",
          showBackButton: true,
        ),
        bottomNavigationBar: GetBuilder<AddToCartController>(
          builder: (controller) {
            return Container(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: CommonButton(
                    btnName: "Place Order",
                    isLoading: controller.isPlacingOrder,
                    onTap: controller.isPlacingOrder ? null : _placeOrder,
                  ),
                ),
              ),
            );
          },
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
            child: CommonTextField(
              isTitle: true,
              title: "Remarks",
              controller: remarksController,
              hintText: "Enter remarks",
              borderRadius: 12,
              maxLine: 5,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      ),
    );
  }
}
