import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
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
  final HomeController controller = Get.isRegistered<HomeController>()
      ? Get.find<HomeController>()
      : Get.put(HomeController());

  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshCartCount();
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
            Obx(() {
              final selected = controller.selectedCategory.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: selected != null
                      ? Border.all(
                          color: AppColors.brandRed.withOpacity(0.35),
                        )
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
                        items: controller.categoryListData.map((item) {
                          return DropdownMenuItem<CategoryListData>(
                            value: item,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl ?? "",
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
                                    item.categoryName ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: FontFamily.poppinsMedium,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.onCategoryChanged(value);
                        },
                      ),
                    ),
                    if (selected != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Material(
                          color: AppColors.brandRed.withOpacity(0.1),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              controller.clearCategorySelection();
                            },
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
            }),
            const SizedBox(height: 14),
            Obx(() {
              final selected = controller.selectedCategory.value;
              return Row(
                children: [
                  Expanded(
                    child: CommonText(
                      text: selected == null
                          ? "Products"
                          : (selected.categoryName ?? "Products"),
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  CommonText(
                    text: controller.isItemListLoading.value
                        ? ""
                        : "${controller.itemList.length} items",
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
                final data = controller.itemList;
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        CommonText(
                          text: "No Product Found",
                          fontFamily: FontFamily.poppinsSemiBold,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount:
                      data.length + (controller.isLoadingMore.value ? 1 : 0),
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
}
