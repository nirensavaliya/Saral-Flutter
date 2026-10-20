import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/admin_product_list_controller.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Service/sales_order_cart_service.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';
import 'package:saral/View/Widget/selectable_product_list.dart';
import 'package:shimmer/shimmer.dart';

class AdminProductListView extends StatefulWidget {
  final String title;

  const AdminProductListView({
    super.key,
    this.title = "Product",
  });

  @override
  State<AdminProductListView> createState() => _AdminProductListViewState();
}

class _AdminProductListViewState extends State<AdminProductListView> {
  late final AdminProductListController controller;
  final TextEditingController _searchController = TextEditingController();
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AdminProductListController>()
        ? Get.find<AdminProductListController>()
        : Get.put(AdminProductListController());
    _refreshCartCount();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshCartCount() {
    final count = SalesOrderCartService.loadAll()
        .fold<int>(0, (sum, cart) => sum + cart.items.length);
    if (!mounted) return;
    setState(() {
      cartCount = count;
    });
  }

  Future<void> _openCart() async {
    await Get.toNamed(AppRoutes.addToCartScreen);
    _refreshCartCount();
  }

  Future<void> _openProductDetail(ItemListData item) async {
    await Get.toNamed(
      AppRoutes.productDetailViewScreen,
      arguments: item,
    );
    _refreshCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandRed,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Obx(() {
          final searching = controller.showProductSearchField.value;
          return CommonAppBar(
            title: widget.title,
            showDrawer: false,
            showBackButton: Navigator.canPop(context),
            titleWidget: searching ? _appBarSearchField() : null,
            actions: [
              GestureDetector(
                child: Icon(
                  searching ? Icons.close_rounded : Icons.search_rounded,
                  color: Colors.white,
                ),
                onTap: () {
                  if (searching) {
                    _searchController.clear();
                    controller.closeProductSearchField();
                  } else {
                    controller.toggleProductSearchField();
                  }
                },
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    onPressed: _openCart,
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartCount.toString(),
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
            ],
          );
        }),
      ),
      drawer: SideMenu(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final selected = controller.selectedBrandData.value;
                final brands = controller.brandListData;
                return _filterDropdownCard(
                  selected: selected != null,
                  isLoading: controller.isGetBrand.value && brands.isEmpty,
                  loadingText: 'Loading brands...',
                  child: DropdownButtonFormField<BranddData>(
                    value: selected,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    decoration: InputDecoration(
                      hintText: "Select Brand",
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.poppinsMedium,
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.storefront_outlined,
                        color: AppColors.brandRed.withOpacity(0.85),
                        size: 20,
                      ),
                    ),
                    hint: CommonText(
                      text: "Select Brand",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    icon: selected != null
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black54,
                          ),
                    items: brands.map((item) {
                      return DropdownMenuItem<BranddData>(
                        value: item,
                        child: _dropdownItem(
                          imageUrl: item.imageUrl,
                          title: item.brandName ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: controller.onBrandChanged,
                  ),
                  onClear: selected != null
                      ? controller.clearBrandSelection
                      : null,
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final selected = controller.selectedCategory.value;
                final categories = controller.categoryListData;
                return _filterDropdownCard(
                  selected: selected != null,
                  isLoading:
                      controller.isGetCategory.value && categories.isEmpty,
                  loadingText: 'Loading categories...',
                  child: DropdownButtonFormField<CategoryListData>(
                    value: selected,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    decoration: InputDecoration(
                      hintText: "Select Category",
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.poppinsMedium,
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.brandRed.withOpacity(0.85),
                        size: 20,
                      ),
                    ),
                    hint: CommonText(
                      text: "Select Category",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    icon: selected != null
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black54,
                          ),
                    items: categories.map((item) {
                      return DropdownMenuItem<CategoryListData>(
                        value: item,
                        child: _dropdownItem(
                          imageUrl: item.imageUrl,
                          title: item.categoryName ?? "",
                        ),
                      );
                    }).toList(),
                    onChanged: controller.onCategoryChanged,
                  ),
                  onClear: selected != null
                      ? controller.clearCategorySelection
                      : null,
                );
              }),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  if (controller.isItemListLoading.value &&
                      controller.itemList.isEmpty) {
                    return _listShimmer();
                  }
                  final data = controller.itemList;
                  final searching = controller.showProductSearchField.value;
                  final hasQuery =
                      controller.productSearchQuery.value.trim().isNotEmpty;
                  if (data.isEmpty) {
                    return _catalogMessage(
                      icon: searching && hasQuery
                          ? Icons.search_off_outlined
                          : Icons.inventory_2_outlined,
                      message: searching && hasQuery
                          ? "No matching product found"
                          : "No Product Found",
                    );
                  }
                  return SelectableProductList(
                    items: data,
                    scrollController: controller.scrollController,
                    isLoadingMore: controller.isLoadingMore.value,
                    resetKey:
                        '${controller.selectedBrandData.value?.brandID}-${controller.selectedCategory.value?.categoryID}-${controller.productSearchQuery.value}',
                    onCartChanged: _refreshCartCount,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _variantCard({
    required ItemListData item,
    required VoidCallback onTap,
  }) {
    final unitCode = (item.unitCode ?? "").trim().isEmpty
        ? "--"
        : item.unitCode!.trim();
    final brand = (item.brandName ?? "").trim();
    final category = (item.category ?? "").trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
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
                    CommonText(
                      text: item.itemName ?? "--",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 13,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    CommonText(
                      text: "₹ ${item.price ?? 0}",
                      fontFamily: FontFamily.poppinsBold,
                      fontSize: 13,
                      color: AppColors.brandRed,
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
                    CommonText(
                      text: "Unit: $unitCode",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ],
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

  Widget _appBarSearchField() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: controller.onProductSearch,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => controller.submitProductSearch(),
        style: TextStyle(
          fontFamily: FontFamily.poppinsMedium,
          fontSize: 15,
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "Search product...",
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontFamily: FontFamily.poppinsRegular,
            fontSize: 14,
          ),
          isDense: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _filterDropdownCard({
    required bool selected,
    required bool isLoading,
    required String loadingText,
    required Widget child,
    VoidCallback? onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(color: AppColors.brandRed.withOpacity(0.35))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.brandRed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          loadingText,
                          style: TextStyle(
                            fontFamily: FontFamily.poppinsMedium,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : child,
          ),
          if (onClear != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                color: AppColors.brandRed.withOpacity(0.1),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onClear,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.brandRed,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dropdownItem({required String? imageUrl, required String title}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl ?? "",
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 24,
              height: 24,
              color: const Color(0xffF8F8F8),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _listShimmer() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _catalogMessage({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          CommonText(
            text: message,
            fontFamily: FontFamily.poppinsSemiBold,
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
