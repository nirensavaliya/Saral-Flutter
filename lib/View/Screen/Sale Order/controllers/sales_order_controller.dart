import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart' hide FormData;
import 'package:intl/intl.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/CustomerDetailModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/customer_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_catefory_brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/new_serial_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/quoation_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/quotation_pdf_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/save_quotation_model.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_form_ui.dart';
import '../Service/sales_order_cart_service.dart';

class SalesOrderController extends GetxController {
  TextEditingController addDateController = TextEditingController();
  TextEditingController addSerialController = TextEditingController();
  TextEditingController addInvoiceTypeController = TextEditingController(
      text: "Bill of Supply");
  TextEditingController addCustomerNameController = TextEditingController();
  TextEditingController addGSTinController = TextEditingController();
  TextEditingController addCustomerNumberController = TextEditingController();
  TextEditingController addShippingAddressController = TextEditingController();
  TextEditingController addDeliveryDateController = TextEditingController();
  TextEditingController addPoDateController = TextEditingController();
  TextEditingController addPoNumberController = TextEditingController();
  TextEditingController addGstController = TextEditingController();
  TextEditingController addTransportController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController addRemarkController = TextEditingController();
  TextEditingController addGstTypeController = TextEditingController();
  TextEditingController itemUnitController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();
  TextEditingController itemTotalDiscountController = TextEditingController();
  TextEditingController itemDiscountPerController = TextEditingController();
  TextEditingController itemNetPriceController = TextEditingController();
  TextEditingController itemCGstPerController = TextEditingController();
  TextEditingController itemCGstAmtController = TextEditingController();
  TextEditingController itemSGstPerController = TextEditingController();
  TextEditingController itemSGstAmtController = TextEditingController();
  TextEditingController itemIGstPerController = TextEditingController();
  TextEditingController itemIGstAmtController = TextEditingController();
  TextEditingController itemTaxablePriceController = TextEditingController();
  TextEditingController itemNetAmountController = TextEditingController();
  TextEditingController itemGrossAmountController = TextEditingController();
  TextEditingController searchFieldController = TextEditingController();

  ///
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxBool isOpen = false.obs;
  RxBool isAdd = false.obs;
  bool isUpdate = false;
  int key = 0;
  String startDate = "";
  String poDate = "";
  String deliveryDate = "";
  String saleId = "";
  int gstId = 0;
  String endDate = "";
  int customerId = 0;
  String total = "";
  String discountTotal = "";
  String cGstTotal = "";
  String sGstTotal = "";
  String iGstTotal = "";
  String totalItem = "";
  String netTotal = "";
  static List<CategoryBrandData> categoryBrandList = [];
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  bool isCustomer = false;

  CustomerDetailResponse customerDetail = CustomerDetailResponse();

  List invoiceList = [
    'Bill of Supply',
    'Tax',
  ];

  List gstTYpe = [
    'CGST_SGST',
    'IGST',
  ];

  List<SaleOrderDetails> itemList = [];

  List gstList = [
    '1%',
    '5%',
    '12%',
    '18%',
    '28%',
    'Exempted',
    '3%',
  ];
  final companyToken = GetStorageData.readString(
    GetStorageData.token,
  );
  Rx<CategoryBrandData> selectedCategoryBrandData = Rx<CategoryBrandData>(CategoryBrandData());
  Rx<BranddData> selectedBrandData = Rx<BranddData>(BranddData());

  RxList<ItemData> categoryWisefilteredItemss = <ItemData>[].obs;
  RxList<CustomerData> customernamefilteredItemss = <CustomerData>[].obs;
  var filteredCategoryBrands = <CategoryBrandData>[].obs;
  var filteredBrands = <BranddData>[].obs;
  List<BranddData> categoryWiseBrandList = [];

  void selectCategory(CategoryBrandData category) {
    selectedCategoryBrandData.value = category;
  }

  void selectBrand(BranddData category) {
    selectedBrandData.value = category;
  }

  Future<void> ensureFilterListsLoaded() async {
    final context = Get.context;
    if (context == null) return;

    final futures = <Future<void>>[];
    if (ApiConstant.categoryBrandList.isEmpty) {
      futures.add(getCategoryListApi(context));
    }
    if (ApiConstant.brandList.isEmpty) {
      futures.add(getBrandListApi(context));
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> getBrandListApi(BuildContext context) async {
    final response = await _apiService.getRequest(
     ApiConstant.getBrandList,
      headers: {"Authorization": "Bearer $companyToken"},
    );
/*
    var responseData = response is String ? jsonDecode(response.data) : response;
*/

    if (response.statusCode == 200) {
      GetBranddListModel model = GetBranddListModel.fromJson(response.data);

      ApiConstant.brandList = model.data ?? [];
    }
  }

  Future<void> getBrandListByCategoryApi(
    BuildContext context,
    int categoryId,
  ) async {
    final response = await _apiService.getRequest(
     '${ApiConstant.getBrandList}?CategoryId=$categoryId',
      headers: {"Authorization": "Bearer $companyToken"},

    );
    // var responseData = response is String ? jsonDecode(response.data) : response;

    if (response.statusCode == 200) {
      GetBranddListModel model = GetBranddListModel.fromJson(response.data);
      categoryWiseBrandList = model.data ?? [];
      filteredBrands.value = categoryWiseBrandList;
    }
  }

  Future<void> getCategoryListApi(BuildContext context) async {
    final response = await _apiService.getRequest(
      ApiConstant.getCategoryList,
      headers: {"Authorization": "Bearer $companyToken"},

    );
    // var responseData = response is String ? jsonDecode(response.data) : response;

    if (response.statusCode == 200) {
      GetCategoryBrandListModel model = GetCategoryBrandListModel.fromJson(response.data);
      ApiConstant.categoryBrandList = model.data ?? [];
    }
  }

  List<BranddData> get _activeBrandSource {
    if (selectedCategoryBrandData.value.categoryID != null) {
      return categoryWiseBrandList;
    }
    return ApiConstant.brandList;
  }

  Future<void> onCategorySelected(
    BuildContext context,
    CategoryBrandData category,
  ) async {
    selectCategory(category);
    selectedBrandData.value = BranddData();
    if (category.categoryID != null) {
      await getBrandListByCategoryApi(context, category.categoryID!);
    }
    validationForApiCall();
  }

  Future<void> clearCategorySelection() async {
    selectedCategoryBrandData.value = CategoryBrandData();
    selectedBrandData.value = BranddData();
    categoryWiseBrandList.clear();
    filteredBrands.value = ApiConstant.brandList;
    validationForApiCall();
  }

  void validationForApiCall() {
    // if (selectedBrandData.value.brandID != null && selectedCategoryBrandData.value.categoryID != null) {
    apiCallCategoryWiseGetItem();
    // }
  }

  RxList<ItemData> selectedItems = <ItemData>[].obs;
  RxMap<ItemData, int> itemQuantities = <ItemData, int>{}.obs;

  void toggleSelection(ItemData item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
      // itemQuantities.remove(item); // Remove quantity when deselected
    } else {
      selectedItems.add(item);
      // itemQuantities[item] = -1; // Default quantity to 1 when selected
    }
    sortSelectedItemsOnTop();

  }

  String getQuantity(ItemData item) {
    return itemQuantities.containsKey(item) ? itemQuantities[item].toString() : "";
  }

  void updateQuantity(ItemData item, String value) {
    if (value.isEmpty) return;
    int? qty = int.tryParse(value);
    if (qty == null || qty <= 0) return;
    itemQuantities[item] = qty;

    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
    sortSelectedItemsOnTop();
  }


  // void updateQuantity(ItemData item, String value) {
  //   int quantity = int.tryParse(value) ?? 1;
  //   itemQuantities[item] = quantity;
  //   if (!selectedItems.contains(item)) {
  //     selectedItems.add(item); // Ensure selection stays
  //   }
  //   // selectedItems.add(item); // Ensure selection stays
  // }

  bool isSelected(ItemData item) {
    return selectedItems.any((s) => s.itemid == item.itemid);
  }

  void calculateGstAndDiscountForSelectedItems() {
    for (var item in selectedItems) {

      int quantity = itemQuantities[item] ?? 1;

      double itemPrice = double.tryParse(item.price?.toString() ?? "0") ?? 0;
      double discountPercent =
          double.tryParse(item.salesDiscountper?.toString() ?? "0") ?? 0;
      double totalGstPercent = double.tryParse(addGstController.text.isEmpty
          ? "0"
          : addGstController.text.replaceAll("%", "")) ??
          0;

      double discountAmount = discountPercent / 100 * itemPrice;
      double itemNetPrice = itemPrice - discountAmount;

      double cgstPercent = (totalGstPercent / 2);
      double cgstAmount = itemNetPrice * cgstPercent / 100;
      double sgstAmount = itemNetPrice * cgstPercent / 100;
      double igstAmount = itemNetPrice * totalGstPercent / 100;

      double itemGrossAmount = quantity * itemPrice;
      double itemNetAmount =
          (itemNetPrice + cgstAmount + sgstAmount) * quantity;
      double itemTaxablePrice = itemGrossAmount - discountAmount;

      itemList.add(SaleOrderDetails(
        itemId: item.itemid,
        itemName: item.itemName,
        unit: item.unitCode,
        qty: double.parse(quantity.toString()),
        price: double.parse(itemPrice.toString()),
        discountPer: double.parse(discountPercent.toString()),
        discount: double.parse(discountAmount.toString()),
        totalDiscount: double.parse(discountAmount.toString()),
        gstcodeId: item.gstCodeId,
        netPriceINCTax: double.parse(itemNetPrice.toString()),
        cgstPer: double.parse(cgstPercent.toString()),
        cgstAmount: double.parse(cgstAmount.toStringAsFixed(2).toString()),
        sgstPer: double.parse(cgstPercent.toString()),
        sgstAmount: double.parse(sgstAmount.toStringAsFixed(2).toString()),
        igstPer: double.parse(totalGstPercent.toString()),
        igstAmount: double.parse(igstAmount.toStringAsFixed(2).toString()),
        taxableAmount: double.parse(itemTaxablePrice.toStringAsFixed(2).toString()),
        netAmount: double.parse(itemNetAmount.toStringAsFixed(2).toString()),
        grossAmount: double.parse(itemGrossAmount.toStringAsFixed(2).toString()),
      ));
      calculateGstAndDiscountForAllItems();
      update();
      print(
          "setItemClick-----------------Item: ${item.itemName}, Qty: $quantity, Net Amount: $itemNetAmount, Taxable Price: $itemTaxablePrice");
    }

    update(); // Notify UI
  }

  void removeItem(int index) {
    itemList.removeAt(index);
    calculateGstAndDiscountForAllItems();
    update(); // Update UI using GetX
  }

  Future<void> persistSalesOrderCart() async {
    calculateGstAndDiscountForAllItems();
    await SalesOrderCartService.save(
      items: itemList,
      total: total,
      discountTotal: discountTotal,
      cGstTotal: cGstTotal,
      sGstTotal: sGstTotal,
      iGstTotal: iGstTotal,
      totalItem: totalItem,
      netTotal: netTotal,
      orderNo: addSerialController.text,
      customerId: customerId,
      customerName: customerController.text,
    );
  }

  void restoreCartFromLocal() {
    final cart = SalesOrderCartService.loadLatest();
    if (cart == null || cart.items.isEmpty) {
      return;
    }

    itemList = List<SaleOrderDetails>.from(cart.items);
    total = cart.total;
    discountTotal = cart.discountTotal;
    cGstTotal = cart.cGstTotal;
    sGstTotal = cart.sGstTotal;
    iGstTotal = cart.iGstTotal;
    totalItem = cart.totalItem;
    netTotal = cart.netTotal;

    if (cart.customerId != null && cart.customerId! > 0) {
      customerId = cart.customerId!;
    }
    if (cart.customerName != null && cart.customerName!.isNotEmpty) {
      customerController.text = cart.customerName!;
    }
    update();
  }

  void clearSalesOrderCart() {
    SalesOrderCartService.clear();
  }

  void calculateGstAndDiscountForAllItems() {
    double totalAmt = 0;
    // int totalQnt = 0;
    double totalDiscount = 0;
    double totalCGST = 0;
    double totalSGST = 0;
    double totalIGST = 0;
    double totalGrossAmount = 0;
    double totalNetAmount = 0;

    for (var item in itemList) {
      totalAmt += double.parse(item.price.toString()) * double.parse(
          item.qty.toString().isEmpty
              ? "1"
              : item.qty.toString()); // Sum total quantity of all items
      // totalQnt += int.parse(item.qty.toString()); // Sum total quantity of all items
      totalDiscount += double.parse(item.totalDiscount.toString()); // Total discount applied
      totalCGST += double.parse(item.cgstAmount.toString()); // Total CGST
      totalSGST += double.parse(item.sgstAmount.toString()); // Total SGST
      totalIGST += double.parse(item.igstAmount.toString()); // Total IGST
      totalGrossAmount += double.parse(item.grossAmount.toString()); // Gross amount (before tax)
      totalNetAmount += double.parse(item.netAmount.toString()); // Final payable amount
    }

    total = (totalAmt).toStringAsFixed(2).toString();
    discountTotal = totalDiscount.toStringAsFixed(2).toString();
    sGstTotal = totalCGST.toStringAsFixed(2).toString();
    cGstTotal = totalSGST.toStringAsFixed(2).toString();
    iGstTotal = totalIGST.toStringAsFixed(2).toString();
    totalItem = itemList.length.toString();
    netTotal = totalNetAmount.toStringAsFixed(2).toString();
    update();
  }

  void categoryWiseFilterItems(String query) {
    if (query.isEmpty) {
      categoryWisefilteredItemss.value = ApiConstant.categoryWiseItemList;
    } else {
      categoryWisefilteredItemss.value = ApiConstant.categoryWiseItemList
          .where((item) =>
          item.itemName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    sortSelectedItemsOnTop();
  }

  void categoryFilter(String query) {
    if (query.isEmpty) {
      filteredCategoryBrands.value = ApiConstant.categoryBrandList;
    } else {
      filteredCategoryBrands.value = ApiConstant.categoryBrandList
          .where((category) => category.categoryName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void brandFilter(String query) {
    final source = _activeBrandSource;
    if (query.isEmpty) {
      filteredBrands.value = source;
    } else {
      filteredBrands.value = source
          .where((brand) => (brand.brandName ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> apiCallCategoryWiseGetItem() async {
    print('apiCallCategoryWiseGetItem called, customerId: $customerId');

    if (customerId == 0) return;
    print('ITEM API customerId: $customerId');

    FormData formData = FormData.fromMap({});
    String url;
    if (selectedBrandData.value.brandID == null && selectedCategoryBrandData.value.categoryID == null) {
      url = "${ApiConstant.GetItemListByBrandandCategory}";
    } else if (selectedBrandData.value.brandID != null && selectedCategoryBrandData.value.categoryID == null) {
      url =
      "${ApiConstant.GetItemListByBrandandCategory}?BrandId=${selectedBrandData.value.brandID}";
    } else if (selectedBrandData.value.brandID != null && selectedCategoryBrandData.value.categoryID != null) {
      url =
      "${ApiConstant.GetItemListByBrandandCategory}?BrandId=${selectedBrandData.value.brandID}&CategoryId=${selectedCategoryBrandData.value.categoryID}";
    } else if (selectedBrandData.value.brandID == null && selectedCategoryBrandData.value.categoryID != null) {
      url =
      "${ApiConstant.GetItemListByBrandandCategory}?CategoryId=${selectedCategoryBrandData.value.categoryID}";
    } else {
      url =
      "${ApiConstant.GetItemListByBrandandCategory}?BrandId=${selectedBrandData.value.brandID}&CategoryId=${selectedCategoryBrandData.value.categoryID}";
    }

    url = Global.withCustomerId(url, 0);

    final response = await _apiService.getRequest(
       url,
      headers: {"Authorization": "Bearer $companyToken"},
    );
    // var responseData = response is String ? jsonDecode(response.data) : response;

    if (response.statusCode == 200) {
      GetItemListModel model = GetItemListModel.fromJson(response.data);
      ApiConstant.categoryWiseItemList = model.data ?? [];
      ApiConstant.categoryWiseItemList
          .sort((a, b) => a.itemName!.toLowerCase().compareTo(b.itemName!.toLowerCase()));

      categoryWisefilteredItemss.value = ApiConstant.categoryWiseItemList;
      sortSelectedItemsOnTop();
      update();
    }
  }

  void filterSheet(BuildContext context) {
    Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<SalesOrderController>(
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SalesOrderSheetHeader(
                  title: "Filter Sale Order",
                  subtitle: "Search by date range and customer",
                ),
                ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  shrinkWrap: true,
                  children: [
                    CommonTextField(
                      borderRadius: 12,
                      controller: startDateController,
                      title: "Start Date",
                      isTitle: true,
                      maxLength: 10,
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        selectDate(context, "from");
                      },
                      inputFormatters: [
                        DateInputFormatter(),
                      ],
                      suffix: GestureDetector(
                        onTap: () {
                          selectDate(context, "from");
                        },
                        child: const Icon(Icons.calendar_month),
                      ),
                    ),
                    const Gap(10),
                    CommonTextField(
                      borderRadius: 12,
                      controller: endDateController,
                      title: "End Date",
                      isTitle: true,
                      maxLength: 10,
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        selectDate(context, "to");
                      },
                      inputFormatters: [
                        DateInputFormatter(),
                      ],
                      suffix: GestureDetector(
                        onTap: () {
                          selectDate(context, "to");
                        },
                        child: const Icon(Icons.calendar_month),
                      ),
                    ),
                    const Gap(10),
                    CommonTextField(
                      borderRadius: 12,
                      controller: customerController,
                      title: "Customer",
                      isTitle: true,
                      maxLength: 10,
                      hintText: "Please Select...",
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        selectCustomer();
                      },
                      suffix: const RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            btnName: "Search",
                            onTap: () {
                              salesOrderListApi();
                              Get.back();
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: CommonButton(
                            btnName: "Reset",
                            btnColor: Colors.grey.shade700,
                            onTap: () {
                              Get.back();
                              customerController.clear();
                              invoiceController.clear();
                              startDateController.clear();
                              endDateController.clear();
                              startDate = "";
                              endDate = "";
                            },
                          ),
                        )
                      ],
                    ),
                    const Gap(20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<String> filteredItems = [];
  List<String> customerName = [
    '3 STAR ADVERTISING',
    'A.JITENDERKUMAR & CO.',
    'AADARSH ASSOCIATES',
  ];

  List<String> statusList = [
    'Open',
    'Closed',
    'Cancelled',
  ];

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems = customerName;
    } else {
      filteredItems = customerName
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }


  void customernameFilterItems(String query) {
    if (query.isEmpty) {
      filteredCustomer = ApiConstant.customerList;
    } else {
      final q = query.toLowerCase().trim();
      filteredCustomer = ApiConstant.customerList
          .where((item) =>
      (item.customerName ?? '').toLowerCase().contains(q) ||
          (item.contactNo ?? '').toLowerCase().contains(q))
          .toList();
    }
    update();
  }

  var quotationList = <QuotationData>[].obs;
  // List<QuotationData> quotationList = [];

  void selectLedger() {
    filteredItems = customerName;
    Get.bottomSheet(
      GetBuilder<SalesOrderController>(
        builder: (controller) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  CommonTextField(
                    controller: searchController,
                    borderRadius: 12,
                    prefix: Icon(Icons.search),
                    onChanged: (p0) {
                      // filterItems(p0);
                      customernameFilterItems(p0);
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return GestureDetector(onTap: () {
                          customerController.text = filteredItems[index];
                          controller.update();
                          Get.back();
                        }, child: Text(filteredItems[index]));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  collapse() {
    int newKey = 0;
    do {
      key = new Random().nextInt(10000);
    } while (newKey == key);
  }

  Future<void> selectDate(BuildContext context, String fromDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      final date = DateFormat("dd/MM/yyyy").format(picked).toString();
      if (fromDate == "from") {
        startDate = picked.toIso8601String();
        startDateController.text = date;
      } else if (fromDate.toLowerCase() == "add") {
        addDateController.text = date;
      }
      // else if (fromDate.toLowerCase() == "delivery") {
      //   addDeliveryDateController.text = date;
      //   deliveryDate = picked.toIso8601String();
      // }
      else if (fromDate.toLowerCase() == "podate") {
        addPoDateController.text = date;
        poDate = picked.toIso8601String();
      } else {
        endDate = picked.toIso8601String();
        endDateController.text = date;
      }
    }
  }

  void filterCustomer(String query) {
    if (query.isEmpty) {
      filteredCustomer = ApiConstant.customerList;
    } else {
      filteredCustomer = ApiConstant.customerList
          .where((item) =>
          item.customerName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  void selectCustomer() {
    filteredCustomer = ApiConstant.customerList;
    searchController.clear();
    Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<SalesOrderController>(
        builder: (controller) {
          return Container(
            height: Get.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SalesOrderSheetHeader(
                  title: "Select Customer",
                  subtitle: "Search and choose a customer",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: CommonTextField(
                    controller: searchController,
                    borderRadius: 12,
                    prefix: const Icon(Icons.search, color: Color(0xffC8102E)),
                    hintText: "Search customer",
                    onChanged: (p0) {
                      customernameFilterItems(p0);
                    },
                  ),
                ),
                Expanded(
                  child: filteredCustomer.isEmpty
                      ? const Center(child: Text("No customers found"))
                      : ListView.builder(
                          itemCount: filteredCustomer.length,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          itemBuilder: (context, index) {
                            final customer = filteredCustomer[index];
                            final name = customer.customerName ?? '';
                            final phone = customer.contactNo ?? '';
                            final title = phone.isNotEmpty
                                ? "$name - $phone"
                                : name;
                            return SalesOrderSheetOptionTile(
                              title: title,
                              subtitle: customer.contactNo,
                              onTap: () {
                                customerController.text = title;
                                customerId = customer.customerID ?? 0;
                                addCustomerNumberController.text =
                                    customer.contactNo ?? "";
                                addGSTinController.text =
                                    customer.gstinNumber ?? "";
                                addGstTypeController.text =
                                    customer.gstType ?? "";
                                apiCallCategoryWiseGetItem();
                                Get.back();
                                update();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void sortSelectedItemsOnTop() {
    final selected = categoryWisefilteredItemss
        .where((item) => selectedItems.contains(item))
        .toList();
    final unselected = categoryWisefilteredItemss
        .where((item) => !selectedItems.contains(item))
        .toList();
    categoryWisefilteredItemss.value = [...selected, ...unselected];
  }

  // API Calling....
bool isData = false;

  Future<void> salesOrderListApi() async {
    isData = false;
    isLoading.value = true;
    update();
    try {
      String dataRaw = jsonEncode({
        "startDate":
            startDate.isNotEmpty ? startDate : DateTime.now().toIso8601String(),
        "endDate":
            endDate.isNotEmpty ? endDate : DateTime.now().toIso8601String(),
        "invoiceType":
            invoiceController.text.isNotEmpty ? invoiceController.text : "",
        "customerId": 0
      });

      final response = await _apiService.postRequest(
        ApiConstant.saleOrderList,
        data: dataRaw,
        headers: {"Authorization": "Bearer $companyToken"},
      );

      if (response.statusCode == 200) {
        QuotationListModel model = QuotationListModel.fromJson(response.data);
        isData = true;
        quotationList.clear();
        quotationList.value = model.data ?? [];
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> apiCallCustomer() async {
    FormData formData = FormData.fromMap({});

    final response = await _apiService.getRequest(
      ApiConstant.getCustomerList,
        headers: {
          "Authorization":"Bearer $companyToken"
        }
    );

    // var responseData = data is String ? jsonDecode(data) : data;

    if (response.statusCode == 200) {
      CustomerModel model = CustomerModel.fromJson(response.data);

      ApiConstant.customerList = model.data ?? [];
      update();
    }
  }
  Future<void> customerDetailApi() async {
    FormData formData = FormData.fromMap({});

    final response = await _apiService.getRequest(
     "${ApiConstant.GetCustomerDetails}",
      headers: {
       "Authorization":"Bearer $companyToken"
      }

    );
    // var responseData = response is String ? jsonDecode(response.data) : response;
   print("getCustomer Detail------${response.data}");
    if (response.statusCode == 200) {
      CustomerDetailResponse model = CustomerDetailResponse.fromJson(response.data);
      customerDetail = model;
      if (isCustomer) {
        customerController.text = customerDetail.data!.customerName!;
        addCustomerNumberController.text = customerDetail.data!.contactNo!;
        customerId = customerDetail.data!.customerID!;
        apiCallCategoryWiseGetItem();
      }

      update();
    }
  }

  void quotationDataApi(int id) async {
    final response = await _apiService.getRequest(
      "${ApiConstant.baseurl}/SaleOrder/SaleOrderData/${id}",
        headers: {
          "Authorization":"Bearer $companyToken"
        }

    );
    // var responseData = response is String ? jsonDecode(response.data) :response;

    if (response.statusCode == 200) {
      SaleOrderModel model = SaleOrderModel.fromJson(response.data);

      model.data!.forEach(
            (element) {
          addDateController.text = DateFormat("dd/MM/yyyy")
              .format(DateTime.parse(element.date ?? ""))
              .toString();
          addSerialController.text = element.orderNo.toString();
          addInvoiceTypeController.text = element.invoiceType ?? "";
          customerController.text = element.customerName ?? "";
          customerId = element.customerId ?? 0;
          poDate = element.poDate ?? "";
          addPoDateController.text = DateFormat("dd/MM/yyyy").format(DateTime.parse(element.poDate ?? "")).toString();
          deliveryDate = element.deliveryDate ?? "";
          addDeliveryDateController.text = DateFormat("dd/MM/yyyy").format(DateTime.parse(element.deliveryDate ?? "")).toString();
          addCustomerNumberController.text = element.contactNumber ?? "";
          addShippingAddressController.text = element.shippingAddress ?? "";
          // addGSTinController.text = element.gstiNumber ?? "";
          addRemarkController.text = element.remarks ?? "";
          addGstTypeController.text = element.gstType ?? "";
          total = element.total.toString();
          discountTotal = element.discountTotal.toString();
          cGstTotal = element.cgstTotal.toString();
          sGstTotal = element.sgstTotal.toString();
          iGstTotal = element.igstTotal.toString();
          totalItem = (element.saleOrderDetails!.length + 1).toString();
          netTotal = element.netTotal.toString();
          itemList = element.saleOrderDetails ?? [];
        },
      );
      persistSalesOrderCart();
      update();
    }
  }

  /// Same shape as Postman sample: `2026-05-04T05:08:15.027Z` (ms + Z).
  String _postmanStyleUtc(DateTime local) {
    final u = local.toUtc();
    return '${u.year.toString().padLeft(4, '0')}-'
        '${u.month.toString().padLeft(2, '0')}-'
        '${u.day.toString().padLeft(2, '0')}T'
        '${u.hour.toString().padLeft(2, '0')}:'
        '${u.minute.toString().padLeft(2, '0')}:'
        '${u.second.toString().padLeft(2, '0')}.'
        '${u.millisecond.toString().padLeft(3, '0')}Z';
  }

  String _normalizeAuxDate(String raw, DateTime fallbackLocal) {
    final v = raw.trim();
    if (v.isEmpty) return _postmanStyleUtc(fallbackLocal);
    try {
      return _postmanStyleUtc(DateTime.parse(v));
    } catch (_) {
      return _postmanStyleUtc(fallbackLocal);
    }
  }

  String quotationSaveDateIsoUtc() {
    DateTime local = DateTime.now();
    final t = addDateController.text.trim();
    if (t.isNotEmpty) {
      try {
        final d = DateFormat('dd/MM/yyyy').parse(t);
        final n = DateTime.now();
        local = DateTime(d.year, d.month, d.day, n.hour, n.minute, n.second);
      } catch (_) {}
    }
    return _postmanStyleUtc(local);
  }

  Future<void> updateQuotationApi() async {
    int tempcustomerId = 0;
    String apiURL = "";
    if(isCustomer == false){
      tempcustomerId = customerId;
      apiURL = ApiConstant.saveSaleOrder;
    }else{
      tempcustomerId = customerDetail.data!.customerID!;
      apiURL = ApiConstant.SaveSaleOrderfromcustomer;
    }
    DateTime headerLocal = DateTime.now();
    final tc = addDateController.text.trim();
    if (tc.isNotEmpty) {
      try {
        final d = DateFormat('dd/MM/yyyy').parse(tc);
        final n = DateTime.now();
        headerLocal = DateTime(d.year, d.month, d.day, n.hour, n.minute, n.second);
      } catch (_) {}
    }

    var dataa = {
      "date": quotationSaveDateIsoUtc(),
      "taxMode": "GST",
      "invoiceType": addInvoiceTypeController.text,
      "orderNo": int.parse(addSerialController.text),
      "customerId": tempcustomerId,
      "customerName": customerController.text,
      "contactNumber": addCustomerNumberController.text,
      "shippingAddress": addShippingAddressController.text,
      "deliveryDate": _normalizeAuxDate(deliveryDate, headerLocal),
      "poDate": _normalizeAuxDate(poDate, headerLocal),
      "poNumber": addPoNumberController.text,
      "transport": addTransportController.text,
      "status": statusController.text,
      "remarks": addRemarkController.text,
      "gstType": addGstTypeController.text,
      "total": total == "0.0" ? 0 : double.parse(total),
      "discountTotal": discountTotal == "0.0" ? 0 : double.parse(discountTotal),
      "cgstTotal": cGstTotal == "0.0" ? 0 : double.parse(cGstTotal),
      "sgstTotal": sGstTotal == "0.0" ? 0 : double.parse(sGstTotal),
      "igstTotal": iGstTotal == "0.0" ? 0 : double.parse(iGstTotal),
      "netTotal": netTotal == "0.0" ? 0 : double.parse(netTotal),
      "saleOrderDetails": itemList.map((e) => e.toJson()).toList(),
    };

    var dataRaw = json.encode(dataa);

    final response = await _apiService.postRequest(
     "${ApiConstant.baseurl}/SaleOrder/UpdateSaleOrder/${saleId}",
        headers: {
          "Authorization":"Bearer $companyToken"
        },
      data: dataRaw

    );

    if (response.statusCode == 200) {
      SaveQuotationModel model = SaveQuotationModel.fromJson(response.data);
      salesOrderListApi();
      // quotationList.add(
      //   QuotationData(
      //     quoteId: model.data!.quoteId ?? 0,
      //     serialNo: addSerialController.text,
      //     date: DateTime.now().toIso8601String(),
      //     customerName: customerController.text,
      //     contactNumber: addCustomerNumberController.text,
      //     invoiceType: addInvoiceTypeController.text,
      //     netPayableAmount: double.parse(netTotal),
      //     allowEditEntry: true,
      //     allowDeleteEntry: true,
      //   ),
      // );
      update();
    }
  }

  Future<void> createQuotationApi() async {
    int tempcustomerId = 0;
    String apiURL = "";
    if(isCustomer == false){
      tempcustomerId = customerId;
      apiURL = ApiConstant.saveSaleOrder;
    }else{
      tempcustomerId = customerDetail.data!.customerID!;
      apiURL = ApiConstant.SaveSaleOrderfromcustomer;
    }

    DateTime headerLocal = DateTime.now();
    final tc = addDateController.text.trim();
    if (tc.isNotEmpty) {
      try {
        final d = DateFormat('dd/MM/yyyy').parse(tc);
        final n = DateTime.now();
        headerLocal = DateTime(d.year, d.month, d.day, n.hour, n.minute, n.second);
      } catch (_) {}
    }

    var dataa = {
      "date": quotationSaveDateIsoUtc(),
      "taxMode": "GST",
      "invoiceType": addInvoiceTypeController.text,
      "orderNo": int.parse(addSerialController.text),
      "customerId": tempcustomerId,
      "customerName": customerController.text,
      "contactNumber": addCustomerNumberController.text,
      "shippingAddress": addShippingAddressController.text,
      "deliveryDate": _normalizeAuxDate(deliveryDate, headerLocal),
      "poDate": _normalizeAuxDate(poDate, headerLocal),
      "poNumber": addPoNumberController.text,
      "transport": addTransportController.text,
      "status": statusController.text,
      "remarks": addRemarkController.text,
      "gstType": addGstTypeController.text,
      "total": total == "0.0" ? 0 : double.parse(total),
      "discountTotal": discountTotal == "0.0" ? 0 : double.parse(discountTotal),
      "cgstTotal": cGstTotal == "0.0" ? 0 : double.parse(cGstTotal),
      "sgstTotal": sGstTotal == "0.0" ? 0 : double.parse(sGstTotal),
      "igstTotal": iGstTotal == "0.0" ? 0 : double.parse(iGstTotal),
      "netTotal": netTotal == "0.0" ? 0 : double.parse(netTotal),
      "saleOrderDetails": itemList.map((e) => e.toJson()).toList(),
    };

    var dataRaw = json.encode(dataa);


    final response = await _apiService.postRequest(
      apiURL,
        headers: {
          "Authorization":"Bearer $companyToken"
        },
      data: dataRaw

    );

    if (response.statusCode == 200) {
      SaveQuotationModel model = SaveQuotationModel.fromJson(response.data);
      // quotationList.add(
      //   QuotationData(
      //     quoteId: model.data!.quoteId ?? 0,
      //     serialNo: addSerialController.text,
      //     date: DateTime.now().toIso8601String(),
      //     customerName: customerController.text,
      //     contactNumber: addCustomerNumberController.text,
      //     invoiceType: addInvoiceTypeController.text,
      //     netPayableAmount: double.parse(netTotal),
      //     allowEditEntry: true,
      //     allowDeleteEntry: true,
      //   ),
      // );
      salesOrderListApi();
      update();
    }
  }

  Future<void> deleteQuotationApi(id) async {
   CommonLoader.show(Get.context!);
    String token = "";
    if(GetStorageData.containKey(GetStorageData.token))
    {
      token = GetStorageData.readString(GetStorageData.token);
    }
    var headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Cookie': 'ARRAffinity=3adacca6c2f81875efead5591d2a8d02faa6e8843c1dd1a10e8da178ce234c0c; ARRAffinitySameSite=3adacca6c2f81875efead5591d2a8d02faa6e8843c1dd1a10e8da178ce234c0c'
    };
    var dio = Dio();
    var response = await dio.request(
      'https://gurukrupawebapis.azurewebsites.net/api/SaleOrder/DeleteSaleOrder/$id',
      options: Options(
        method: 'PUT',
        headers: headers,
      ),
    );

    SaveQuotationModel model = SaveQuotationModel.fromJson(response.data);
    if (model.statusCode == 200) {
      CommonLoader.hide();
      await salesOrderListApi();
    }
    else {
      print(response.statusMessage);
    }
  }

  @override
  void onInit() {
    salesOrderListApi();
    customerDetailApi();
    apiCallCustomer();
    validationForApiCall();
    isCustomer = GetStorageData.readBoolean(GetStorageData.isCustomer);
    startDateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    endDateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    super.onInit();
  }

  calculateGstAndDiscount() {
    double itemPrice = double.tryParse(itemNetPriceController.text.isEmpty ? "0" : itemNetPriceController.text) ?? 0;
    double discountPercent = double.tryParse(itemDiscountPerController.text.isEmpty ? "0" : itemDiscountPerController.text) ?? 0;
    double totalGstPercent = double.parse(addGstController.text.isEmpty ? "0" : addGstController.text.replaceAll("%", "")) ?? 0;
    double discountAmount = discountPercent / 100 * double.parse(itemPriceController.text);
    double temp = itemPrice * totalGstPercent / 100;
    itemDiscountController.text = (discountAmount.toStringAsFixed(3)).toString();
    itemTotalDiscountController.text = (int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text) * discountAmount).toStringAsFixed(3).toString();
    itemNetPriceController.text = (double.parse(itemPriceController.text.isEmpty? "0" :itemPriceController.text) - discountAmount).toString();

    double cgstPercent = (totalGstPercent / 2);
    double cgstAmount = double.parse(itemNetPriceController.text.isEmpty? "0" :itemNetPriceController.text) * cgstPercent / 100;
    double sgstAmount = double.parse(itemNetPriceController.text.isEmpty ? "0" : itemNetPriceController.text) * cgstPercent / 100;
    double igstAmount = double.parse(itemNetPriceController.text.isEmpty ? "0" :itemNetPriceController.text) * totalGstPercent / 100;

    itemCGstPerController.text = cgstPercent.toStringAsFixed(2).toString();

    itemSGstPerController.text = cgstPercent.toStringAsFixed(2).toString();

    itemIGstPerController.text = igstAmount.toStringAsFixed(2).toString();

    itemCGstAmtController.text = (int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text) * cgstAmount).toStringAsFixed(2).toString();

    itemSGstAmtController.text = (int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text) * sgstAmount).toStringAsFixed(2).toString();

    itemIGstAmtController.text = (int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text) * igstAmount).toStringAsFixed(2).toString();
    itemGrossAmountController.text = (int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text) * double.parse(itemPriceController.text)).toStringAsFixed(3).toString();
    double discountPerItem = double.parse(itemNetPriceController.text.isEmpty ? "0" : itemNetPriceController.text) * cgstPercent / 100;
    print('discountPerItem --- ${discountPerItem}');
    itemNetPriceController.text = (double.parse(itemNetPriceController.text.isEmpty ? "0" : itemNetPriceController.text) + discountPerItem + discountPerItem).toString();
    itemNetAmountController.text = (double.parse(itemNetPriceController.text.isEmpty ? "0" : itemNetPriceController.text) * int.parse(itemQtyController.text.isEmpty ? "0" : itemQtyController.text)).toStringAsFixed(2).toString();
    itemTaxablePriceController.text =
        (double.parse(itemGrossAmountController.text.isEmpty ? "0" : itemGrossAmountController.text) - discountAmount)
            .toStringAsFixed(3)
            .toString();

    update();
  }

  void nextSerialNoApi() async {
    final response = await _apiService.getRequest(
     "${ApiConstant.nextOrderNo}/${addInvoiceTypeController.text}",
        headers: {
          "Authorization":"Bearer $companyToken"
        }

    );
    // var responseData = response is String ? jsonDecode(response.data) : response;

    if (response.statusCode == 200) {
      NextSerialNoModel model = NextSerialNoModel.fromJson(response.data);

      addSerialController.text = model.data!.orderNumber.toString();
      update();
    }
  }

  void quotationPDFApi(int id) async {
    final response = await _apiService.getRequest(
     "SaleOrder/SaleOrderPDFurl/${id}",
        headers: {
          "Authorization":"Bearer $companyToken"
        }

    );
    var responseData = response is String ? jsonDecode(response.data) : response;

    QuotationModel model = QuotationModel.fromJson(responseData);
    if (model.statusCode == 200) {
      // Get.toNamed(AppRoutes.PDF_VIEW, arguments: {
      //   "html": model.data!.downloadurl,
      //   "fileName": "Sales_Order"
      // });
      downloadFile(model.data!.downloadurl!.split("/").last, model.data!.downloadurl);
      update();
    }
  }

  Future<void> downloadFile(var filePath, var documentUrl) async {
    try {
      print("downloadFile --- 1");
      final filename = filePath;
      String dir = "/storage/emulated/0/Download";
      print("downloadFile --- 2");

      if (await File('$dir/$filename').exists()) {
        print("File already exists at $dir/$filename");
        return;
      }

      String url = documentUrl;
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength;
        int receivedBytes = 0;

        File file = File('$dir/$filename');
        var fileSink = file.openWrite();

        await for (var chunk in response) {
          fileSink.add(chunk);

          receivedBytes += chunk.length;

          double progress = (receivedBytes / totalBytes) * 100;
          print("Download progress: ${progress.toStringAsFixed(2)}%");
        }

        await fileSink.close();

        print("File downloaded successfully to ${file.path}");
        Utils().showToast(message: "File downloaded successfully to ${file.path}", context: Get.context!,isSuccess: true,title: "Success");
      } else {
        print("Failed to download file: ${response.statusCode}");
      }
    } catch (err) {
      print("Error: $err");
    }
  }
}
