import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Service/sales_order_cart_service.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    controller.clearProductSearch();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
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
      appBar: CommonAppBar(
        title: "Product",
        showDrawer: false,
        showBackButton: Navigator.canPop(context),
        actions: [
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
            _buildSearchField(),
            const SizedBox(height: 10),
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
              final title = _productsTitle(category, brand);
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
                    text: controller.isItemListLoading.value
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
                if (controller.isItemListLoading.value) {
                  return _productGridShimmer();
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
                    return GestureDetector(
                      onTap: () => _openProductDetail(model),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: const Color(0xffF3F4F6),
                                child: Image.network(
                                  model.itemImage ?? "",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 36,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: model.itemName ?? "",
                                    fontFamily: FontFamily.poppinsSemiBold,
                                    fontSize: 13,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(height: 4),
                                  CommonText(
                                    text: "₹ ${model.price ?? 0}",
                                    fontFamily: FontFamily.poppinsBold,
                                    fontSize: 14,
                                    color: AppColors.brandRed,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  String _productsTitle(CategoryListData? category, BranddData? brand) {
    if (category != null && brand != null) {
      return "${category.categoryName} • ${brand.brandName}";
    }
    if (category != null) return category.categoryName ?? "Products";
    if (brand != null) return brand.brandName ?? "Products";
    return "Products";
  }

  Widget _buildSearchField() {
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
        controller: _searchController,
        onChanged: controller.onProductSearch,
        style: TextStyle(
          fontFamily: FontFamily.poppinsMedium,
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: "Search product...",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: FontFamily.poppinsRegular,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: Obx(() {
            if (controller.productSearchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade500, size: 20),
              onPressed: () {
                _searchController.clear();
                controller.clearProductSearch();
              },
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
}
