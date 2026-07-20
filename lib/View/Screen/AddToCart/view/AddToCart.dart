import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Screen/AddToCart/view/AddToCartBottomBar.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/sales_order_cart_model.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_textfild.dart';

import '../../../../Common/Global.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final AddToCartController addToCartController =
      Get.put(AddToCartController());

  @override
  void initState() {
    super.initState();
    // loadCarts runs in AddToCartController.onInit; refresh after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      addToCartController.loadCarts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: GetBuilder<AddToCartController>(
        init: addToCartController,
        builder: (controller) {
          final carts = controller.carts;
          final grandTotals = controller.grandTotals;

          return Scaffold(
            backgroundColor: AppColors.brandRed,
            appBar: CommonAppBar(
              title: "Cart",
              showBackButton: true,
             /* actions: [
                if (carts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        onPressed: () => controller.clearCart(),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
              ],*/
            ),
            bottomNavigationBar: carts.isEmpty
                ? null
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.42,
                    ),
                    child: SingleChildScrollView(
                      child: AddToCartBottomBar(
                        totals: grandTotals,
                        isPlacingOrder: controller.isPlacingOrder,
                        buttonName: "Proceed to Checkout",
                        onPlaceOrder: () =>
                            controller.goToShippingScreen(context: context),
                      ),
                    ),
                  ),
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  if (isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                      child: CommonTextField(
                        borderRadius: 12,
                        controller: controller.customerController,
                        title: "Customer Name",
                        isTitle: true,
                        maxLength: 10,
                        hintText: "Please Select...",
                        showCursor: false,
                        readOnly: true,
                        onTap: controller.isCustomer
                            ? null
                            : () {
                                controller.selectCustomer();
                              },
                        suffix: controller.isCustomer
                            ? null
                            : const RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),
                  Expanded(
                    child: carts.isEmpty
                        ? Center(
                            child: CommonText(
                              text: "No cart items found",
                              fontFamily: FontFamily.poppinsMedium,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                            itemCount: carts.length,
                            itemBuilder: (context, index) {
                              final cart = carts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CartGroupCard(
                                  cart: cart,
                                  totals: controller.cartTotals(cart),
                                  onRemoveCart: () =>
                                      controller.removeCart(cart.cartId),
                                  onRemoveItem: (itemIndex) =>
                                      controller.removeItem(
                                    cart.cartId,
                                    itemIndex,
                                  ),
                                  onUpdateQty: (itemIndex, newQty) =>
                                      controller.updateItemQty(
                                    cart.cartId,
                                    itemIndex,
                                    newQty,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartGroupCard extends StatefulWidget {
  const _CartGroupCard({
    required this.cart,
    required this.totals,
    required this.onRemoveCart,
    required this.onRemoveItem,
    required this.onUpdateQty,
  });

  final SalesOrderCartModel cart;
  final Map<String, String> totals;
  final VoidCallback onRemoveCart;
  final ValueChanged<int> onRemoveItem;
  final void Function(int itemIndex, double newQty) onUpdateQty;

  @override
  State<_CartGroupCard> createState() => _CartGroupCardState();
}

class _CartGroupCardState extends State<_CartGroupCard> {
  bool isExpanded = false;

  SalesOrderCartModel get cart => widget.cart;

  @override
  Widget build(BuildContext context) {
    final totals = widget.totals;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: cart.customerName?.isNotEmpty == true
                              ? cart.customerName!
                              : 'Saved Cart',
                          fontFamily: FontFamily.poppinsSemiBold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        const SizedBox(height: 4),
                        CommonText(
                          text:
                              'Items: ${totals['totalItem']}  •  Net: ${totals['netTotal']}',
                          fontFamily: FontFamily.poppinsMedium,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.brandRed,
                  ),
                  IconButton(
                    onPressed: widget.onRemoveCart,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade300),
            if ((cart.savedAt ?? '').isNotEmpty)
              _detailRow('Saved At', _formatSavedAt(cart.savedAt!)),
            const SizedBox(height: 4),
            ...List.generate(cart.items.length, (index) {
              final item = cart.items[index];
              final currentQty = item.qty ?? 1;
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: _CartItemCard(
                  item: item,
                  onRemove: () => widget.onRemoveItem(index),
                  onIncrement: () =>
                      widget.onUpdateQty(index, currentQty + 1),
                  onDecrement: () =>
                      widget.onUpdateQty(index, currentQty - 1),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _CartSummaryCard(totals: totals),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          CommonText(
            text: value,
            fontFamily: FontFamily.poppinsSemiBold,
            fontSize: 12,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  String _formatSavedAt(String value) {
    try {
      final dt = DateTime.parse(value).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final suffix = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day}/${dt.month}/${dt.year} $hour:$minute $suffix';
    } catch (_) {
      return value;
    }
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  final SaleOrderDetails item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  String get _qtyLabel {
    final qty = item.qty ?? 0;
    return qty % 1 == 0 ? qty.toInt().toString() : qty.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CommonText(
                    text: item.itemName ?? '',
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                // GestureDetector(
                //   onTap: onRemove,
                //   child: const Icon(
                //     Icons.close,
                //     color: Colors.red,
                //     size: 22,
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: CommonText(
                    text: 'Quantity',
                    fontFamily: FontFamily.poppinsMedium,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onDecrement,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.remove,
                            size: 18,
                            color: AppColors.brandRed,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CommonText(
                          text: _qtyLabel,
                          fontFamily: FontFamily.poppinsSemiBold,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: onIncrement,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.brandRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _itemRow('Price', item.price?.toString() ?? '0'),
          _itemRow(
            'Net Amount',
            item.netAmount?.toStringAsFixed(2) ?? '0.00',
            highlight: true,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _itemRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          CommonText(
            text: value,
            fontFamily: FontFamily.poppinsSemiBold,
            fontSize: 13,
            color: highlight ? AppColors.brandRed : Colors.black87,
          ),
        ],
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({required this.totals});

  final Map<String, String> totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _summaryRow('Total', totals['total'] ?? '0.00'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _summaryRow(
                      'Dis. Total',
                      totals['discountTotal'] ?? '0.00',
                      muted: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    _summaryRow(
                      'CGSTTotal',
                      totals['cGstTotal'] ?? '0.00',
                      muted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _summaryRow(
                      'SGSTTotal',
                      totals['sGstTotal'] ?? '0.00',
                      muted: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    _summaryRow(
                      'IGSTTotal',
                      totals['iGstTotal'] ?? '0.00',
                      muted: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          _summaryRow(
            'TotalItem',
            totals['totalItem'] ?? '0',
            muted: true,
          ),
          Divider(color: Colors.grey.shade300, height: 14),
          _summaryRow(
            'NetTotal',
            totals['netTotal'] ?? '0.00',
            bold: true,
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool muted = false,
    bool bold = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontFamily: bold
                  ? FontFamily.poppinsBold
                  : FontFamily.poppinsMedium,
              fontSize: 12,
              color: muted ? Colors.black54 : Colors.black87,
            ),
          ),
          CommonText(
            text: value,
            fontFamily: bold
                ? FontFamily.poppinsBold
                : FontFamily.poppinsSemiBold,
            fontSize: bold ? 14 : 12,
            color: highlight ? AppColors.brandRed : Colors.black87,
          ),
        ],
      ),
    );
  }
}
