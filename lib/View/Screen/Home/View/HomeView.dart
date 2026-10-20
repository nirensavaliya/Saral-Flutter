import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Model/team_member_model.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/catalog_grid_card.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/selectable_product_list.dart';
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
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.hideHomeBanner ||
                  controller.showProductSearchField.value) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ourTeamSection(controller),
                  _ourBrandAutoScroll(controller),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _catalogTopHeader(controller),
            ),
            Obx(() {
              if (controller.showProductSearchField.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _customerCatalogFilters(controller),
              );
            }),
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
                    controller.selectedBrandData.value == null &&
                    !controller.showProductSearchField.value) {
                  return _allBrandsGrid(controller);
                }
                if (controller.showAllCategories.value &&
                    controller.selectedCategory.value == null &&
                    !controller.showProductSearchField.value) {
                  return _allCategoriesGrid(controller);
                }
                return _customerItemListPanel(controller);
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

      final selectedName = [
        if (brand != null) brand.brandName,
        if (selected != null) selected.categoryName,
        if (sub != null) sub.subCategoryName,
      ].whereType<String>().where((e) => e.trim().isNotEmpty).join(" • ");

      final headerTitle = selectedName.isNotEmpty
          ? selectedName
          : (showAll ? "Category" : "Products");

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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(width: 8),
          _homeHeaderIcons(controller),
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

  Widget _customerCatalogFilters(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customerBrandDropdown(controller),
        const SizedBox(height: 8),
        _customerCategoryDropdown(controller),
      ],
    );
  }

  Widget _customerBrandDropdown(HomeController controller) {
    return Obx(() {
      final selected = controller.selectedBrandData.value;
      final brands = controller.brandListData;
      BranddData? selectedInList;
      if (selected != null) {
        for (final item in brands) {
          if (item.brandID == selected.brandID) {
            selectedInList = item;
            break;
          }
        }
      }
      return _filterDropdownCard(
        selected: selected != null,
        isLoading: controller.isGetBrand.value && brands.isEmpty,
        loadingText: 'Loading brands...',
        child: DropdownButtonFormField<BranddData>(
          value: selectedInList,
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
        onClear: selected != null ? controller.clearBrandSelection : null,
      );
    });
  }

  Widget _customerCategoryDropdown(HomeController controller) {
    return Obx(() {
      final selected = controller.selectedCategory.value;
      final categories = controller.categoryListData;
      CategoryListData? selectedInList;
      if (selected != null) {
        for (final item in categories) {
          if (item.categoryID == selected.categoryID) {
            selectedInList = item;
            break;
          }
        }
      }
      return _filterDropdownCard(
        selected: selected != null,
        isLoading: controller.isGetCategory.value && categories.isEmpty,
        loadingText: 'Loading categories...',
        child: DropdownButtonFormField<CategoryListData>(
          value: selectedInList,
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
        onClear: selected != null ? controller.clearCategorySelection : null,
      );
    });
  }

  Widget _ourBrandAutoScroll(HomeController controller) {
    return Obx(() {
      final loading =
          controller.isGetBrand.value && controller.brandListData.isEmpty;
      final brands = controller.brandListData.toList();
      if (!loading && brands.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "Our Brands",
              fontFamily: FontFamily.poppinsBold,
              fontSize: 16,
              color: AppColors.black,
            ),
            const SizedBox(height: 6),
            if (loading)
              _ourTeamShimmer()
            else
              _AutoScrollBrandRow(brands: brands),
          ],
        ),
      );
    });
  }

  Widget _ourTeamSection(HomeController controller) {
    return Obx(() {
      final isLoading = controller.isTeamMembersLoading.value;
      final members = controller.teamMembers.take(8).toList();
      if (!isLoading && members.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CommonText(
                    text: "About Us",
                    fontFamily: FontFamily.poppinsBold,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                if (!isLoading)
                  GestureDetector(
                    onTap: () =>
                        Get.toNamed(AppRoutes.customerTeamMembersScreen),
                    child: CommonText(
                      text: "See All",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 13,
                      color: AppColors.brandRed,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (isLoading && members.isEmpty)
              _ourTeamShimmer()
            else
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _teamAvatarChip(members[index]);
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _ourTeamShimmer() {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: SizedBox(
            width: 72,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F3F8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 8,
                  width: 48,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _teamAvatarChip(TeamMemberData member) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.brandRed, width: 2),
            ),
            child: ClipOval(
              child: _teamMemberPhoto(member.displayImage, size: 59),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.name ?? "--",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamMemberPhoto(String? image, {double size = 56}) {
    final placeholder = CatalogImagePlaceholder(
      width: size,
      height: size,
      showLabel: false,
    );
    if (image == null || image.trim().isEmpty) return placeholder;
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    try {
      final raw = image.contains(',') ? image.split(',').last : image;
      return Image.memory(
        base64Decode(raw),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } catch (_) {
      return placeholder;
    }
  }

  Widget _homeHeaderIcons(HomeController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _homeFilterIcon(controller),
        const SizedBox(width: 6),
        // _homeBrandIcon(controller),
      ],
    );
  }

  Widget _customerFilterDropdowns(HomeController controller) {
    return Column(
      children: [
        Obx(() {
          final selected = controller.selectedBrandData.value;
          final brands = controller.brandListData;
          BranddData? selectedInList;
          if (selected != null) {
            for (final item in brands) {
              if (item.brandID == selected.brandID) {
                selectedInList = item;
                break;
              }
            }
          }
          return _filterDropdownCard(
            selected: selected != null,
            isLoading: controller.isGetBrand.value && brands.isEmpty,
            loadingText: 'Loading brands...',
            child: DropdownButtonFormField<BranddData>(
              value: selectedInList,
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
          CategoryListData? selectedInList;
          if (selected != null) {
            for (final item in categories) {
              if (item.categoryID == selected.categoryID) {
                selectedInList = item;
                break;
              }
            }
          }
          return _filterDropdownCard(
            selected: selected != null,
            isLoading:
                controller.isGetCategory.value && categories.isEmpty,
            loadingText: 'Loading categories...',
            child: DropdownButtonFormField<CategoryListData>(
              value: selectedInList,
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
      ],
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
            : Border.all(color: Colors.grey.shade300),
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
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => controller.submitProductSearch(),
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

      final selected = controller.selectedBrandData.value;
      final brands = _withSelectedFirst(
        controller.brandListData.toList(),
        (item) => _isSameBrand(selected, item),
      );
      if (brands.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 78,
        child: ListView.separated(
          key: ValueKey(
            'brands-${selected?.brandID}-${selected?.brandName}',
          ),
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: brands.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            final item = brands[index];
            return _circleChip(
              imageUrl: item.imageUrl,
              title: item.brandName ?? "",
              isSelected: _isSameBrand(selected, item),
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
          isSelected:
              controller.selectedCategory.value?.categoryID == item.categoryID,
          onTap: () => controller.onCategoryChanged(item),
        );
      },
    );
  }

  Widget _categoriesSection(HomeController controller) {
    return Obx(() {
      final selected = controller.selectedCategory.value;
      final isLoading = selected == null &&
          controller.isGetCategory.value &&
          controller.categoryListData.isEmpty;

      final categories = _withSelectedFirst(
        controller.categoryListData.toList(),
        (item) => _isSameCategory(selected, item),
      );
      if (!isLoading && categories.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: "Category",
            fontFamily: FontFamily.poppinsBold,
            fontSize: 16,
            color: AppColors.black,
          ),
          const SizedBox(height: 4),
          if (isLoading)
            _horizontalChipShimmer()
          else
            SizedBox(
              height: 78,
              child: ListView.separated(
                key: ValueKey(
                  'categories-${selected?.categoryID}-${selected?.categoryName}',
                ),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return _circleChip(
                    imageUrl: item.imageUrl,
                    title: item.categoryName ?? "",
                    isSelected: _isSameCategory(selected, item),
                    onTap: () => controller.onCategoryChanged(item),
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _customerItemListPanel(HomeController controller) {
    if (controller.isItemListLoading.value && controller.itemList.isEmpty) {
      return _itemListShimmer();
    }
    final data = controller.displayedProductItems;
    final searching = controller.showProductSearchField.value;
    final hasQuery = controller.productSearchQuery.value.trim().isNotEmpty;
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
                  child: _variantItemImage(item),
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

  Widget _variantItemImage(ItemListData item) {
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

  Widget _itemListShimmer() {
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
                        if (canShowPrice) ...[
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
                                    border: Border.all(
                                        color: Colors.grey.shade300),
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
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
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

  List<T> _withSelectedFirst<T>(
    List<T> items,
    bool Function(T item) isSelected,
  ) {
    final index = items.indexWhere(isSelected);
    if (index <= 0) return items;
    final selected = items.removeAt(index);
    items.insert(0, selected);
    return items;
  }

  bool _isSameBrand(BranddData? selected, BranddData item) {
    if (selected == null) return false;
    if (selected.brandID != null &&
        item.brandID != null &&
        selected.brandID == item.brandID) {
      return true;
    }
    final selectedName = selected.brandName?.trim().toLowerCase() ?? "";
    final itemName = item.brandName?.trim().toLowerCase() ?? "";
    return selectedName.isNotEmpty && selectedName == itemName;
  }

  bool _isSameCategory(CategoryListData? selected, CategoryListData item) {
    if (selected == null) return false;
    if (selected.categoryID != null &&
        item.categoryID != null &&
        selected.categoryID == item.categoryID) {
      return true;
    }
    final selectedName = selected.categoryName?.trim().toLowerCase() ?? "";
    final itemName = item.categoryName?.trim().toLowerCase() ?? "";
    return selectedName.isNotEmpty && selectedName == itemName;
  }

  Widget _circleChip({
    required String? imageUrl,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 58,
          height: 78,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                padding: EdgeInsets.all(isSelected ? 2.5 : 1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandRed
                        : const Color(0xFFD1D5DB),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFFFFE8E8)
                        : const Color(0xFFF4F3F8),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.network(
                        imageUrl ?? "",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.campaign_outlined,
                          size: 18,
                          color: isSelected
                              ? AppColors.brandRed
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: isSelected
                      ? FontFamily.poppinsSemiBold
                      : FontFamily.poppinsMedium,
                  fontSize: 10,
                  height: 1.2,
                  color: isSelected
                      ? AppColors.brandRed
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                CommonText(
                  text: message,
                  fontFamily: FontFamily.poppinsSemiBold,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AutoScrollBrandRow extends StatefulWidget {
  const _AutoScrollBrandRow({required this.brands});

  final List<BranddData> brands;

  @override
  State<_AutoScrollBrandRow> createState() => _AutoScrollBrandRowState();
}

class _AutoScrollBrandRowState extends State<_AutoScrollBrandRow> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  static const double _chipWidth = 72;
  static const double _gap = 12;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    _timer?.cancel();
    if (!mounted || widget.brands.length < 2) return;
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted || !_controller.hasClients) return;
      final cycle = widget.brands.length * (_chipWidth + _gap);
      var next = _controller.offset + 0.7;
      if (next >= cycle) next -= cycle;
      _controller.jumpTo(next);
    });
  }

  @override
  void didUpdateWidget(covariant _AutoScrollBrandRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.brands.length != widget.brands.length) {
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brands = widget.brands;
    final loop = brands.length < 2 ? brands : [...brands, ...brands];
    return SizedBox(
      height: 108,
      child: IgnorePointer(
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loop.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: _gap),
              child: _brandChip(loop[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _brandChip(BranddData brand) {
    return SizedBox(
      width: _chipWidth,
      height: 108,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4F3F8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: ClipOval(
              child: Image.network(
                brand.imageUrl ?? "",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.storefront_outlined,
                  size: 22,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            brand.brandName ?? "--",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

