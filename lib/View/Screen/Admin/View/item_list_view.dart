import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/item_list_controller.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class ItemListView extends GetView<ItemListController> {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: CommonAppBar(
        title: "Item List",
        showDrawer: false,
        showBackButton: true,
        actions: [
          Obx(() {
            if (!controller.hasFilters) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: controller.resetFilters,
                child:  Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.poppinsMedium,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            _SearchField(controller: controller),
            const Gap(12),
            Obx(
              () => _FilterSelector(
                title: controller.selectedCategory.value.categoryName ??
                    "Select Category",
                hasSelection:
                    controller.selectedCategory.value.categoryName != null,
                onTap: () => openCategorySelection(controller),
                onClear: () => controller.clearCategorySelection(),
              ),
            ),
            const Gap(10),
            Obx(
              () => _FilterSelector(
                title: controller.selectedBrand.value.brandName ??
                    "Select Brand",
                hasSelection:
                    controller.selectedBrand.value.brandName != null,
                onTap: () => openBrandSelection(controller),
                onClear: () => controller.clearBrandSelection(),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Lottie.asset(
                      'assets/lottie/app_loader.json',
                      width: 145,
                      height: 145,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  );
                }

                final items = controller.displayedItems;
                final isSearching =
                    controller.searchQuery.value.trim().isNotEmpty;

                if (items.isEmpty) {
                  return Center(
                    child: CommonText(
                      text: isSearching
                          ? "No item found"
                          : "No items available",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: items.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.brandRed,
                          ),
                        ),
                      );
                    }

                    final model = items[index];
                    return _ItemCard(
                      model: model,
                      onTap: () => _showItemDetails(context, model),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, ItemListData model) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Center(
          child: CommonText(
            text: "Item Details",
            fontFamily: FontFamily.poppinsSemiBold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _SelectedItemView(model: model),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: AppColors.brandRed,
                fontFamily: FontFamily.poppinsMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openCategorySelection(ItemListController controller) async {
    await controller.ensureFilterListsLoaded();
    controller.filteredCategories.value =
        List.from(ApiConstant.categoryBrandList);

    Get.bottomSheet(
      isScrollControlled: true,
      _SelectionSheet(
        title: "Select Category",
        searchHint: "Search category...",
        onSearch: controller.categoryFilter,
        child: Obx(() {
          return GridView.builder(
            itemCount: controller.filteredCategories.length,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final category = controller.filteredCategories[index];
              return _GridTile(
                imageUrl: category.imageUrl,
                title: category.categoryName ?? '',
                onTap: () async {
                  Get.back();
                  await controller.selectCategory(category);
                },
              );
            },
          );
        }),
      ),
    );
  }

  Future<void> openBrandSelection(ItemListController controller) async {
    await controller.ensureFilterListsLoaded();
    final categoryId = controller.selectedCategory.value.categoryID;
    if (categoryId != null) {
      await controller.getBrandListByCategoryApi(categoryId);
    } else {
      controller.filteredBrands.value = List.from(ApiConstant.brandList);
    }

    Get.bottomSheet(
      isScrollControlled: true,
      _SelectionSheet(
        title: "Select Brand",
        searchHint: "Search brand...",
        onSearch: controller.brandFilter,
        child: Obx(() {
          return GridView.builder(
            itemCount: controller.filteredBrands.length,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final brand = controller.filteredBrands[index];
              return _GridTile(
                imageUrl: brand.imageUrl,
                title: brand.brandName ?? '',
                onTap: () async {
                  Get.back();
                  await controller.selectBrand(brand);
                },
              );
            },
          );
        }),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final ItemListController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onItemSearch,
        style: TextStyle(
          fontFamily: FontFamily.poppinsMedium,
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: "Search item...",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: FontFamily.poppinsRegular,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _FilterSelector extends StatelessWidget {
  const _FilterSelector({
    required this.title,
    required this.hasSelection,
    required this.onTap,
    required this.onClear,
  });

  final String title;
  final bool hasSelection;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: hasSelection ? onClear : null,
                child: Icon(
                  hasSelection
                      ? Icons.cancel
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionSheet extends StatelessWidget {
  const _SelectionSheet({
    required this.title,
    required this.searchHint,
    required this.onSearch,
    required this.child,
  });

  final String title;
  final String searchHint;
  final ValueChanged<String> onSearch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppBar().preferredSize.height),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          color: Colors.white,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.poppinsSemiBold,
                  color: Colors.black87,
                ),
              ),
              const Divider(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: FontFamily.poppinsRegular,
                    ),
                    filled: true,
                    fillColor: const Color(0xffF8F8F8),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  final String? imageUrl;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl ?? '',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppImages.logoImg,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: FontFamily.poppinsMedium,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.model, required this.onTap});

  final ItemListData model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _buildItemImage(
                    model,
                    width: 64,
                    height: 64,
                    placeholderSize: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.itemName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: FontFamily.poppinsSemiBold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${model.price?.toStringAsFixed(2) ?? "0.00"}",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamily.poppinsMedium,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedItemView extends StatelessWidget {
  const _SelectedItemView({required this.model});

  final ItemListData model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildItemImage(
                model,
                width: 120,
                height: 120,
                placeholderSize: 100,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _detailRow("Item Name", model.itemName),
          _detailRow("Item Code", model.itemCode),
          _detailRow("Unit Code", model.unitCode),
          _detailRow("Basic Price", model.finalCost?.toString()),
          _detailRow("Purchase Price", model.purchasePrice?.toString()),
          _detailRow("Purchase VAT AMT", model.purchaseVATamt?.toString()),
          _detailRow("Discount", model.discount?.toString()),
          _detailRow("Item Value", model.price?.toString()),
          _detailRow("Stock Qty.", model.stockQty?.toString()),
          _detailRow("Brand Name", model.brandName),
          _detailRow("Category", model.name),
          _detailRow("SubCategory Name", model.subCategory),
          _detailRow("Barcode No.", model.defaultBarcodeNo),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title:",
              style: TextStyle(
                fontFamily: FontFamily.poppinsSemiBold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: TextStyle(
                fontFamily: FontFamily.poppinsMedium,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildItemImage(
  ItemListData model, {
  required double width,
  required double height,
  required double placeholderSize,
}) {
  final url = model.displayImageUrl;
  if (url == null) {
    return Image.asset(
      AppImages.logoImg,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  return Image.network(
    url,
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Image.asset(
      AppImages.logoImg,
      width: placeholderSize,
      height: placeholderSize,
      fit: BoxFit.cover,
    ),
  );
}
