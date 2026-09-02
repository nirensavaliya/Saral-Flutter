import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Service/sales_order_cart_service.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/catalog_grid_card.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:shimmer/shimmer.dart';

class AdminProductView extends StatefulWidget {
  AdminProductView({super.key});

  @override
  State<AdminProductView> createState() => _AdminProductViewState();
}

class _AdminProductViewState extends State<AdminProductView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int cartCount = 0;

  HomeController get controller => Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshCartCount();
    controller.loadCategoryListIfNeeded();
    controller.loadBrandListIfNeeded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (controller.selectedSubCategory.value != null) return;
      if (controller.selectedBrandData.value != null &&
          controller.selectedCategory.value == null) {
        return;
      }
      if (controller.subCategoryListData.isEmpty) {
        controller.getSubCategoryList(
          brandId: controller.selectedBrandData.value?.brandID,
          categoryId: controller.selectedCategory.value?.categoryID,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    controller.clearProductSearch();
    controller.closeProductSearchField();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (controller.selectedSubCategory.value == null) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.itemListApi(loadMore: true);
    }
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

  Future<void> _openProductDetail(dynamic model) async {
    await Get.toNamed(
      AppRoutes.productDetailViewScreen,
      arguments: model,
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
            title: "Product",
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
                    controller.clearProductSearch();
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                      horizontal: 12,
                      vertical: 12,
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
                onClear:
                selected != null ? controller.clearBrandSelection : null,
              );
            }),
            const SizedBox(height: 10),
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
                      horizontal: 12,
                      vertical: 12,
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

            const SizedBox(height: 14),
            Obx(() {
              final category = controller.selectedCategory.value;
              final brand = controller.selectedBrandData.value;
              final sub = controller.selectedSubCategory.value;
              final showingSubCategories =
                  sub == null && !(brand != null && category == null);
              if (showingSubCategories) {
                return const SizedBox.shrink();
              }
              final title = _productsTitle(category, brand, sub);
              final isLoading = controller.isItemListLoading.value;
              return Row(
                children: [
                  Expanded(
                    child: CommonText(
                      text: title,
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  CommonText(
                    text: isLoading
                        ? ""
                        : "${controller.displayedProductItems.length} items",
                    fontFamily: FontFamily.poppinsMedium,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final hasBrand =
                    controller.selectedBrandData.value != null;
                final hasCategory =
                    controller.selectedCategory.value != null;
                final hasSubCategory =
                    controller.selectedSubCategory.value != null;
                final showingSubCategories =
                    !hasSubCategory && !(hasBrand && !hasCategory);

                if (showingSubCategories &&
                    controller.isGetSubCategory.value &&
                    controller.subCategoryListData.isEmpty) {
                  return _productGridShimmer();
                }
                if (!showingSubCategories &&
                    controller.isItemListLoading.value) {
                  return _productGridShimmer();
                }
                if (hasBrand && !hasCategory) {
                  return _catalogMessage(
                    icon: Icons.grid_view_rounded,
                    message: "Please select category",
                  );
                }
                if (showingSubCategories) {
                  return _adminSubCategoryList();
                }
                final data = controller.displayedProductItems;
                final isSearching =
                    controller.productSearchQuery.value.trim().isNotEmpty;
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSearching
                              ? Icons.search_off_outlined
                              : Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        CommonText(
                          text: isSearching
                              ? "No matching product found"
                              : "No Product Found",
                          fontFamily: FontFamily.poppinsSemiBold,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: data.length +
                      (!isSearching && controller.isLoadingMore.value
                          ? 1
                          : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    if (index == data.length) {
                      return _productCardShimmer();
                    }
                    final model = data[index];
                    return CatalogGridCard(
                      imageUrl: model.displayImageUrl,
                      title: model.itemName ?? "",
                      priceText: "₹ ${model.price ?? 0}",
                      brand: model.brandName,
                      category: model.category,
                      subCategory: model.subCategory,
                      onTap: () => _openProductDetail(model),
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

  Widget _productGridShimmer() {
    return GridView.builder(
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, __) => _productCardShimmer(),
    );
  }

  Widget _productCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminSubCategoryList() {
    return Obx(() {
      if (controller.isGetSubCategory.value &&
          controller.subCategoryListData.isEmpty) {
        return _productGridShimmer();
      }

      final items = controller.subCategoryListData;
      if (items.isEmpty) {
        return Center(
          child: CommonText(
            text: "No Sub Category Found",
            fontFamily: FontFamily.poppinsSemiBold,
            color: Colors.grey,
          ),
        );
      }

      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 90),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return CatalogGridCard(
            imageUrl: item.imageUrl,
            title: item.subCategoryName ?? "--",
            showDetails: false,
            onTap: () => controller.onSubCategoryChanged(item),
          );
        },
      );
    });
  }

  String _productsTitle(
    CategoryListData? category,
    BranddData? brand,
    SubCategoryListData? subCategory,
  ) {
    final parts = [
      if (brand?.brandName != null) brand!.brandName!,
      if (category?.categoryName != null) category!.categoryName!,
      if (subCategory?.subCategoryName != null) subCategory!.subCategoryName!,
    ];
    if (parts.isEmpty) return "Products";
    return parts.join(" • ");
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
        borderRadius: BorderRadius.circular(14),
        border: selected
            ? Border.all(color: AppColors.brandRed.withOpacity(0.35))
            : null,
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
          Expanded(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
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
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
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
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 28,
              height: 28,
              color: const Color(0xffF8F8F8),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
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
