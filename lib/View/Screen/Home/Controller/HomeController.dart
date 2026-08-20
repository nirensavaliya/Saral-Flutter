import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_gst_model.dart';

import '../../../../Common/Global.dart';
import '../Model/off_image_model.dart';

class HomeController extends GetxController {
  final CarouselSliderController carouselController =
  CarouselSliderController();
  RxInt selectedBrand = 0.obs;
  RxInt activeIndex = 0.obs;
  RxList<CategoryListData> categoryListData = <CategoryListData>[].obs;
  RxList<BranddData> brandListData = <BranddData>[].obs;
  Rx<CategoryListData?> selectedCategory = Rx<CategoryListData?>(null);
  Rx<BranddData?> selectedBrandData = Rx<BranddData?>(null);
  RxBool isGetCategory = false.obs;
  RxBool isGetBrand = false.obs;
  /// VIEW ALL → full-screen categories grid
  RxBool showAllCategories = false.obs;
  final ApiService _apiService = ApiService();
  RxBool isItemList = false.obs;
  RxInt selectedIndex = 0.obs;
  RxInt page = 1.obs;
  final int pageSize = 10;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  ScrollController scrollController = ScrollController();
  bool get _usesPagingApi => true;
  // Rx<CategoryBrandData> selectedCategoryBrandData = Rx<CategoryBrandData>(CategoryBrandData());
  var itemList = <ItemListData>[].obs;
  var isItemListLoading = false.obs;
  final productSearchQuery = ''.obs;
  final TextEditingController productSearchController = TextEditingController();
  final FocusNode productSearchFocusNode = FocusNode();
  final showProductSearchField = false.obs;
  final isCatalogFullScreen = false.obs;

  bool get hideHomeBanner =>
      isCatalogFullScreen.value ||
      selectedCategory.value != null ||
      showAllCategories.value ||
      showProductSearchField.value;

  void expandCatalog() {
    if (!isCatalogFullScreen.value) {
      isCatalogFullScreen.value = true;
    }
  }

  void collapseCatalog() {
    isCatalogFullScreen.value = false;
    closeProductSearchField();
  }

  List<ItemListData> get displayedProductItems {
    final q = productSearchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return itemList.toList();
    return itemList
        .where((e) => (e.itemName ?? '').toLowerCase().contains(q))
        .toList();
  }

  void onProductSearch(String value) {
    productSearchQuery.value = value;
  }

  void clearProductSearch() {
    productSearchController.clear();
    productSearchQuery.value = '';
  }

  void toggleProductSearchField() {
    if (!showProductSearchField.value) {
      expandCatalog();
      showProductSearchField.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isClosed) productSearchFocusNode.requestFocus();
      });
      return;
    }
    closeProductSearchField();
  }

  void closeProductSearchField() {
    showProductSearchField.value = false;
    productSearchFocusNode.unfocus();
  }

  final List<String> sliderImages = [
    AppImages.Img1,
    AppImages.Img2,
    AppImages.Img3,
  ];

  void changeTab(int index) {
    final bool isAdmin = GetStorageData.readBoolean(GetStorageData.isAdmin);
    final bool isEmployee =
    GetStorageData.readBoolean(GetStorageData.isEmployee);
    // Sirf customer / guest dashboard (Admin/Employee nahi)
    // index 1 = Orders, index 3 = Profile (Contact = 2 open for guest)
    final bool isCustomerFlow = !isAdmin && !isEmployee;
    if (isCustomerFlow && (index == 1 || index == 3) && !isLoggedIn) {
      Global.showLoginRequiredDialog();
      return;
    }
    selectedIndex.value = index;
  }

  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  // void onCategoryChanged(CategoryListData? value) {
  //   if (value == null) return;
  //
  //   selectedCategory.value = value;
  //
  //   // Reset pagination
  //   page.value = 1;
  //   hasMoreData.value = true;
  //   isLoadingMore.value = false;
  //   itemListData.clear();
  //
  //   getCategoryProduct(value.categoryID!);
  // }


  @override
  void onInit() {
    super.onInit();
    // getCategoryList();
    // getCategoryListPagination();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await loadGstTaxList();
    apiOfferImageMessage();
    getCategoryList();
    loadBrandListIfNeeded();
    itemListApi();
  }

  Future<void> loadGstTaxList() async {
    if (ApiConstant.gstList.isNotEmpty) return;
    try {
      final token = GetStorageData.readString(GetStorageData.token);
      final response = await _apiService.getRequest(
        ApiConstant.getGstTaxList,
        headers: {
          "Authorization": "Bearer $token",
          "accept": "*/*",
        },
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final model = GetGstTaxListModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        if (model.statusCode == 200 || model.statusCode == null) {
          ApiConstant.gstList = model.data ?? [];
        }
      }
    } catch (e) {
      log('loadGstTaxList error: $e');
    }
  }
  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    productSearchController.dispose();
    productSearchFocusNode.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (!scrollController.positions.any((p) => p.hasContentDimensions)) {
      return;
    }

    if (scrollController.position.pixels > 8) {
      expandCatalog();
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      itemListApi(loadMore: true);
    }
  }

  Future<void> getBrandList() async {
    if (isGetBrand.value) return;
    try {
      isGetBrand.value = true;
      final token = GetStorageData.readString(GetStorageData.token);
      final response = await _apiService.getRequest(
        ApiConstant.getBrandList,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final model = GetBranddListModel.fromJson(response.data);
        brandListData.value = model.data ?? [];
        ApiConstant.brandList = model.data ?? [];
      }
    } catch (e) {
      log('getBrandList error: $e');
    } finally {
      isGetBrand.value = false;
    }
  }

  Future<void> loadBrandListIfNeeded() async {
    if (brandListData.isNotEmpty) return;
    await getBrandList();
  }

  Future<void> loadCategoryListIfNeeded() async {
    if (categoryListData.isNotEmpty || isGetCategory.value) return;
    try {
      isGetCategory.value = true;
      final token = GetStorageData.readString(GetStorageData.token);
      final response = await _apiService.getRequest(
        ApiConstant.getCategoryList,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final getCategory = CategoryListModel.fromJson(response.data);
        categoryListData.value = getCategory.data ?? [];
      }
    } catch (e) {
      log('loadCategoryListIfNeeded error: $e');
    } finally {
      isGetCategory.value = false;
    }
  }

  Future<void> getBrandListByCategoryApi(int categoryId) async {
    try {
      isGetBrand.value = true;
      final token = GetStorageData.readString(GetStorageData.token);
      final response = await _apiService.getRequest(
        '${ApiConstant.getBrandList}?CategoryId=$categoryId',
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final model = GetBranddListModel.fromJson(response.data);
        brandListData.value = model.data ?? [];
      }
    } catch (e) {
      log('getBrandListByCategoryApi error: $e');
    } finally {
      isGetBrand.value = false;
    }
  }

  void onBrandChanged(BranddData? value) async {
    if (value == null) return;

    selectedBrandData.value = value;

    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();

    await itemListApi();
  }

  Future<void> clearBrandSelection() async {
    selectedBrandData.value = null;
    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();
    await itemListApi();
  }

  Future<void> getCategoryList() async {
    try {
      isGetCategory.value = true;
      CommonLoader.show(Get.context!);
      final companyToken = GetStorageData.readString(
        GetStorageData.token,
      );
      var response = await _apiService.getRequest(
        ApiConstant.getCategoryList,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      print("dashboard Element-----${response.data}");
      final getCategory = CategoryListModel.fromJson(response.data);
      if (response.statusCode == 200) {
        categoryListData.value = getCategory.data ?? [];
      }
    } catch (e) {
      print("Api Error ---$e");
    } finally {
      isGetCategory.value = false;
      CommonLoader.hide();
    }
  }

  void onCategoryChanged(CategoryListData? value) async {
    print("onCategoryChanged called");
    print("Category = ${value?.categoryName}");
    print("CategoryId = ${value?.categoryID}");

    if (value == null) return;

    showAllCategories.value = false;
    selectedCategory.value = value;
    selectedBrandData.value = null;

    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();

    if (value.categoryID != null) {
      await getBrandListByCategoryApi(value.categoryID!);
    }

    await itemListApi();
  }

  void openAllCategories() {
    selectedCategory.value = null;
    showAllCategories.value = true;
  }

  void closeAllCategories() {
    showAllCategories.value = false;
  }

  Future<void> clearCategorySelection() async {
    selectedCategory.value = null;
    selectedBrandData.value = null;
    showAllCategories.value = false;
    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();
    await getBrandList();
    await itemListApi();
  }

  void _updateHasMorePages(Map<String, dynamic> responseData,
      int fetchedCount) {
    final totalPages = _readPagingInt(responseData['totalPages']);
    final totalCount = _readPagingInt(responseData['totalCount']) ??
        _readPagingInt(responseData['totalRecords']) ??
        _readPagingInt(responseData['totalItems']);

    if (responseData['data'] is Map<String, dynamic>) {
      final nested = responseData['data'] as Map<String, dynamic>;
      final nestedTotalPages = _readPagingInt(nested['totalPages']);
      final nestedTotalCount = _readPagingInt(nested['totalCount']) ??
          _readPagingInt(nested['totalRecords']) ??
          _readPagingInt(nested['totalItems']);
      if (nestedTotalPages != null) {
        hasMoreData.value = page < nestedTotalPages;
      } else if (nestedTotalCount != null) {
        hasMoreData.value = itemList.length < nestedTotalCount;
      } else {
        hasMoreData.value = fetchedCount >= pageSize;
      }
    } else if (totalPages != null) {
      hasMoreData.value = page < totalPages;
    } else if (totalCount != null) {
      hasMoreData.value = itemList.length < totalCount;
    } else {
      hasMoreData.value = fetchedCount >= pageSize;
    }

    if (hasMoreData.value) {
      page.value++;
    }
  }

  int? _readPagingInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Future<void> itemListApi({bool loadMore = false}) async {
    if (_usesPagingApi) {
      if (loadMore) {
        if (!hasMoreData.value || isLoadingMore.value || isItemList.value) {
          return;
        }
      } else if (isItemListLoading.value) {
        return;
      }
    } else if (isItemListLoading.value) {
      return;
    }

    final context = Get.context;
    if (context == null) return;

    try {
      final token = GetStorageData.readString(GetStorageData.token);

      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isItemListLoading.value = true;
        page.value = 1;
        hasMoreData.value = true;
        if (_usesPagingApi) {
          itemList.clear();
        }
      }

      String url =
          "${ApiConstant.getItemListByBrandAndCategoryPagingPageSize6}"
          "?PageNumber=${page.value}&PageSize=$pageSize";
      final categoryId = selectedCategory.value?.categoryID;
      if (categoryId != null) {
        url += "&CategoryId=$categoryId";
      }
      final brandId = selectedBrandData.value?.brandID;
      if (brandId != null) {
        url += "&BrandId=$brandId";
      }

      final response = await _apiService.getRequest(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "accept": "*/*"
        },
      );

      final model = GetItemListModel.fromJson(_normalizePagingResponse(response.data));
      if (model.statusCode == 200) {
        final mapped = (model.data ?? []).map((e) {
          return ItemListData(
            itemid: e.itemid,
            itemName: e.itemName,
            unitCode: e.unitCode,
            price: e.price,
            itemImage: e.imageUrl,
            salesDiscountPER: e.salesDiscountper,
            orderQtyInterval: e.orderQtyInterval,
            gstCodeId: e.gstCodeId,
            gstTaxName: ApiConstant.gstTaxNameForCode(e.gstCodeId),
          );
        }).toList();

        if (loadMore) {
          itemList.addAll(mapped);
        } else {
          itemList.value = mapped;
        }
        _updateHasMorePages(response.data, mapped.length);
      }
    }
    catch (e) {
      log('ERROR-Something went wrong $e');
    } finally {
      isItemListLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  var offerImage = ''.obs;
  var isOfferImageLoading = true.obs;

  Future<void> apiOfferImageMessage() async {
    isOfferImageLoading.value = true;
    try {
      final companyToken = GetStorageData.readString(
        GetStorageData.token,
      );
      final response = await _apiService.getRequest(
        ApiConstant.GetOfferImage,
        headers: {"Authorization": "Bearer $companyToken"},
      );

      if (response.statusCode == 200) {
        OfferImageModel model = OfferImageModel.fromJson(response.data);

        if (model.data != null) {
          ApiConstant.offerImage = model.data!;
          offerImage.value = model.data!;
          update();
        } else {
          ApiConstant.offerImage = "";
          offerImage.value = "";
          update();
        }
      } else {
        ApiConstant.offerImage = "";
        offerImage.value = "";
        update();
      }
    } catch (_) {
      ApiConstant.offerImage = "";
      offerImage.value = "";
    } finally {
      isOfferImageLoading.value = false;
    }
  }
}


Map<String, dynamic> _normalizePagingResponse(dynamic responseData) {
  if (responseData is! Map<String, dynamic>) {
    return {};
  }
  if (responseData['data'] is List) {
    return responseData;
  }
  if (responseData['data'] is Map<String, dynamic>) {
    final nested = responseData['data'] as Map<String, dynamic>;
    final list = nested['items'] ?? nested['list'] ?? nested['data'];
    if (list is List) {
      return {...responseData, 'data': list};
    }
  }
  return responseData;
}

Widget commonTableText({String? title, bool? isLight, bool? isEnd}) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      title ?? "",
      textAlign: isEnd == true ? TextAlign.end : TextAlign.start,
      style: TextStyle(
        fontSize:16,
        color: isLight == true ? Colors.black45 : Colors.black,
        fontFamily: FontFamily.poppinsMedium,
      ),
    ),
  );
}



  // Future<void> itemListApi({bool loadMore = false}) async {
  //   if (loadMore) {
  //     if (!hasMoreData.value || isLoadingMore.value || isItemList.value) {
  //       return;
  //     }
  //   } else {
  //     if (isItemList.value) return;
  //   }
  //
  //   try {
  //     final token =
  //     GetStorageHelper.readString(GetStorageHelper.loginToken);
  //
  //     if (loadMore) {
  //       isLoadingMore.value = true;
  //     } else {
  //       isItemList.value = true;
  //
  //       if (selectedCategory.value == null) {
  //         page.value = 1;
  //         hasMoreData.value = true;
  //         itemListData.clear();
  //       }
  //     }
  //
  //     if (selectedCategory.value == null) {
  //       final response = await _apiService.getRequest(
  //         "${ApiConstant.getItemListByBrandAndCategoryPagingPageSize6}$pageSize&PageNumber=${page.value}",
  //         headers: {
  //           "Authorization": "Bearer $token",
  //         },
  //       );
  //
  //       final model = GetItemListModel.fromJson(response.data);
  //
  //       if (response.statusCode == 200) {
  //         final newData = model.data ?? [];
  //
  //         if (loadMore) {
  //           itemListData.addAll(newData);
  //         } else {
  //           itemListData.value = newData.cast<ItemListData>();
  //         }
  //
  //         if (newData.length < pageSize) {
  //           hasMoreData.value = false;
  //         } else {
  //           page.value++;
  //         }
  //       }
  //     }
  //
  //     /// ---------------- CATEGORY API ----------------
  //     else {
  //       final response = await _apiService.getRequest(
  //         "${ApiConstant.getItemList}?Categoryid=${selectedCategory.value!.categoryID}",
  //         headers: {
  //           "Authorization": "Bearer $token",
  //         },
  //       );
  //
  //       final model = GetReportItemListModel.fromJson(response.data);
  //
  //       if (model.statusCode == 200) {
  //         itemListData.value = (model.data ?? [])
  //             .map(
  //               (e) => ItemListData(
  //             itemid: e.itemid,
  //             itemName: e.itemName,
  //             unitCode: e.unitCode,
  //             price: e.price,
  //                 itemImage: e.imageFileName,
  //           ),
  //         )
  //             .toList();
  //
  //         hasMoreData.value = false;
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Item List Error : $e");
  //   } finally {
  //     isItemList.value = false;
  //     isLoadingMore.value = false;
  //   }
  // }





  // Future<void> getCategoryProduct(
  //   int categoryId, {
  //   bool isLoadMore = false,
  // }) async {
  //   if (isLoadMore && (isLoadingMore.value || !hasMoreData.value)) {
  //     return;
  //   }
  //   try {
  //     if (isLoadMore) {
  //       isLoadingMore.value = true;
  //     } else {
  //       page.value = 1;
  //       hasMoreData.value = true;
  //       isItemList.value = true;
  //       itemListData.clear();
  //     }
  //
  //     final companyToken = GetStorageHelper.readString(
  //       GetStorageHelper.loginToken,
  //     );
  //
  //     var response = await _apiService.getRequest(
  //       "${ApiConstant.getCategoryItem}"
  //       "CategoryId=$categoryId"
  //       "&PageNumber=${page.value}"
  //       "&PageSize=$pageSize",
  //       headers: {"Authorization": "Bearer $companyToken"},
  //     );
  //     print("Selected Category : $categoryId");
  //     print(
  //       "${ApiConstant.getCategoryItem}"
  //       "CategoryId=$categoryId"
  //       "&PageNumber=${page.value}"
  //       "&PageSize=$pageSize",
  //     );
  //     final model = ItemListModel.fromJson(response.data);
  //
  //     if (response.statusCode == 200) {
  //       final newData = model.data ?? [];
  //
  //       if (newData.isEmpty) {
  //         hasMoreData.value = false;
  //       } else {
  //         itemListData.addAll(newData);
  //         page.value++;
  //       }
  //     }
  //   } catch (e) {
  //     print("Category Vise Product Api---$e");
  //   } finally {
  //     isItemList.value = false;
  //     isLoadingMore.value = false;
  //   }
  // }
