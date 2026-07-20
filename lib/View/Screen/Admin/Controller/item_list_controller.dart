import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_catefory_brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_gst_model.dart';

class ItemListController extends GetxController {
  final ApiService _apiService = ApiService();

  final selectedCategory = CategoryBrandData().obs;
  final selectedBrand = BranddData().obs;
  final filteredCategories = <CategoryBrandData>[].obs;
  final filteredBrands = <BranddData>[].obs;
  List<BranddData> categoryWiseBrandList = [];

  final itemList = <ItemListData>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMoreData = true.obs;
  final page = 1.obs;
  final int pageSize = 20;

  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  String get _token =>
      GetStorageData.readString(GetStorageData.token) ?? '';

  bool get hasFilters =>
      selectedCategory.value.categoryID != null ||
      selectedBrand.value.brandID != null;

  bool get _usesPaging =>
      selectedCategory.value.categoryID == null &&
      selectedBrand.value.brandID == null;

  List<ItemListData> get displayedItems {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return itemList.toList();
    return itemList
        .where((e) => (e.itemName ?? '').toLowerCase().contains(q))
        .toList();
  }

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

  Future<void> _bootstrap() async {
    await _loadGstTaxList();
    ensureFilterListsLoaded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemListApi();
    });
  }

  Future<void> _loadGstTaxList() async {
    if (ApiConstant.gstList.isNotEmpty) return;
    try {
      final response = await _apiService.getRequest(
        ApiConstant.getGstTaxList,
        headers: {
          "Authorization": "Bearer $_token",
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
      log('ItemList loadGstTaxList error: $e');
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!_usesPaging) return;
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      itemListApi(loadMore: true);
    }
  }

  void onItemSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> ensureFilterListsLoaded() async {
    final futures = <Future<void>>[];
    if (ApiConstant.categoryBrandList.isEmpty) {
      futures.add(getCategoryListApi());
    }
    if (ApiConstant.brandList.isEmpty) {
      futures.add(getBrandListApi());
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
    filteredCategories.value = List.from(ApiConstant.categoryBrandList);
    if (selectedCategory.value.categoryID == null) {
      filteredBrands.value = List.from(ApiConstant.brandList);
    }
  }

  Future<void> getCategoryListApi() async {
    try {
      final response = await _apiService.getRequest(
        ApiConstant.getCategoryList,
        headers: {"Authorization": "Bearer $_token"},
      );
      if (response.statusCode == 200) {
        final model = GetCategoryBrandListModel.fromJson(response.data);
        ApiConstant.categoryBrandList = model.data ?? [];
        filteredCategories.value = List.from(ApiConstant.categoryBrandList);
      }
    } catch (e) {
      log('ItemList getCategoryListApi error: $e');
    }
  }

  Future<void> getBrandListApi() async {
    try {
      final response = await _apiService.getRequest(
        ApiConstant.getBrandList,
        headers: {"Authorization": "Bearer $_token"},
      );
      if (response.statusCode == 200) {
        final model = GetBranddListModel.fromJson(response.data);
        ApiConstant.brandList = model.data ?? [];
        filteredBrands.value = List.from(ApiConstant.brandList);
      }
    } catch (e) {
      log('ItemList getBrandListApi error: $e');
    }
  }

  Future<void> getBrandListByCategoryApi(int categoryId) async {
    try {
      final response = await _apiService.getRequest(
        '${ApiConstant.getBrandList}?CategoryId=$categoryId',
        headers: {"Authorization": "Bearer $_token"},
      );
      if (response.statusCode == 200) {
        final model = GetBranddListModel.fromJson(response.data);
        categoryWiseBrandList = model.data ?? [];
        filteredBrands.value = List.from(categoryWiseBrandList);
      }
    } catch (e) {
      log('ItemList getBrandListByCategoryApi error: $e');
    }
  }

  void categoryFilter(String query) {
    final source = ApiConstant.categoryBrandList;
    if (query.trim().isEmpty) {
      filteredCategories.value = List.from(source);
    } else {
      final q = query.toLowerCase();
      filteredCategories.value = source
          .where((c) => (c.categoryName ?? '').toLowerCase().contains(q))
          .toList();
    }
  }

  void brandFilter(String query) {
    final source = selectedCategory.value.categoryID != null
        ? categoryWiseBrandList
        : ApiConstant.brandList;
    if (query.trim().isEmpty) {
      filteredBrands.value = List.from(source);
    } else {
      final q = query.toLowerCase();
      filteredBrands.value = source
          .where((b) => (b.brandName ?? '').toLowerCase().contains(q))
          .toList();
    }
  }

  Future<void> selectCategory(CategoryBrandData category) async {
    selectedCategory.value = category;
    selectedBrand.value = BranddData();
    if (category.categoryID != null) {
      await getBrandListByCategoryApi(category.categoryID!);
    }
    await itemListApi();
  }

  Future<void> selectBrand(BranddData brand) async {
    selectedBrand.value = brand;
    await itemListApi();
  }

  Future<void> clearCategorySelection() async {
    selectedCategory.value = CategoryBrandData();
    selectedBrand.value = BranddData();
    categoryWiseBrandList = [];
    filteredBrands.value = List.from(ApiConstant.brandList);
    await itemListApi();
  }

  Future<void> clearBrandSelection() async {
    selectedBrand.value = BranddData();
    await itemListApi();
  }

  Future<void> resetFilters() async {
    selectedCategory.value = CategoryBrandData();
    selectedBrand.value = BranddData();
    categoryWiseBrandList = [];
    filteredBrands.value = List.from(ApiConstant.brandList);
    searchController.clear();
    searchQuery.value = '';
    await itemListApi();
  }

  Future<void> itemListApi({bool loadMore = false}) async {
    if (_usesPaging) {
      if (loadMore) {
        if (!hasMoreData.value || isLoadingMore.value || isLoading.value) {
          return;
        }
      } else if (isLoading.value) {
        return;
      }
    } else if (isLoading.value) {
      return;
    }

    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        page.value = 1;
        hasMoreData.value = true;
        itemList.clear();
      }

      final categoryId = selectedCategory.value.categoryID;
      final brandId = selectedBrand.value.brandID;

      if (categoryId != null) {
        // Full report fields from HomeController ItemList API
        final url = "${ApiConstant.getItemList}?Categoryid=$categoryId";
        final response = await _apiService.getRequest(
          url,
          headers: {"Authorization": "Bearer $_token"},
        );
        final model = GetReportItemListModel.fromJson(response.data);
        if (model.statusCode == 200) {
          var list = model.data ?? [];
          if (brandId != null) {
            list = list.where((e) => e.brandID == brandId).toList();
          }
          list.sort((a, b) => (a.itemName ?? '')
              .toLowerCase()
              .compareTo((b.itemName ?? '').toLowerCase()));
          itemList.value = list;
          hasMoreData.value = false;
        }
      } else if (brandId != null) {
        final url =
            "${ApiConstant.GetItemListByBrandandCategory}?BrandId=$brandId";
        final response = await _apiService.getRequest(
          url,
          headers: {"Authorization": "Bearer $_token"},
        );
        final model = GetItemListModel.fromJson(
          _normalizePagingResponse(response.data),
        );
        if (model.statusCode == 200) {
          itemList.value = (model.data ?? []).map(_mapItemData).toList()
            ..sort((a, b) => (a.itemName ?? '')
                .toLowerCase()
                .compareTo((b.itemName ?? '').toLowerCase()));
          hasMoreData.value = false;
        }
      } else {
        final url =
            "${ApiConstant.getItemListByBrandAndCategoryPagingPageSize6}?PageNumber=${page.value}&PageSize=$pageSize";
        final response = await _apiService.getRequest(
          url,
          headers: {"Authorization": "Bearer $_token"},
        );
        final model = GetItemListModel.fromJson(
          _normalizePagingResponse(response.data),
        );
        if (model.statusCode == 200) {
          final mapped = (model.data ?? []).map(_mapItemData).toList();
          if (loadMore) {
            itemList.addAll(mapped);
          } else {
            itemList.value = mapped;
          }
          _updateHasMorePages(response.data, mapped.length);
          if (hasMoreData.value) {
            page.value++;
          }
        }
      }
    } catch (e) {
      log('ItemList itemListApi error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  ItemListData _mapItemData(ItemData e) {
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
  }

  void _updateHasMorePages(dynamic responseData, int fetchedCount) {
    if (fetchedCount < pageSize) {
      hasMoreData.value = false;
      return;
    }
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final totalPages = data['totalPages'] ?? data['TotalPages'];
        final currentPage = data['pageNumber'] ??
            data['PageNumber'] ??
            data['currentPage'] ??
            page.value;
        if (totalPages is int && currentPage is int) {
          hasMoreData.value = currentPage < totalPages;
          return;
        }
      }
    }
    hasMoreData.value = fetchedCount >= pageSize;
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
