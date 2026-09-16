import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Screen/ProductDetail/Model/sub_category_detail_args.dart';
import 'package:saral/View/Screen/ProductDetail/view/FlyToCartAnimation.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
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
  final Set<int> _selectedIndices = <int>{};
  final Map<int, int> _qtyByIndex = <int, int>{};
  int? _previewIndex;

  @override
  void initState() {
    super.initState();
    _args = Get.arguments as SubCategoryDetailArgs;
    if (_args.items.length == 1) {
      _selectedIndices.add(0);
      _previewIndex = 0;
      _qtyByIndex[0] = _qtyOptionsFor(0).first;
    }
  }

  ItemListData? get _previewItem {
    final index = _previewIndex;
    if (index != null && index >= 0 && index < _args.items.length) {
      return _args.items[index];
    }
    return _args.items.isEmpty ? null : _args.items.first;
  }

  List<int> _qtyOptionsFor(int index) {
    return ProductDetailController.qtyOptionsFor(_args.items[index]);
  }

  void _toggleVariant(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        _qtyByIndex.remove(index);
        if (_previewIndex == index) {
          _previewIndex =
              _selectedIndices.isEmpty ? null : _selectedIndices.last;
        }
      } else {
        _selectedIndices.add(index);
        _previewIndex = index;
        _qtyByIndex[index] = _qtyOptionsFor(index).first;
      }
    });
  }

  void _setVariantQty(int index, int qty) {
    setState(() {
      _qtyByIndex[index] = qty;
    });
  }

  Future<void> _handleAddToCart() async {
    if (_selectedIndices.isEmpty) {
      final ctx = Get.context;
      if (ctx != null) {
        Utils().showToast(
          context: ctx,
          title: "Select Item",
          message: "Please select at least one variant",
          isSuccess: false,
        );
      }
      return;
    }

    final entries = _selectedIndices.map((index) {
      return (
        item: _args.items[index],
        qty: _qtyByIndex[index] ?? _qtyOptionsFor(index).first,
      );
    }).toList();

    await _cartController.addProductsToCart(entries);
    if (!mounted) return;

    final preview = _previewItem;
    if (preview != null) {
      await FlyToCartAnimator.fly(
        context: context,
        startKey: _cartController.imageKey,
        cartKey: _cartController.cartKey,
        imageUrl: preview.displayImageUrl ?? '',
        onComplete: _cartController.animateCart,
      );
    } else {
      _cartController.animateCart();
    }

    final ctx = Get.context;
    if (ctx != null) {
      Utils().showToast(
        context: ctx,
        title: "Success",
        message: entries.length == 1
            ? "Order saved to cart successfully"
            : "${entries.length} items saved to cart successfully",
        isSuccess: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subName = _args.subCategory.subCategoryName ?? "Product Detail";
    final preview = _previewItem;
    final hasSelection = _selectedIndices.isNotEmpty;

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
                backgroundColor: hasSelection
                    ? AppColors.brandRed
                    : AppColors.brandRed.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onPressed: hasSelection ? _handleAddToCart : null,
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                label: CommonText(
                  text: hasSelection && _selectedIndices.length > 1
                      ? "Add ${_selectedIndices.length} to Cart"
                      : "Add to Cart",
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
                    CommonText(
                      text: hasSelection
                          ? (preview?.itemName ?? "--")
                          : subName,
                      fontFamily: FontFamily.poppinsBold,
                      fontSize: 20,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _selectedProductImage(preview),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_args.items.length > 1) ...[
                      CommonText(
                        text: "Select Variant",
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 10),
                    ],
                    ...List.generate(_args.items.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _variantTile(
                          index: index,
                          item: _args.items[index],
                          isSelected: _selectedIndices.contains(index),
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _selectedProductImage(ItemListData? item) {
    final imageUrl = item?.displayImageUrl?.trim();

    return SizedBox(
      key: _cartController.imageKey,
      width: 240,
      height: 240,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: 240,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const CatalogImagePlaceholder(
                width: 240,
                height: 240,
              ),
            )
          : const CatalogImagePlaceholder(
              width: 240,
              height: 240,
            ),
    );
  }

  Widget _variantImage(ItemListData item) {
    final imageUrl = item.displayImageUrl?.trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const CatalogImagePlaceholder(
          width: 72,
          height: 72,
          showLabel: false,
        ),
      );
    }

    return const CatalogImagePlaceholder(
      width: 72,
      height: 72,
      showLabel: false,
    );
  }

  Widget _variantTile({
    required int index,
    required ItemListData item,
    required bool isSelected,
  }) {
    final unitCode = (item.unitCode ?? "").trim().isEmpty
        ? "--"
        : item.unitCode!.trim();
    final qtyOptions = _qtyOptionsFor(index);
    final selectedQty = _qtyByIndex[index] ?? qtyOptions.first;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _toggleVariant(index),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.brandRed : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: _variantImage(item),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: item.itemName ?? "--",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 14,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (canShowPrice) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CommonText(
                            text: "₹ ${item.price ?? 0}",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 15,
                            color: AppColors.brandRed,
                          ),
                          const Spacer(),
                          CommonText(
                            text: "Sales Discount:",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          CommonText(
                            text: item.salesDiscountPER?.toString() ?? "0",
                            fontFamily: FontFamily.poppinsSemiBold,
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ],
                    if (isSelected) ...[
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: "Unit Code",
                                  fontFamily: FontFamily.poppinsRegular,
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 6),
                                CommonText(
                                  text: unitCode,
                                  fontFamily: FontFamily.poppinsMedium,
                                  fontSize: 14,
                                  color: AppColors.black,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 92,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CommonText(
                                  text: "Qty",
                                  fontFamily: FontFamily.poppinsRegular,
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
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
                                        isExpanded: true,
                                        dropdownColor: Colors.white,
                                        value: qtyOptions.contains(selectedQty)
                                            ? selectedQty
                                            : qtyOptions.first,
                                        items: qtyOptions
                                            .map(
                                              (q) => DropdownMenuItem<int>(
                                                value: q,
                                                child: Text(
                                                  q.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            _setVariantQty(index, value);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.brandRed,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
