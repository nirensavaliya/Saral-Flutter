import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class SelectableProductList extends StatefulWidget {
  final List<ItemListData> items;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  final Object? resetKey;
  final VoidCallback? onCartChanged;

  const SelectableProductList({
    super.key,
    required this.items,
    this.scrollController,
    this.isLoadingMore = false,
    this.resetKey,
    this.onCartChanged,
  });

  @override
  State<SelectableProductList> createState() => _SelectableProductListState();
}

class _SelectableProductListState extends State<SelectableProductList> {
  final Set<String> _selectedKeys = <String>{};
  final Map<String, int> _qtyByKey = <String, int>{};
  late final ProductDetailController _cartController;

  @override
  void initState() {
    super.initState();
    _cartController = Get.isRegistered<ProductDetailController>()
        ? Get.find<ProductDetailController>()
        : Get.put(ProductDetailController());
  }

  @override
  void didUpdateWidget(covariant SelectableProductList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetKey != widget.resetKey) {
      _selectedKeys.clear();
      _qtyByKey.clear();
    }
  }

  String _itemKey(ItemListData item) =>
      '${item.itemid ?? 0}_${item.itemName ?? ""}';

  List<int> _qtyOptions(ItemListData item) =>
      ProductDetailController.qtyOptionsFor(item);

  void _toggle(ItemListData item) {
    final key = _itemKey(item);
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
        _qtyByKey.remove(key);
      } else {
        _selectedKeys.add(key);
        _qtyByKey[key] = _qtyOptions(item).first;
      }
    });
  }

  void _setQty(ItemListData item, int qty) {
    setState(() {
      _qtyByKey[_itemKey(item)] = qty;
    });
  }

  Future<void> _openProductDetail(ItemListData item) async {
    await Get.toNamed(
      AppRoutes.productDetailViewScreen,
      arguments: item,
    );
    widget.onCartChanged?.call();
  }

  Future<void> _handleAddToCart() async {
    if (_selectedKeys.isEmpty) return;

    final selectedItems = widget.items
        .where((item) => _selectedKeys.contains(_itemKey(item)))
        .toList();
    if (selectedItems.isEmpty) return;

    final entries = selectedItems.map((item) {
      final options = _qtyOptions(item);
      final qty = _qtyByKey[_itemKey(item)] ?? options.first;
      return (item: item, qty: qty);
    }).toList();

    await _cartController.addProductsToCart(entries);
    _cartController.animateCart();
    if (!mounted) return;

    setState(() {
      _selectedKeys.clear();
      _qtyByKey.clear();
    });
    widget.onCartChanged?.call();

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
    final hasSelection = _selectedKeys.isNotEmpty;
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: widget.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == widget.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.brandRed,
                      ),
                    ),
                  ),
                );
              }
              final item = widget.items[index];
              return _selectableCard(item);
            },
          ),
        ),
        if (hasSelection)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: CommonText(
                  text: _selectedKeys.length > 1
                      ? "Add to Cart (${_selectedKeys.length})"
                      : "Add to Cart (1)",
                  fontFamily: FontFamily.poppinsSemiBold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _selectableCard(ItemListData item) {
    final key = _itemKey(item);
    final isSelected = _selectedKeys.contains(key);
    final unitCode = (item.unitCode ?? "").trim().isEmpty
        ? "--"
        : item.unitCode!.trim();
    final brand = (item.brandName ?? "").trim();
    final category = (item.category ?? "").trim();
    final qtyOptions = _qtyOptions(item);
    final selectedQty = _qtyByKey[key] ?? qtyOptions.first;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openProductDetail(item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.brandRed : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: _itemImage(item),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonText(
                            text: item.itemName ?? "--",
                            fontFamily: FontFamily.poppinsSemiBold,
                            fontSize: 13,
                            color: AppColors.black,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        CommonText(
                          text: "₹ ${item.price ?? 0}",
                          fontFamily: FontFamily.poppinsBold,
                          fontSize: 13,
                          color: AppColors.brandRed,
                        ),
                        const Spacer(),
                        CommonText(
                          text: "Sales Discount:",
                          fontFamily: FontFamily.poppinsRegular,
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        CommonText(
                          text: item.salesDiscountPER?.toString() ?? "0",
                          fontFamily: FontFamily.poppinsSemiBold,
                          fontSize: 11,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CommonText(
                      text: "Brand: ${brand.isEmpty ? "--" : brand}",
                      fontFamily: FontFamily.poppinsRegular,
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 2),
                    CommonText(
                      text: "Category: ${category.isEmpty ? "--" : category}",
                      fontFamily: FontFamily.poppinsRegular,
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 4),
                    if (!isSelected)
                      CommonText(
                        text: "Unit: $unitCode",
                        fontFamily: FontFamily.poppinsMedium,
                        fontSize: 12,
                        color: AppColors.black,
                      )
                    else ...[
                      const SizedBox(height: 8),
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
                                            _setQty(item, value);
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
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: GestureDetector(
                  onTap: () => _toggle(item),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isSelected
                        ? AppColors.brandRed
                        : Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemImage(ItemListData item) {
    final imageUrl = item.displayImageUrl?.trim();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 58,
        height: 58,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const CatalogImagePlaceholder(
          width: 58,
          height: 58,
          showLabel: false,
        ),
      );
    }
    return const CatalogImagePlaceholder(
      width: 58,
      height: 58,
      showLabel: false,
    );
  }
}
