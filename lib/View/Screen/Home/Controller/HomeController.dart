import 'dart:async';
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
import 'package:saral/View/Screen/Admin/Model/team_member_model.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_gst_model.dart';

import 'package:saral/View/Screen/ProductDetail/Model/sub_category_detail_args.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import '../../../../Common/Global.dart';
import '../Model/off_image_model.dart';

class HomeController extends GetxController {
  final CarouselSliderController carouselController =
  CarouselSliderController();
  RxInt selectedBrand = 0.obs;
  RxInt activeIndex = 0.obs;
  RxList<CategoryListData> categoryListData = <CategoryListData>[].obs;
  RxList<BranddData> brandListData = <BranddData>[].obs;
  RxList<SubCategoryListData> subCategoryListData = <SubCategoryListData>[].obs;
  Rx<CategoryListData?> selectedCategory = Rx<CategoryListData?>(null);
  Rx<BranddData?> selectedBrandData = Rx<BranddData?>(null);
  Rx<SubCategoryListData?> selectedSubCategory = Rx<SubCategoryListData?>(null);
  RxBool isGetCategory = false.obs;
  RxBool isGetBrand = false.obs;
  RxBool isGetSubCategory = false.obs;
  final RxList<TeamMemberData> teamMembers = <TeamMemberData>[].obs;
  final RxBool isTeamMembersLoading = false.obs;
  /// VIEW ALL → full-screen brands / categories grid
  RxBool showAllCategories = false.obs;
  RxBool showAllBrands = false.obs;
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
  Timer? _searchDebounce;

  bool get hideHomeBanner =>
      isCatalogFullScreen.value ||
      selectedBrandData.value != null ||
      selectedCategory.value != null ||
      selectedSubCategory.value != null ||
      showAllCategories.value ||
      showAllBrands.value ||
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
    // Search results come from API (`SearchText`); keep list as returned.
    return itemList.toList();
  }

  void onProductSearch(String value) {
    productSearchQuery.value = value;
    _searchDebounce?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      itemListApi(force: true);
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (isClosed) return;
      if (productSearchQuery.value.trim() != query) return;
      itemListApi(force: true);
    });
  }

  void submitProductSearch() {
    _searchDebounce?.cancel();
    itemListApi(force: true);
  }

  void clearProductSearch() {
    _searchDebounce?.cancel();
    productSearchController.clear();
    productSearchQuery.value = '';
    itemListApi(force: true);
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
    clearProductSearch();
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
    if (GetStorageData.readBoolean(GetStorageData.isCustomer)) {
      isTeamMembersLoading.value = true;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final isCustomer = GetStorageData.readBoolean(GetStorageData.isCustomer);
    if (isCustomer) {
      fetchTeamMembers();
    }
    apiOfferImageMessage();
    await Future.wait([
      loadGstTaxList(),
      loadBrandListIfNeeded(),
      getCategoryList(),
    ]);
    await getSubCategoryList(
      brandId: selectedBrandData.value?.brandID,
      categoryId: selectedCategory.value?.categoryID,
    );
    await itemListApi(force: true);
  }

  Future<void> fetchTeamMembers() async {
    isTeamMembersLoading.value = true;
    try {
      final token = GetStorageData.readString(GetStorageData.token);
      final response = await _apiService.getRequest(
        ApiConstant.getTeamMembers,
        headers: {
          "Authorization": "Bearer $token",
          "accept": "*/*",
        },
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final model = TeamMemberListModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        teamMembers.value = model.data ?? [];
      }
    } catch (e) {
      log('fetchTeamMembers error: $e');
    } finally {
      isTeamMembersLoading.value = false;
    }
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
    _searchDebounce?.cancel();
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
      if (!showAllBrands.value && !showAllCategories.value) {
        itemListApi(loadMore: true);
      }
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
    await getCategoryList(brandId: selectedBrandData.value?.brandID);
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

  Future<void> getCategoryList({int? brandId, bool showLoader = false}) async {
    try {
      isGetCategory.value = true;
      if (showLoader && Get.context != null) {
        CommonLoader.show(Get.context!);
      }
      final companyToken = GetStorageData.readString(
        GetStorageData.token,
      );
      var url = ApiConstant.getCategoryList;
      if (brandId != null) {
        url += "?BrandId=$brandId";
      }
      var response = await _apiService.getRequest(
        url,
        headers: {"Authorization": "Bearer $companyToken"},
      );
      print("dashboard Element-----${response.data}");
      if (response.statusCode == 200 && response.data is Map) {
        final getCategory = CategoryListModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        final list = getCategory.data ?? [];
        if (list.isNotEmpty || brandId == null) {
          categoryListData.value = list;
        }
      }
    } catch (e) {
      print("Api Error ---$e");
    } finally {
      isGetCategory.value = false;
      if (showLoader && Get.context != null) {
        CommonLoader.hide();
      }
    }
  }

  Future<void> getSubCategoryList({int? categoryId, int? brandId}) async {
    try {
      isGetSubCategory.value = true;
      final token = GetStorageData.readString(GetStorageData.token);
      var url = ApiConstant.getSubCategoryList;
      final params = <String>[];
      if (categoryId != null) params.add("CategoryId=$categoryId");
      if (brandId != null) params.add("BrandId=$brandId");
      if (params.isNotEmpty) {
        url += "?${params.join("&")}";
      }
      final response = await _apiService.getRequest(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final model = SubCategoryListModel.fromJson(response.data);
        subCategoryListData.value = model.data ?? [];
      }
    } catch (e) {
      log('getSubCategoryList error: $e');
      subCategoryListData.clear();
    } finally {
      isGetSubCategory.value = false;
    }
  }

  void _showAppLoader() {
    final context = Get.context;
    if (context != null) {
      CommonLoader.show(context);
    }
  }

  void _hideAppLoader() {
    CommonLoader.hide();
  }

  void _resetPaging() {
    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();
  }

  Future<void> onBrandChanged(BranddData? value) async {
    if (value == null) return;

    showAllBrands.value = false;
    showAllCategories.value = false;
    selectedBrandData.value = value;
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    subCategoryListData.clear();
    _resetPaging();
    isItemListLoading.value = false;

    _showAppLoader();
    try {
      final isCustomer = GetStorageData.readBoolean(GetStorageData.isCustomer);
      if (!isCustomer && value.brandID != null) {
        await getCategoryList(brandId: value.brandID);
      }
      if (categoryListData.isEmpty) {
        await getCategoryList();
      }
      await itemListApi(force: true);
    } finally {
      _hideAppLoader();
    }
  }

  Future<void> clearBrandSelection() async {
    selectedBrandData.value = null;
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    showAllBrands.value = false;
    showAllCategories.value = false;
    categoryListData.clear();
    subCategoryListData.clear();
    _resetPaging();
    isItemListLoading.value = false;

    _showAppLoader();
    try {
      await getBrandList();
      await getCategoryList();
      await getSubCategoryList();
      await itemListApi(force: true);
    } finally {
      _hideAppLoader();
    }
  }

  Future<void> onCategoryChanged(CategoryListData? value) async {
    if (value == null) return;
    if (selectedCategory.value?.categoryID != null &&
        value.categoryID != null &&
        selectedCategory.value?.categoryID == value.categoryID) {
      return;
    }

    showAllCategories.value = false;
    selectedCategory.value = value;
    selectedSubCategory.value = null;
    subCategoryListData.clear();
    isItemListLoading.value = false;
    update();

    try {
      await getSubCategoryList(
        categoryId: value.categoryID,
        brandId: selectedBrandData.value?.brandID,
      );
      await itemListApi(force: true);
    } finally {
      update();
    }
  }

  Future<void> onSubCategoryChanged(
    SubCategoryListData? value, {
    bool navigateToDetail = true,
  }) async {
    if (value == null) return;

    _showAppLoader();
    List<ItemListData> loadedItems = [];
    try {
      selectedSubCategory.value = value;
      _resetPaging();
      isItemListLoading.value = true;
      await itemListApi(force: true);

      loadedItems = itemList
          .map((e) => _ensureSubCategory(e, value.subCategoryName))
          .toList();

      if (loadedItems.isEmpty) {
        selectedSubCategory.value = null;
        itemList.clear();
        return;
      }

      if (navigateToDetail) {
        selectedSubCategory.value = null;
        itemList.clear();
      } else {
        itemList.value = loadedItems;
      }
    } finally {
      isItemListLoading.value = false;
      _hideAppLoader();
    }

    if (loadedItems.isEmpty || !navigateToDetail) return;

    await Get.toNamed(
      AppRoutes.subCategoryDetailScreen,
      arguments: SubCategoryDetailArgs(
        subCategory: value,
        items: loadedItems,
      ),
    );
  }

  ItemListData _ensureSubCategory(ItemListData item, String? subCategoryName) {
    final name = subCategoryName?.trim();
    if (name != null &&
        name.isNotEmpty &&
        (item.subCategory == null || item.subCategory!.trim().isEmpty)) {
      item.subCategory = name;
    }
    return item;
  }

  Future<void> clearSubCategorySelection() async {
    selectedSubCategory.value = null;
    itemList.clear();
    _resetPaging();
    isItemListLoading.value = false;
  }

  void openAllBrands() {
    selectedBrandData.value = null;
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    showAllCategories.value = false;
    showAllBrands.value = true;
  }

  void closeAllBrands() {
    showAllBrands.value = false;
  }

  void openAllCategories() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    showAllCategories.value = true;
  }

  void closeAllCategories() {
    showAllCategories.value = false;
  }

  Future<void> clearCategorySelection() async {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    showAllCategories.value = false;
    subCategoryListData.clear();
    _resetPaging();
    isItemListLoading.value = false;

    _showAppLoader();
    try {
      if (selectedBrandData.value?.brandID != null) {
        await getCategoryList(brandId: selectedBrandData.value!.brandID);
      } else {
        await getSubCategoryList();
      }
      await itemListApi(force: true);
    } finally {
      _hideAppLoader();
    }
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

  Future<void> itemListApi({bool loadMore = false, bool force = false}) async {
    if (_usesPagingApi) {
      if (loadMore) {
        if (!hasMoreData.value || isLoadingMore.value || isItemList.value) {
          return;
        }
      } else if (isItemListLoading.value && !force) {
        return;
      }
    } else if (isItemListLoading.value && !force) {
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
      final subCategoryId = selectedSubCategory.value?.subCategoryID;
      if (subCategoryId != null) {
        url += "&SubCategoryId=$subCategoryId";
      }
      final searchText = productSearchQuery.value.trim();
      if (searchText.isNotEmpty) {
        url += "&SearchText=${Uri.encodeQueryComponent(searchText)}";
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
            brandName: e.brandName,
            category: e.category,
            subCategory: e.subCategory,
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
