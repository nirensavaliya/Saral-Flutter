import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saral/Common/Tost.dart';
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

  final TextEditingController shippingAddressController =
      TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController poDateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  DateTime? _deliveryDate;
  DateTime? _poDate;

  final _displayFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    shippingAddressController.dispose();
    deliveryDateController.dispose();
    poDateController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  bool _validate() {
    if (shippingAddressController.text.trim().isEmpty) {
      Utils().showToast(
        context: context,
        title: "Error",
        message: "Please enter shipping address",
        isSuccess: false,
      );
      return false;
    }
    if (_deliveryDate == null) {
      Utils().showToast(
        context: context,
        title: "Error",
        message: "Please select delivery date",
        isSuccess: false,
      );
      return false;
    }
    if (_poDate == null) {
      Utils().showToast(
        context: context,
        title: "Error",
        message: "Please select PO date",
        isSuccess: false,
      );
      return false;
    }
    return true;
  }

  Future<void> _pickDate({required bool isDelivery}) async {
    final now = DateTime.now();
    final initial = isDelivery
        ? (_deliveryDate ?? now)
        : (_poDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandRed,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    setState(() {
      if (isDelivery) {
        _deliveryDate = picked;
        deliveryDateController.text = _displayFormat.format(picked);
      } else {
        _poDate = picked;
        poDateController.text = _displayFormat.format(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar:  CommonAppBar(
        title: "Shipping Details",
        showBackButton: true,
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
        child: Column(
          children: [
            CommonTextField(
              isTitle: true,
              title: "Shipping Address",
              controller: shippingAddressController,
              hintText: "Enter shipping address",
              borderRadius: 12,
              maxLine: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            CommonTextField(
              isTitle: true,
              title: "Delivery Date",
              controller: deliveryDateController,
              hintText: "Select delivery date",
              borderRadius: 12,
              readOnly: true,
              showCursor: false,
              onTap: () => _pickDate(isDelivery: true),
              suffix: IconButton(
                onPressed: () => _pickDate(isDelivery: true),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            CommonTextField(
              isTitle: true,
              title: "PO Date",
              controller: poDateController,
              hintText: "Select PO date",
              borderRadius: 12,
              readOnly: true,
              showCursor: false,
              onTap: () => _pickDate(isDelivery: false),
              suffix: IconButton(
                onPressed: () => _pickDate(isDelivery: false),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            CommonTextField(
              isTitle: true,
              title: "Remarks",
              controller: remarksController,
              hintText: "Enter remarks",
              borderRadius: 12,
              maxLine: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 28),
            GetBuilder<AddToCartController>(
              builder: (controller) {
                return CommonButton(
                  btnName: "Place Order",
                  isLoading: controller.isPlacingOrder,
                  onTap: controller.isPlacingOrder
                      ? null
                      : () {
                          if (!_validate()) return;
                          controller.placeOrder(
                            context: context,
                            shippingAddress:
                                shippingAddressController.text.trim(),
                            deliveryDate: _deliveryDate,
                            poDate: _poDate,
                            remarks: remarksController.text.trim(),
                          );
                        },
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
