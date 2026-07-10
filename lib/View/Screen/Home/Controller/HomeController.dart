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

class HomeController extends GetxController {
  final CarouselSliderController carouselController =
  CarouselSliderController();
  RxInt selectedBrand = 0.obs;
  RxInt activeIndex = 0.obs;
  RxList<CategoryListData> categoryListData = <CategoryListData>[].obs;
  Rx<CategoryListData?> selectedCategory = Rx<CategoryListData?>(null);
  RxBool isGetCategory = false.obs;
  final ApiService _apiService = ApiService();
  RxBool isItemList = false.obs;
  RxInt selectedIndex = 0.obs;
  RxInt page = 1.obs;
  final int pageSize = 6;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  ScrollController scrollController = ScrollController();
  bool get _usesPagingApi => selectedCategory.value?.categoryID == null;
  // Rx<CategoryBrandData> selectedCategoryBrandData = Rx<CategoryBrandData>(CategoryBrandData());
  var itemList = <ItemListData>[].obs;
  var isItemListLoading = false.obs;

  final List<String> sliderImages = [
    AppImages.Img1,
    AppImages.Img2,
    AppImages.Img3,
  ];

  void changeTab(int index) {
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
    itemListApi();
  }
  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    print("pixels = ${scrollController.position.pixels}");
    print("max = ${scrollController.position.maxScrollExtent}");

    if (selectedCategory.value != null) return;

    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {

      print("LOAD MORE CALLED");

      itemListApi(loadMore: true);
    }
  }

  Future<void> getCategoryList() async {
    try {
      isGetCategory.value = true;
      CommonLoader.show(Get.context!);
      final companyToken = GetStorageHelper.readString(
        GetStorageHelper.loginToken,
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

    selectedCategory.value = value;

    page.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    itemList.clear();

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

  // Future<void> getCategoryListPagination({
  //   bool isLoadMore = false,
  // }) async {
  //   if (isLoadMore) {
  //     if (isLoadingMore.value || !hasMoreData.value) return;
  //     isLoadingMore.value = true;
  //   } else {
  //     if (isItemList.value) return;
  //
  //     isItemList.value = true;
  //     page.value = 1;
  //     hasMoreData.value = true;
  //     itemListData.clear();
  //   }
  //
  //   try {
  //
  //     final token = GetStorageHelper.readString(
  //       GetStorageHelper.loginToken,
  //     );
  //
  //     final response = await _apiService.getRequest(
  //       "${ApiConstant.getItemListByBrandAndCategoryPagingPageSize6}$pageSize&PageNumber=${page.value}",
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     final model = GetReportItemListModel.fromJson(response.data);
  //
  //     final newData = model.data ?? [];
  //
  //     if (isLoadMore) {
  //       itemListData.addAll(newData);
  //     } else {
  //       itemListData.value = newData;
  //     }
  //
  //     if (newData.length < pageSize) {
  //       hasMoreData.value = false;
  //     } else {
  //       page.value++;
  //     }
  //
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     isItemList.value = false;
  //     isLoadingMore.value = false;
  //   }
  // }
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
      final token =
      GetStorageHelper.readString(GetStorageHelper.loginToken);

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

      String url;
      final bool noCategory = selectedCategory.value?.categoryID == null;

      if (noCategory) {
        url =
        "${ApiConstant.getItemListByBrandAndCategoryPagingPageSize6}?PageNumber=${page.value}&PageSize=$pageSize";
      } else {
        url =
        "${ApiConstant.getItemList}?Categoryid=${selectedCategory.value!
            .categoryID}";
      }

      final response = await _apiService.getRequest(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (noCategory) {
        final model = GetItemListModel.fromJson(_normalizePagingResponse(response.data));
        if (model.statusCode == 200) {
          final mapped = (model.data ?? []).map((e) {
            return ItemListData(
              itemid: e.itemid,
              itemName: e.itemName,
              unitCode: e.unitCode,
              price: e.price,
              itemImage: e.imageUrl,
            );
          }).toList();

          if (loadMore) {
            itemList.addAll(mapped);
          } else {
            itemList.value = mapped;
          }
          _updateHasMorePages(response.data, mapped.length);
        }
      } else {
        GetReportItemListModel model = GetReportItemListModel.fromJson(
            response.data);
        if (model.statusCode == 200) {
          itemList.value = model.data ?? [];
          itemList.sort((a, b) =>
              (a.itemName ?? '').toLowerCase().compareTo(
                  (b.itemName ?? '').toLowerCase()));
        }
      }
    }
    catch (e) {
      log('ERROR-Something went wrong $e');
    } finally {
      isItemListLoading.value = false;
      isLoadingMore.value = false;
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
