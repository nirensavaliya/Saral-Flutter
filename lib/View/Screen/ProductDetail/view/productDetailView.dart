import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/ProductDetail/view/FlyToCartAnimation.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/sub_category_list_card.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class ProductDetailView extends StatefulWidget {
  ItemListData? itemListModelData;
  ProductDetailView({super.key, this.itemListModelData});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductDetailController productDetailController = Get.put(
    ProductDetailController(),
  );

  @override
  void initState() {
    super.initState();
    widget.itemListModelData = Get.arguments;
    productDetailController.initQtyOptions(widget.itemListModelData);
  }

  Future<void> _handleAddToCart() async {
    final item = widget.itemListModelData;
    if (item == null) return;

    await productDetailController.addProductToCart(item);

    if (!mounted) return;
    await FlyToCartAnimator.fly(
      context: context,
      startKey: productDetailController.imageKey,
      cartKey: productDetailController.cartKey,
      imageUrl: widget.itemListModelData?.itemImage ?? '',
      onComplete: () {
        productDetailController.animateCart();
      },
    );
    Get.back();
    final ctx = Get.context;
    if (ctx != null) {
      Utils().showToast(
        context: ctx,
        title: "Success",
        message: "Order saved to cart successfully",
        isSuccess: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.itemListModelData;

    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Product Detail",
        showBackButton: true,
        actions: [
          Obx(
            () => ScaleTransition(
              scale: productDetailController.bounceAnimation,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      key: productDetailController.cartKey,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.addToCartScreen);
                      },
                    ),
                    if (productDetailController.cartCount.value > 0)
                      Positioned(
                        right: 0,
                        top: 2,
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            productDetailController.cartCount.value.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88,
        height: 52,
        child: FloatingActionButton.extended(
          elevation: 4,
          backgroundColor: AppColors.brandRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onPressed: _handleAddToCart,
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          label: CommonText(
            text: "Add to Cart",
            fontFamily: FontFamily.poppinsSemiBold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.itemListModelData?.displayImageUrl != null &&
                          widget.itemListModelData!.displayImageUrl!
                              .trim()
                              .isNotEmpty
                      ? Image.network(
                          widget.itemListModelData!.displayImageUrl!,
                          key: productDetailController.imageKey,
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const CatalogImagePlaceholder(
                            width: 240,
                            height: 240,
                          ),
                        )
                      : CatalogImagePlaceholder(
                          key: productDetailController.imageKey,
                          width: 240,
                          height: 240,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              CommonText(
                text: item?.itemName ?? "--",
                fontFamily: FontFamily.poppinsBold,
                fontSize: 16,
                color: AppColors.black,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFDE8E8)),
                ),
                child: Column(
                  children: [
                    _detailRow("Item Code", item?.itemCode),
                    _detailRow("Brand", item?.brandName),
                    _detailRow("Category", item?.category),
                    // _detailRow("Unit Code", item?.unitCode),
                    if (canShowPrice)
                      _detailRow(
                        "Sales Discount",
                        item?.salesDiscountPER?.toString(),
                      ),
                    // _detailRow("Dis. Price", item?.discount?.toString()),
                    if (canShowPrice)
                      _detailRow(
                        "Sale Price",
                        item?.price?.toString(),
                        valueColor: AppColors.brandRed,
                        valueFont: FontFamily.poppinsBold,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          text: "Qty",
                          fontFamily: FontFamily.poppinsRegular,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        Obx(
                          () => Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.brandRed,
                                width: 1.5,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                dropdownColor: Colors.white,
                                value: productDetailController.qtyOptions
                                        .contains(
                                      productDetailController.quantity.value,
                                    )
                                    ? productDetailController.quantity.value
                                    : null,
                                hint: const Text("Select"),
                                items: productDetailController.qtyOptions
                                    .map(
                                      (q) => DropdownMenuItem<int>(
                                        value: q,
                                        child: Text(
                                          q.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    productDetailController.setQuantity(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SubCategoryListCard(
                subCategoryName: (item?.subCategory ?? "").trim().isEmpty
                    ? "--"
                    : item!.subCategory!.trim(),
                showChevron: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(
    String label,
    String? value, {
    Color? valueColor,
    String? valueFont,
  }) {
    final resolvedColor = valueColor ?? AppColors.black;
    final resolvedFont = valueFont ?? FontFamily.poppinsSemiBold;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: CommonText(
              text: "$label:",
              fontFamily: FontFamily.poppinsRegular,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Expanded(
            flex: 5,
            child: CommonText(
              text: (value ?? "").trim().isEmpty ? "--" : value!.trim(),
              fontFamily: resolvedFont,
              fontSize: 15,
              color: resolvedColor,
              textAlign: TextAlign.end,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
