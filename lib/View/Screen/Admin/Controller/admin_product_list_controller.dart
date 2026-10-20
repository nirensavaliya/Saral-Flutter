import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';

class AdminProductListController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<BranddData> brandListData = <BranddData>[].obs;
  final RxList<CategoryListData> categoryListData = <CategoryListData>[].obs;
  final RxList<ItemListData> itemList = <ItemListData>[].obs;
  final Rx<BranddData?> selectedBrandData = Rx<BranddData?>(null);
  final Rx<CategoryListData?> selectedCategory = Rx<CategoryListData?>(null);

  final RxBool isGetBrand = false.obs;
  final RxBool isGetCategory = false.obs;
  final RxBool isItemListLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxInt page = 1.obs;
  final int pageSize = 10;

  final productSearchQuery = ''.obs;
  final showProductSearchField = false.obs;
  final TextEditingController productSearchController = TextEditingController();
  final FocusNode productSearchFocusNode = FocusNode();
  Timer? _searchDebounce;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
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

  Future<void> _bootstrap() async {
    await Future.wait([
      getBrandList(),
      getCategoryList(),
    ]);
    await loadItems(force: true);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (!scrollController.positions.any((p) => p.hasContentDimensions)) {
      return;
    }
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadItems(loadMore: true);
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
      }
    } catch (e) {
      log('AdminProductList getBrandList error: $e');
    } finally {
      isGetBrand.value = false;
    }
  }

  Future<void> getCategoryList({int? brandId}) async {
    try {
      isGetCategory.value = true;
      final token = GetStorageData.readString(GetStorageData.token);
      var url = ApiConstant.getCategoryList;
      if (brandId != null) {
        url += "?BrandId=$brandId";
      }
      final response = await _apiService.getRequest(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final getCategory = CategoryListModel.fromJson(response.data);
        categoryListData.value = getCategory.data ?? [];
      }
    } catch (e) {
      log('AdminProductList getCategoryList error: $e');
    } finally {
      isGetCategory.value = false;
    }
  }

  Future<void> onBrandChanged(BranddData? value) async {
    if (value == null) return;
    selectedBrandData.value = value;
    selectedCategory.value = null;
    await getCategoryList(brandId: value.brandID);
    await loadItems(force: true);
  }

  Future<void> clearBrandSelection() async {
    selectedBrandData.value = null;
    selectedCategory.value = null;
    await getCategoryList();
    await loadItems(force: true);
  }

  Future<void> onCategoryChanged(CategoryListData? value) async {
    if (value == null) return;
    selectedCategory.value = value;
    await loadItems(force: true);
  }

  Future<void> clearCategorySelection() async {
    selectedCategory.value = null;
    await loadItems(force: true);
  }

  void onProductSearch(String value) {
    productSearchQuery.value = value;
    _searchDebounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) {
      loadItems(force: true);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (isClosed) return;
      if (productSearchQuery.value.trim() != query) return;
      loadItems(force: true);
    });
  }

  void submitProductSearch() {
    _searchDebounce?.cancel();
    loadItems(force: true);
  }

  void clearProductSearch() {
    _searchDebounce?.cancel();
    productSearchController.clear();
    productSearchQuery.value = '';
    loadItems(force: true);
  }

  void toggleProductSearchField() {
    if (!showProductSearchField.value) {
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
    if (productSearchQuery.value.trim().isNotEmpty) {
      clearProductSearch();
    }
  }

  Future<void> loadItems({bool loadMore = false, bool force = false}) async {
    if (loadMore) {
      if (!hasMoreData.value || isLoadingMore.value || isItemListLoading.value) {
        return;
      }
    } else if (isItemListLoading.value && !force) {
      return;
    }

    try {
      final token = GetStorageData.readString(GetStorageData.token);
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isItemListLoading.value = true;
        page.value = 1;
        hasMoreData.value = true;
        itemList.clear();
      }

      var url =
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
      final searchText = productSearchQuery.value.trim();
      if (searchText.isNotEmpty) {
        url += "&SearchText=${Uri.encodeQueryComponent(searchText)}";
      }

      final response = await _apiService.getRequest(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "accept": "*/*",
        },
      );

      final model = GetItemListModel.fromJson(
        _normalizePagingResponse(response.data),
      );
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
    } catch (e) {
      log('AdminProductList loadItems error: $e');
    } finally {
      isItemListLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _updateHasMorePages(dynamic responseData, int fetchedCount) {
    if (responseData is! Map<String, dynamic>) {
      hasMoreData.value = fetchedCount >= pageSize;
      if (hasMoreData.value) page.value++;
      return;
    }

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
}
