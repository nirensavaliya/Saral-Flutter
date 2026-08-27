import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Screen/ProductDetail/Model/sub_category_detail_args.dart';
import 'package:saral/View/Screen/ProductDetail/view/FlyToCartAnimation.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/sub_category_list_card.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class SubCategoryDetailView extends StatefulWidget {
  const SubCategoryDetailView({super.key});

  @override
  State<SubCategoryDetailView> createState() => _SubCategoryDetailViewState();
}

class _SubCategoryDetailViewState extends State<SubCategoryDetailView> {
  late final SubCategoryDetailArgs _args;
  final ProductDetailController _cartController = Get.put(
    ProductDetailController(),
  );
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _args = Get.arguments as SubCategoryDetailArgs;
    if (_args.items.isNotEmpty) {
      _cartController.initQtyOptions(_args.items.first);
    }
  }

  ItemListData get _selectedItem => _args.items[_selectedIndex];

  String get _subCategoryName {
    final fromArgs = _args.subCategory.subCategoryName?.trim();
    if (fromArgs != null && fromArgs.isNotEmpty) return fromArgs;
    final fromItem = _selectedItem.subCategory?.trim();
    if (fromItem != null && fromItem.isNotEmpty) return fromItem;
    return "--";
  }

  void _selectItem(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      _cartController.initQtyOptions(_args.items[index]);
    });
  }

  Future<void> _handleAddToCart() async {
    final item = _selectedItem;
    await _cartController.addProductToCart(item);
    if (!mounted) return;

    await FlyToCartAnimator.fly(
      context: context,
      startKey: _cartController.imageKey,
      cartKey: _cartController.cartKey,
      imageUrl: item.displayImageUrl ?? '',
      onComplete: _cartController.animateCart,
    );

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
    final subName = _args.subCategory.subCategoryName ?? "Product Detail";

    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: subName,
        showBackButton: true,
        actions: [
          Obx(
            () => ScaleTransition(
              scale: _cartController.bounceAnimation,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      key: _cartController.cartKey,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.addToCartScreen);
                      },
                    ),
                    if (_cartController.cartCount.value > 0)
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
                            _cartController.cartCount.value.toString(),
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
      floatingActionButton: _args.items.isEmpty
          ? null
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              height: 52,
              child: FloatingActionButton.extended(
                elevation: 4,
                backgroundColor: AppColors.brandRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onPressed: _handleAddToCart,
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
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
        child: _args.items.isEmpty
            ? Center(
                child: CommonText(
                  text: "No Product Found",
                  fontFamily: FontFamily.poppinsSemiBold,
                  color: Colors.grey,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildProductImage(_selectedItem),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CommonText(
                      text: _selectedItem.itemName ?? "--",
                      fontFamily: FontFamily.poppinsBold,
                      fontSize: 20,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    _detailsCard(_selectedItem),
                    const SizedBox(height: 16),
                    SubCategoryListCard(
                      subCategoryName: _subCategoryName,
                      showChevron: false,
                    ),
                    if (_args.items.length > 1) ...[
                      const SizedBox(height: 20),
                      CommonText(
                        text: "Select Variant",
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(_args.items.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _variantTile(
                            item: _args.items[index],
                            isSelected: index == _selectedIndex,
                            onTap: () => _selectItem(index),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProductImage(ItemListData item) {
    final imageUrl = item.displayImageUrl?.trim();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        key: _cartController.imageKey,
        width: 240,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => CatalogImagePlaceholder(
          key: _cartController.imageKey,
          width: 240,
          height: 240,
        ),
      );
    }
    return CatalogImagePlaceholder(
      key: _cartController.imageKey,
      width: 240,
      height: 240,
    );
  }

  Widget _detailsCard(ItemListData item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE8E8)),
      ),
      child: Column(
        children: [
          _detailRow("Item Code", item.itemCode),
          _detailRow("Brand", item.brandName),
          _detailRow("Category", item.category),
          _detailRow("Unit Code", item.unitCode),
          _detailRow("Sales Discount", item.salesDiscountPER?.toString()),
          _detailRow("Dis. Price", item.discount?.toString()),
          _detailRow(
            "Sale Price",
            item.price?.toString(),
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
                      value: _cartController.qtyOptions.contains(
                        _cartController.quantity.value,
                      )
                          ? _cartController.quantity.value
                          : null,
                      hint: const Text("Select"),
                      items: _cartController.qtyOptions
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
                          _cartController.setQuantity(value);
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
    );
  }

  Widget _variantTile({
    required ItemListData item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final type = item.unitCode?.trim().isNotEmpty == true
        ? item.unitCode!
        : (_subCategoryName != "--" ? _subCategoryName : "--");

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.brandRed : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: item.itemName ?? "--",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 14,
                      color: AppColors.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    CommonText(
                      text: "Type: $type",
                      fontFamily: FontFamily.poppinsRegular,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.brandRed,
                  size: 20,
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
              fontSize: 16,
              color: resolvedColor,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
