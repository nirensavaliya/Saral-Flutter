import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/catalog_grid_card.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Common/Get_Storage.dart';
import '../../AddToCart/Controller/AddToCartController.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GetBuilder<HomeController>(
        builder: (HomeController controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppImages.homeHeaderBg),
                ),
              ),
              child: Column(
                children: [
                  _redTopSection(controller),
                  Expanded(child: _whiteContentSheet(controller)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _redTopSection(HomeController controller) {
    return Container(
      width: double.infinity,
      // clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: GetBuilder<AddToCartController>(
          init: Get.isRegistered<AddToCartController>()
              ? null
              : AddToCartController(),
          builder: (AddToCartController adController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                  child: Row(
                    children: [
                      Container(
                        height: 46,
                        width: 87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Image.asset(
                          AppImages.withOutBgAppLogo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            "SARAL",
                            style: TextStyle(
                              fontFamily: FontFamily.poppinsBold,
                              fontSize: 16,
                              color: AppColors.brandRed,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Material(
                            color: Colors.white.withOpacity(0.18),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Get.toNamed(AppRoutes.addToCartScreen),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),

                          if (adController.cartCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  adController.cartCount > 99 ? "99+" : adController.cartCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      if (isLoggedIn)
                        _headerIconButton(
                        icon: Icons.logout_rounded,
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  if (controller.hideHomeBanner) {
                    return const SizedBox(height: 8);
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    child: _homeBanner(controller),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _headerIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _homeBanner(HomeController controller) {
    final offerUrl = controller.offerImage.value.trim();
    if (controller.isOfferImageLoading.value) {
      return Global.bannerShimmer();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 168,
          width: double.infinity,
          child: offerUrl.isEmpty
              ? Image.asset(
                  AppImages.Img1,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  offerUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Global.bannerShimmer(withShadow: false);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppImages.Img1,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _whiteContentSheet(HomeController controller) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _catalogTopHeader(controller),
            Obx(() {
              if (controller.showProductSearchField.value) {
                return const SizedBox.shrink();
              }
              final hasBrand = controller.selectedBrandData.value != null;
              final hasCategory = controller.selectedCategory.value != null;
              final showAllBrands = controller.showAllBrands.value;
              final showAllCategories = controller.showAllCategories.value;

              if (!hasBrand && !showAllBrands) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _brandsSection(controller),
                );
              }
              if (hasBrand && !hasCategory && !showAllCategories) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _categoriesSection(controller),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 12),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis == Axis.vertical &&
                      notification is ScrollUpdateNotification &&
                      (notification.scrollDelta ?? 0) > 1) {
                    controller.expandCatalog();
                  }
                  return false;
                },
                child: Obx(() {
                if (controller.showAllBrands.value &&
                    controller.selectedBrandData.value == null) {
                  return _allBrandsGrid(controller);
                }
                if (controller.showAllCategories.value &&
                    controller.selectedCategory.value == null) {
                  return _allCategoriesGrid(controller);
                }
                final hasBrand =
                    controller.selectedBrandData.value != null;
                final hasCategory =
                    controller.selectedCategory.value != null;
                final hasSubCategory =
                    controller.selectedSubCategory.value != null;
                final showAllBrands = controller.showAllBrands.value;
                final showAllCategories = controller.showAllCategories.value;
                final searching = controller.showProductSearchField.value;
                final hasSearchQuery =
                    controller.productSearchQuery.value.trim().isNotEmpty;
                final showingSubCategories = !hasSubCategory &&
                    !(hasBrand &&
                        !hasCategory &&
                        !showAllBrands &&
                        !showAllCategories);

                if (hasBrand &&
                    !hasCategory &&
                    !showAllBrands &&
                    !showAllCategories) {
                  return _catalogMessage(
                    icon: Icons.grid_view_rounded,
                    message: "Please select category",
                  );
                }
                if (showingSubCategories) {
                  if (controller.isGetSubCategory.value &&
                      controller.subCategoryListData.isEmpty) {
                    return _subCategoryGridShimmer();
                  }
                  return _subCategoryListPanel(controller);
                }
                if ((searching || hasSubCategory) &&
                    controller.isItemListLoading.value) {
                  return _productGridShimmer();
                }
                if (!searching && !hasSubCategory) {
                  if (controller.isGetSubCategory.value &&
                      controller.subCategoryListData.isEmpty) {
                    return _subCategoryGridShimmer();
                  }
                  return _subCategoryListPanel(controller);
                }
                final data = controller.displayedProductItems;
                final isSearching = hasSearchQuery;
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

                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount:
                      data.length + (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == data.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandRed,
                            ),
                          ),
                        ),
                      );
                    }
                    return _productListCard(data[index]);
                  },
                );
              }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _catalogTopHeader(HomeController controller) {
    return Obx(() {
      final selected = controller.selectedCategory.value;
      final brand = controller.selectedBrandData.value;
      final sub = controller.selectedSubCategory.value;
      final showAll = controller.showAllCategories.value;
      final showAllBrands = controller.showAllBrands.value;
      final searching = controller.showProductSearchField.value;
      final expanded = controller.isCatalogFullScreen.value;
      final showBack = brand != null ||
          selected != null ||
          sub != null ||
          showAll ||
          showAllBrands ||
          expanded ||
          searching;

      final title = [
        if (brand != null) brand.brandName,
        if (selected != null) selected.categoryName,
        if (sub != null) sub.subCategoryName,
      ].whereType<String>().where((e) => e.trim().isNotEmpty).join(" • ");

      final headerTitle = title.isNotEmpty
          ? title
          : (showAllBrands
              ? "Brands"
              : (showAll ? "Categories" : "Brands"));

      return Row(
        children: [
          if (showBack) ...[
            Material(
              color: AppColors.brandRed.withValues(alpha: 0.1),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _onCatalogBack(controller),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: AppColors.brandRed,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          if (searching)
            Expanded(child: _homeSearchField(controller))
          else
            Expanded(
              child: CommonText(
                text: headerTitle,
                fontFamily: FontFamily.poppinsBold,
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
          const SizedBox(width: 8),
          _homeHeaderIcons(controller),
          if (!searching &&
              brand == null &&
              !showAll &&
              !showAllBrands) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => controller.openAllBrands(),
              child: CommonText(
                text: "VIEW ALL",
                fontFamily: FontFamily.jetBrainMedium,
                fontSize: 13,
                color: AppColors.brandRed,
              ),
            ),
          ],
          if (!searching &&
              brand != null &&
              selected == null &&
              !showAll) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => controller.openAllCategories(),
              child: CommonText(
                text: "VIEW ALL",
                fontFamily: FontFamily.jetBrainMedium,
                fontSize: 13,
                color: AppColors.brandRed,
              ),
            ),
          ],
        ],
      );
    });
  }

  void _onCatalogBack(HomeController controller) {
    if (controller.showProductSearchField.value) {
      controller.closeProductSearchField();
      return;
    }
    if (controller.selectedSubCategory.value != null) {
      controller.clearSubCategorySelection();
      return;
    }
    if (controller.selectedCategory.value != null) {
      controller.clearCategorySelection();
      return;
    }
    if (controller.showAllCategories.value) {
      controller.closeAllCategories();
      return;
    }
    if (controller.selectedBrandData.value != null) {
      controller.clearBrandSelection();
      return;
    }
    if (controller.showAllBrands.value) {
      controller.closeAllBrands();
      return;
    }
    controller.collapseCatalog();
  }

  Widget _homeFilterIcon(HomeController controller) {
    return Obx(() {
      final isOpen = controller.showProductSearchField.value;
      final hasQuery = controller.productSearchQuery.value.trim().isNotEmpty;
      return Material(
        color: (isOpen || hasQuery)
            ? AppColors.brandRed.withValues(alpha: 0.12)
            : const Color(0xffF8F8F8),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: controller.toggleProductSearchField,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              isOpen ? Icons.close_rounded : Icons.search_rounded,
              size: 20,
              color: (isOpen || hasQuery) ? AppColors.brandRed : Colors.black54,
            ),
          ),
        ),
      );
    });
  }

  Widget _homeBrandIcon(HomeController controller) {
    return Obx(() {
      final isActive = controller.selectedBrandData.value != null;
      return Material(
        color: isActive
            ? AppColors.brandRed.withValues(alpha: 0.12)
            : const Color(0xffF8F8F8),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _showHomeBrandSheet(controller),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.storefront_outlined,
              size: 20,
              color: isActive ? AppColors.brandRed : Colors.black54,
            ),
          ),
        ),
      );
    });
  }

  Widget _homeHeaderIcons(HomeController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _homeFilterIcon(controller),
        const SizedBox(width: 6),
        _homeBrandIcon(controller),
      ],
    );
  }

  void _showHomeBrandSheet(HomeController controller) {
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                CommonText(
                  text: "Select Brand",
                  fontFamily: FontFamily.poppinsBold,
                  fontSize: 16,
                  color: AppColors.black,
                ),
                const SizedBox(height: 14),
                _homeBrandDropdown(controller),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _homeSearchField(HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller.productSearchController,
        focusNode: controller.productSearchFocusNode,
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
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          suffixIcon: Obx(() {
            if (controller.productSearchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade500, size: 20),
              onPressed: controller.clearProductSearch,
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _homeBrandDropdown(HomeController controller) {
    return Obx(() {
      final selected = controller.selectedBrandData.value;
      final brands = controller.brandListData;
      final isLoading = controller.isGetBrand.value && brands.isEmpty;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected != null
                ? AppColors.brandRed.withValues(alpha: 0.35)
                : Colors.grey.shade200,
          ),
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
                            "Loading brands...",
                            style: TextStyle(
                              fontFamily: FontFamily.poppinsMedium,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : DropdownButtonFormField<BranddData>(
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
                          color: AppColors.brandRed.withValues(alpha: 0.85),
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
                          child: _homeDropdownItem(
                            imageUrl: item.imageUrl,
                            title: item.brandName ?? "",
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.onBrandChanged(value);
                        Get.back();
                      },
                    ),
            ),
            if (selected != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Material(
                  color: AppColors.brandRed.withValues(alpha: 0.1),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      controller.clearBrandSelection();
                      Get.back();
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
    });
  }

  Widget _homeDropdownItem({required String? imageUrl, required String title}) {
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
              color: Colors.white,
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

  Widget _allBrandsGrid(HomeController controller) {
    final brands = controller.brandListData;
    if (brands.isEmpty) {
      return Center(
        child: CommonText(
          text: "No Brand Found",
          fontFamily: FontFamily.poppinsSemiBold,
          color: Colors.grey,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      itemCount: brands.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = brands[index];
        return _circleChip(
          imageUrl: item.imageUrl,
          title: item.brandName ?? "",
          onTap: () => controller.onBrandChanged(item),
        );
      },
    );
  }

  Widget _brandsSection(HomeController controller) {
    return Obx(() {
      if (controller.isGetBrand.value && controller.brandListData.isEmpty) {
        return _horizontalChipShimmer();
      }

      final brands = controller.brandListData;
      if (brands.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: brands.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (context, index) {
            final item = brands[index];
            return _circleChip(
              imageUrl: item.imageUrl,
              title: item.brandName ?? "",
              onTap: () => controller.onBrandChanged(item),
            );
          },
        ),
      );
    });
  }

  Widget _allCategoriesGrid(HomeController controller) {
    final categories = controller.categoryListData;
    if (categories.isEmpty) {
      return Center(
        child: CommonText(
          text: "No Category Found",
          fontFamily: FontFamily.poppinsSemiBold,
          color: Colors.grey,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];
        return _circleChip(
          imageUrl: item.imageUrl,
          title: item.categoryName ?? "",
          onTap: () => controller.onCategoryChanged(item),
        );
      },
    );
  }

  Widget _categoriesSection(HomeController controller) {
    return Obx(() {
      if (controller.isGetCategory.value &&
          controller.categoryListData.isEmpty) {
        return _horizontalChipShimmer();
      }

      final categories = controller.categoryListData;
      if (categories.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 88,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (context, index) {
            final item = categories[index];
            return _circleChip(
              imageUrl: item.imageUrl,
              title: item.categoryName ?? "",
              onTap: () => controller.onCategoryChanged(item),
            );
          },
        ),
      );
    });
  }

  Widget _subCategoryListPanel(HomeController controller) {
    return Obx(() {
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
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
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

  Widget _subCategoryGridShimmer() {
    return GridView.builder(
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _productListCard(ItemListData model) {
    final typeLabel = (model.unitCode ?? "").trim().isEmpty
        ? "--"
        : model.unitCode!.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.productDetailViewScreen, arguments: model);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 160,
                child: buildCatalogNetworkImage(
                  imageUrl: model.displayImageUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: "Product Name",
                      fontFamily: FontFamily.poppinsRegular,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 4),
                    CommonText(
                      text: model.itemName ?? "--",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 16,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: "Type",
                                fontFamily: FontFamily.poppinsRegular,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: CommonText(
                                  text: typeLabel,
                                  fontFamily: FontFamily.poppinsMedium,
                                  fontSize: 14,
                                  color: AppColors.black,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: "Sale Price",
                                fontFamily: FontFamily.poppinsRegular,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: CommonText(
                                  text: "₹ ${model.price ?? 0}",
                                  fontFamily: FontFamily.poppinsBold,
                                  fontSize: 14,
                                  color: AppColors.brandRed,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _horizontalChipShimmer() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F3F8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 10, width: 48, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleChip({
    required String? imageUrl,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF4F3F8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandRed
                      : const Color(0xFFE6BDB8),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE2292E).withValues(alpha: 0.30),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.network(
                    imageUrl ?? "",
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.campaign_outlined,
                      size: 24,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.poppinsMedium,
                fontSize: 12,
                color: isSelected
                    ? AppColors.brandRed
                    : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "",
      radius: 20,
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepOrange, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.priority_high,
                color: Colors.deepOrange,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Confirm Logout",
            style: TextStyle(
              fontSize: 22,
              fontFamily: FontFamily.poppinsBold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Are you sure you want to log out of your account?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontFamily: FontFamily.poppinsRegular,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontFamily.poppinsMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandRed,
                    elevation: 4,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    await GetStorageData.removeData(GetStorageData.token);
                    await GetStorageData.removeData(GetStorageData.role);
                    await GetStorageData.removeData(
                      GetStorageData.isOtpVerified,
                    );
                    await GetStorageData.saveBoolean(
                      GetStorageData.isAdmin,
                      false,
                    );
                    await GetStorageData.saveBoolean(
                      GetStorageData.isCustomer,
                      false,
                    );
                    await GetStorageData.saveBoolean(
                      GetStorageData.isEmployee,
                      false,
                    );
                    Get.offAllNamed(AppRoutes.loginScreen);
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Yes, Logout",
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 14,
                      ),
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

  Widget _productGridShimmer() {
    return GridView.builder(
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.58,
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFDE8E8)),
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
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 14,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

