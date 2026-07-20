import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_String.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/controllers/sales_order_controller.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_form_ui.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';
import 'package:saral/View/Screen/Sale Order/Model/sale_order_model.dart';

import '../../../../Common/Tost.dart';

class SalesOrderAddView extends GetView<SalesOrderController> {
  const SalesOrderAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesOrderController>(
      builder: (controller) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            CommonTextField(
              borderRadius: 12,
              controller: controller.addDateController,
              title: "Date",
              isTitle: true,
              maxLength: 10,
              showCursor: false,
              readOnly: true,
              onTap: (){
                controller?.selectDate(context, "add");
              },
              inputFormatters: [
                DateInputFormatter(),
              ],
              suffix: GestureDetector(
                onTap: () {
                  controller.selectDate(context, "add");
                },
                child: Icon(Icons.calendar_month),
              ),
            ),
            Gap(5),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    borderRadius: 12,
                    controller: TextEditingController(text: "GST"),
                    title: "Text Mode",
                    isTitle: true,
                    readOnly: true,
                    showCursor: false,
                  ),
                ),
                Gap(15),
                Expanded(
                  child: CommonTextField(
                    borderRadius: 12,
                    controller: controller.addSerialController,
                    title: "Invoice Serial No",
                    isTitle: true,
                    readOnly: true,
                    showCursor: false,
                  ),
                ),
              ],
            ),
            Gap(5),
            Text(
              "Invoice Type",
              style: TextStyle(
                fontFamily: FontFamily.poppinsBold,
                fontSize: 18,
                color: Colors.black45,
              ),
            ),
            Gap(5),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        controller.isOpen.value ? AppColors.brandRed : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.zero,
                  dense: true,
                  key: Key(controller.key.toString()),
                  onExpansionChanged: (value) {
                    print("value -- $value");
                    controller.isOpen.value = value;
                    controller.update();
                  },
                  title: Text(
                    controller.addInvoiceTypeController.text,
                  ),
                  children: List.generate(
                    controller.invoiceList.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          controller.addInvoiceTypeController.text =
                              controller.invoiceList[index];
                          controller.nextSerialNoApi();
                          controller.collapse();
                          controller.isOpen.value = false;
                          controller.update();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            controller.invoiceList[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Gap(5),
            CommonTextField(
              borderRadius: 12,
              controller: controller.customerController,
              title: "Customer Name",
              isTitle: true,
              maxLength: 10,
              hintText: "Please Select...",
              showCursor: false,
              readOnly: true,
              onTap: controller.isCustomer
                  ? null
                  : () {
                      controller.selectCustomer();
                    },
              suffix: controller.isCustomer
                  ? null
                  : RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
            ),

            // CommonTextField(
            //   borderRadius: 12,
            //   controller: controller.customerController,
            //   title: AppString.customerName,
            //   isTitle: true,
            //   maxLength: 10,
            //   hintText: "Please Select...",
            //   showCursor: false,
            //   readOnly: true,
            //   onTap: () {
            //     controller.selectCustomer();
            //   },
            //   suffix: RotatedBox(
            //       quarterTurns: 1,
            //       child: Icon(
            //         Icons.arrow_forward_ios,
            //         size: 20,
            //       )),
            // ),
            Gap(5),
            CommonTextField(
                borderRadius: 12,
                controller: controller.addCustomerNumberController,
                title: "Contact Number",
                isTitle: true,
                maxLength: 12,
                textInputType: TextInputType.number,
                readOnly: controller.isCustomer,
                // Disable if the user is a customer
                showCursor: !controller.isCustomer,
                // This will make it not editable if the user is a customer
                onTap: controller.isCustomer
                    ? null // Disable onTap if the user is a customer
                    : () {
                        controller.addCustomerNumberController;
                      } // Regular behavior
                ),
            Gap(5),
            CommonTextField(
              borderRadius: 12,
              controller: controller.addShippingAddressController,
              title: "Shipping Address",
              isTitle: true,
              maxLine: 2,
              textInputType: TextInputType.streetAddress,
            ),
            if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
              Gap(5),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   CommonTextField(
            //     borderRadius: 12,
            //     controller: controller.addDeliveryDateController,
            //     title: AppString.deliveryDate,
            //     isTitle: true,
            //     maxLength: 10,
            //     readOnly: true,
            //     showCursor: false,
            //     onTap: (){
            //       controller.selectDate(context, "delivery");
            //     },
            //     inputFormatters: [
            //       DateInputFormatter(),
            //     ],
            //     suffix: GestureDetector(
            //       onTap: () {
            //         controller.selectDate(context, "delivery");
            //       },
            //       child: Icon(Icons.calendar_month),
            //     ),
            //   ),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   Gap(5),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   CommonTextField(
            //     borderRadius: 12,
            //     controller: controller.addPoDateController,
            //     title: AppString.poDate,
            //     isTitle: true,
            //     maxLength: 10,
            //     showCursor: false,
            //     readOnly: true,
            //     onTap: (){
            //       controller.selectDate(context, "poDate");
            //     },
            //     inputFormatters: [
            //       DateInputFormatter(),
            //     ],
            //     suffix: GestureDetector(
            //       onTap: () {
            //         controller.selectDate(context, "poDate");
            //       },
            //       child: Icon(Icons.calendar_month),
            //     ),
            //   ),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   Gap(5),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   CommonTextField(
            //     borderRadius: 12,
            //     controller: controller.addPoNumberController,
            //     title: AppString.poNumber,
            //     isTitle: true,
            //     textInputType: TextInputType.number,
            //   ),
            if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
              Gap(5),
            if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
              CommonTextField(
                borderRadius: 12,
                controller: controller.addTransportController,
                title: "Transport",
                isTitle: true,
              ),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   Gap(5),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   Text(
            //     AppString.status,
            //     style: TextStyle(
            //       fontFamily: FontFamily.bold,
            //       fontSize: FontSize.s18,
            //       color: Colors.black45,
            //     ),
            //   ),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   Gap(5),
            // if (GetStorageData.readBoolean(GetStorageData.isAdmin) == true)
            //   DecoratedBox(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black38),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Theme(
            //       data: ThemeData(dividerColor: Colors.transparent),
            //       child: ExpansionTile(
            //         childrenPadding: EdgeInsets.zero,
            //         dense: true,
            //         key: Key(controller.key.toString()),
            //         title: Text(
            //           controller.statusController.text,
            //         ),
            //         children: List.generate(
            //           controller.statusList.length,
            //           (index) {
            //             return GestureDetector(
            //               onTap: () {
            //                 controller.statusController.text =
            //                     controller.statusList[index];
            //                 controller.collapse();
            //                 controller.update();
            //               },
            //               child: Padding(
            //                 padding: EdgeInsets.all(8.0),
            //                 child: Text(
            //                   controller.statusList[index],
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            Gap(5),
            CommonTextField(
              borderRadius: 12,
              controller: controller.addRemarkController,
              title: "Remark",
              isTitle: true,
            ),
            Gap(5),
            if (controller.addInvoiceTypeController.text ==
                controller.invoiceList[1])
              Text(
                "Gst Type",
                style: TextStyle(
                  fontFamily: FontFamily.poppinsMedium,
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
            if (controller.addInvoiceTypeController.text ==
                controller.invoiceList[1])
              Gap(5),
            if (controller.addInvoiceTypeController.text ==
                controller.invoiceList[1])
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.isOpen.value
                          ? Colors.blue
                          : Colors.black38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: ThemeData(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    dense: true,
                    key: Key(controller.key.toString()),
                    onExpansionChanged: (value) {
                      print("value -- $value");
                      controller.isOpen.value = value;
                      controller.update();
                    },
                    title: Text(
                      controller.addGstTypeController.text,
                    ),
                    children: List.generate(
                      controller.gstTYpe.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.addGstTypeController.text =
                                controller.gstTYpe[index];
                            controller.collapse();
                            controller.isOpen.value = false;
                            controller.update();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              controller.gstTYpe[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (controller.invoiceController.text == controller.invoiceList[1])
              Gap(5),

            if (controller.itemList.isNotEmpty) Gap(20),
            if (controller.itemList.isNotEmpty) itemData(),
            if (controller.customerId > 0) ...[
            Gap(15),
             CommonButton(
              btnName: "Add Item",
              onTap: () {
                controller.selectedItems.clear();
                controller.itemQuantities.clear();
                selectItemSheet();
              },
            ),
            ],
            Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
              child: Column(
                children: [
                  SalesOrderDetailRow(label: "Total", value: controller.total),
                  SalesOrderDetailRow(
                    label: "(-)DiscountTotal",
                    value: controller.discountTotal,
                  ),
                  SalesOrderDetailRow(
                    label: "(+)CGSTTotal",
                    value: controller.cGstTotal,
                  ),
                  SalesOrderDetailRow(
                    label: "(+)SGSTTotal",
                    value: controller.sGstTotal,
                  ),
                  SalesOrderDetailRow(
                    label: "(+)IGSTTotal",
                    value: controller.iGstTotal,
                  ),
                  SalesOrderDetailRow(
                    label: "TotalItem",
                    value: controller.totalItem,
                  ),
                  const Divider(height: 16),
                  SalesOrderDetailRow(
                    label: "NetTotal",
                    value: controller.netTotal,
                    highlight: true,
                  ),
                ],
              ),
            ),
            Gap(12),
            CommonButton(
              btnName: "Save",
              onTap: () async {
                if (GetStorageData.readBoolean(GetStorageData.isAdmin) ==
                    true) {
                  controller.isAdd.value = false;
                  if (controller.isUpdate) {
                    controller.updateQuotationApi();
                  } else {
                    controller.createQuotationApi();
                  }
                } else {
                  controller.isAdd.value = false;
                  if (controller.isUpdate) {
                    controller.updateQuotationApi();
                  } else {
                    controller.createQuotationApi();
                  }
                }
                controller.isUpdate = false;
                controller.update();
              },
            ),
            Gap(Platform.isIOS ? 25 : 20),
          ],
        );
      },
    );
  }

  Widget itemData() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      dragStartBehavior: DragStartBehavior.start,
      child: DataTable(
        border: TableBorder.all(),
        columns: const <DataColumn>[
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('UNIT')),
          DataColumn(label: Text('QTY')),
          DataColumn(label: Text('PRICE')),
          DataColumn(label: Text('DISCOUNT(%)')),
          DataColumn(label: Text('DISCOUNT')),
          DataColumn(label: Text('TOTAL DISCOUNT')),
          DataColumn(label: Text('GST TEX')),
          DataColumn(label: Text('NETPRICE\n(INC. TEX)')),
          DataColumn(label: Text('CGSTPER')),
          DataColumn(label: Text('CGSTAMT')),
          DataColumn(label: Text('SGSTPER')),
          DataColumn(label: Text('SGSTAMT')),
          DataColumn(label: Text('IGSTPER')),
          DataColumn(label: Text('IGSTAMT')),
          DataColumn(label: Text('TEXABLE\nAMOUNT')),
          DataColumn(label: Text('ACTION')),
        ],
        rows: List.generate(
          controller.itemList.length,
          (index) {
            SaleOrderDetails data = controller.itemList[index];
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(
                  data.itemName ?? "",
                  maxLines: 2,
                )),
                DataCell(Text(data.unit ?? "")),
                DataCell(Text(data.qty.toString())),
                DataCell(Text(data.price.toString())),
                DataCell(Text(data.discountPer.toString())),
                DataCell(Text(data.discount.toString())),
                DataCell(Text(data.totalDiscount.toString())),
                DataCell(Text(data.gstcodeId.toString())),
                DataCell(Text(data.netPriceINCTax.toString())),
                DataCell(Text(data.cgstPer.toString())),
                DataCell(Text(data.cgstAmount.toString())),
                DataCell(Text(data.sgstPer.toString())),
                DataCell(Text(data.sgstAmount.toString())),
                DataCell(Text(data.igstPer.toString())),
                DataCell(Text(data.igstAmount.toString())),
                DataCell(Text(data.taxableAmount.toString())),
                DataCell(
                  Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    controller.removeItem(index); // Function to remove item
                    controller.calculateGstAndDiscountForAllItems();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget commonTableText({String? title, bool? isLight, bool? isEnd}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        title ?? "",
        textAlign: isEnd == true ? TextAlign.end : TextAlign.start,
        style: TextStyle(
          fontSize: 16,
          color: isLight == true ? Colors.black45 : Colors.black,
          fontFamily: FontFamily.poppinsMedium,
        ),
      ),
    );
  }

  selectItemSheet() {
    filteredItems = ApiConstant.categoryWiseItemList;
    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SalesOrderSheetHeader(
                title: "Select Item",
                subtitle: "Search items by name, category or brand",
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: TextField(
                  controller: controller.searchFieldController,
                  onChanged: (value) {
                    controller.categoryWiseFilterItems(value);
                  },
                  decoration: salesOrderSearchDecoration(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Obx(() {
                  final selectedCategory =
                      controller.selectedCategoryBrandData.value;
                  final hasCategory = selectedCategory.categoryName != null;
                  return SalesOrderFilterField(
                    label: selectedCategory.categoryName ?? "Select Category",
                    hasValue: hasCategory,
                    onTap: () => openCategorySelection(controller),
                    onClear: () async {
                      await controller.clearCategorySelection();
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Obx(() {
                  final selectedBrand = controller.selectedBrandData.value;
                  final hasBrand = selectedBrand.brandName != null;
                  return SalesOrderFilterField(
                    label: selectedBrand.brandName ?? "Select Brand",
                    hasValue: hasBrand,
                    onTap: () => openBrandSelection(controller),
                    onClear: () {
                      controller.selectedBrandData.value = BranddData();
                      controller.validationForApiCall();
                    },
                  );
                }),
              ),
              Expanded(
                child: Obx(() {
                  final items = controller.categoryWisefilteredItemss;
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Obx(() {
                        final selected = controller.isSelected(item);
                        return SalesOrderItemTile(
                          imageUrl: item.imageUrl,
                          itemName: item.itemName ?? '',
                          price: (item.price ?? 0).toString(),
                          isSelected: selected,
                          quantity: controller.getQuantity(item),
                          onTap: () {
                            if (!controller.isSelected(item)) {
                              controller.toggleSelection(item);
                            }
                            if (controller.isSelected(item)) {
                              _showQtyDialog(context, item);
                            }
                          },
                          onCheckboxChanged: (_) {
                            controller.toggleSelection(item);
                            if (controller.isSelected(item)) {
                              _showQtyDialog(context, item);
                            }
                          },
                        );
                      });
                    },
                  );
                }),
              ),
              Obx(() {
                if (controller.selectedItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: CommonButton(
                      btnName: "Add Items",
                      onTap: () {
                        for (var item in controller.selectedItems) {
                          final qty = controller.itemQuantities[item] ?? 0;
                          if (qty <= 0) {
                            Get.snackbar(
                              "Error",
                              "Please add quantity for '${item.itemName}'.",
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 70,
                              ),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                        }
                        controller.calculateGstAndDiscountForSelectedItems();
                        Get.back();
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showQtyDialog(BuildContext context, ItemData item) {
    final existingQty = controller.itemQuantities.containsKey(item)
        ? controller.itemQuantities[item].toString()
        : "";
    final qtyController = TextEditingController(text: existingQty);

    showDialog(
      context: context,
      builder: (context) {
        return SalesOrderQtyDialog(
          itemName: item.itemName ?? '',
          imageUrl: item.imageUrl,
          rate: (item.price ?? 0).toString(),
          qtyController: qtyController,
          onConfirm: () {
            final qty = qtyController.text.trim();
            controller.updateQuantity(item, qty);
            if (qty.isEmpty ||
                int.tryParse(qty) == null ||
                int.parse(qty) <= 0) {
              Get.snackbar(
                "Error",
                "Please enter a valid quantity!",
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 70,
                ),
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // selectItemSheet() {
  //   filteredItems = Constants.itemList;
  //   Get.bottomSheet(
  //     isScrollControlled: true,
  //     Padding(
  //       padding: EdgeInsets.only(top: AppBar().preferredSize.height),
  //       child: DecoratedBox(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(24),
  //             ),
  //             color: Colors.white),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Gap(10),
  //             Text(
  //               "Select Item",
  //               style: TextStyle(
  //                 fontSize: FontSize.s22,
  //                 color: Colors.black,
  //                 fontFamily: FontFamily.semiBold,
  //               ),
  //             ),
  //             Gap(10),
  //             Divider(
  //               color: Colors.black,
  //             ),
  //             Gap(10),
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(20, 5, 20, 8),
  //               child: CommonTextField(
  //                 controller: controller.searchFieldController,
  //                 borderRadius: 12,
  //                 prefix: Icon(Icons.search),
  //                 onChanged: (p0) {
  //                   controller.filterItems(p0);
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: filteredItems.length,
  //                 padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //                 itemBuilder: (context, index) {
  //                   return Padding(
  //                     padding: EdgeInsets.only(bottom: 6),
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         Get.back();
  //                         addItemSheet(filteredItems[index]);
  //                       },
  //                       child: DecoratedBox(
  //                         decoration: BoxDecoration(
  //                             border: Border.all(),
  //                             borderRadius: BorderRadius.circular(12)),
  //                         child: commonTableText(
  //                             title: filteredItems[index].itemName ?? ""),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void openCategorySelection(SalesOrderController controller) async {
    await controller.ensureFilterListsLoaded();
    controller.filteredCategoryBrands.value =
        ApiConstant.categoryBrandList; // Initialize observable list

    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SalesOrderSheetHeader(
                title: "Select Category",
                subtitle: "Search and choose a category",
              ),
              Gap(12),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  onChanged: (value) {
                    controller.categoryFilter(value);
                  },
                  decoration: salesOrderSearchDecoration(),
                ),
              ),
              Gap(10),
              // Obx(() {
              //   return Expanded(
              //     child: ListView.builder(
              //       itemCount: controller.filteredCategoryBrands.length,
              //       // Use observable
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       itemBuilder: (context, index) {
              //         final category = controller.filteredCategoryBrands[index];
              //         return Padding(
              //           padding: EdgeInsets.only(bottom: 12),
              //           child: GestureDetector(
              //             onTap: () {
              //               controller.selectCategory(category);
              //               controller.validationForApiCall();
              //               Get.back();
              //             },
              //             child: DecoratedBox(
              //               decoration: BoxDecoration(
              //                 border: Border.all(color: Colors.grey),
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               child: Row(
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.all(3.0),
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(12),
              //                       child: Image.network(
              //                         category.imageUrl!,
              //                         width: 60,
              //                         height: 60,
              //                         fit: BoxFit.fill,
              //                         errorBuilder:
              //                             (context, error, stackTrace) {
              //                           return Padding(
              //                             padding: const EdgeInsets.all(5.0),
              //                             child: Image.asset(
              //                               AppImages.appIcon_g,
              //                               width: 40,
              //                               height: 40,
              //                               fit: BoxFit.fill,
              //                             ),
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(width: 12),
              //                   Expanded(
              //                     child: Text(
              //                       category.categoryName!,
              //                       style: TextStyle(
              //                         fontSize: 16,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   );
              // }),

              Obx(() {
                return Expanded(
                  child: GridView.builder(
                    itemCount: controller.filteredCategoryBrands.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ Two items per row
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final category = controller.filteredCategoryBrands[index];

                      return GestureDetector(
                        onTap: () async {
                          Get.back();
                          await controller.onCategorySelected(
                            Get.context!,
                            category,
                          );
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ✅ Image at top (no padding)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  category.imageUrl ?? '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppImages.logoImg,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),

                              // Space between image & text
                              const SizedBox(height: 6),

                              // ✅ Text below image (no padding wrapper)
                              Text(
                                category.categoryName ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              })

            ],
          ),
        ),
      ),
    );
  }

  void openBrandSelection(SalesOrderController controller) async {
    await controller.ensureFilterListsLoaded();

    final categoryId = controller.selectedCategoryBrandData.value.categoryID;
    if (categoryId != null) {
      await controller.getBrandListByCategoryApi(Get.context!, categoryId);
    } else {
      controller.filteredBrands.value = ApiConstant.brandList;
    }

    Get.bottomSheet(
      isScrollControlled: true,
      Padding(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SalesOrderSheetHeader(
                title: "Select Brand",
                subtitle: "Search and choose a brand",
              ),
              Gap(12),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  onChanged: (value) {
                    controller.brandFilter(value);
                  },
                  decoration: salesOrderSearchDecoration(hint: "Enter brand to search"),
                ),
              ),
              Gap(10),
              // Obx(() {
              //   return Expanded(
              //     child: ListView.builder(
              //       itemCount: controller.filteredBrands.length,
              //       // ✅ Use observable
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       itemBuilder: (context, index) {
              //         final brand = controller
              //             .filteredBrands[index]; // ✅ Updated variable
              //         return Padding(
              //           padding: EdgeInsets.only(bottom: 12),
              //           child: GestureDetector(
              //             onTap: () {
              //               controller.selectBrand(brand);
              //               controller.validationForApiCall();
              //               Get.back();
              //             },
              //             child: DecoratedBox(
              //               decoration: BoxDecoration(
              //                 border: Border.all(color: Colors.grey),
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               child: Row(
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.all(3.0),
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(12),
              //                       child: Image.network(
              //                         brand.imageUrl!,
              //                         width: 60,
              //                         height: 60,
              //                         fit: BoxFit.fill,
              //                         errorBuilder:
              //                             (context, error, stackTrace) {
              //                           return Padding(
              //                             padding: const EdgeInsets.all(5.0),
              //                             child: Image.asset(
              //                               AppImages.appIcon_g,
              //                               width: 40,
              //                               height: 40,
              //                               fit: BoxFit.fill,
              //                             ),
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(width: 12),
              //                   Expanded(
              //                     child: Text(
              //                       brand.brandName!,
              //                       style: TextStyle(
              //                         fontSize: 16,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   );
              // }),

              Obx(() {
                return Expanded(
                  child: GridView.builder(
                    itemCount: controller.filteredBrands.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ✅ Two items per row
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final brand = controller.filteredBrands[index];

                      return GestureDetector(
                        onTap: () {
                          controller.selectBrand(brand);
                          controller.validationForApiCall();
                          Get.back();
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 🖼 Brand image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    brand.imageUrl ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.asset(
                                          AppImages.logoImg,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // 🏷 Brand name
                                Text(
                                  brand.brandName ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              })


            ],
          ),
        ),
      ),
    );
  }


  addItemSheet(ItemData filteredItem) {
    controller.itemUnitController.text = filteredItem.unitCode ?? "";
    controller.itemQtyController.text = "1";
    controller.itemDiscountPerController.text = "0";
    controller.itemDiscountController.text = "0";
    controller.itemTotalDiscountController.text = "0";
    controller.itemPriceController.text = filteredItem.price.toString();
    controller.itemGrossAmountController.text = filteredItem.price.toString();
    for (int i = 0; i < ApiConstant.gstList.length; i++) {
      if (ApiConstant.gstList[i].gstCodeId == filteredItem.gstCodeId) {
        controller.addGstController.text =
            ApiConstant.gstList[i].gstTaxName ?? "";
        controller.gstId = ApiConstant.gstList[i].gstCodeId ?? 0;
      }
    }
    controller.calculateGstAndDiscount();
    Get.bottomSheet(
      GetBuilder<SalesOrderController>(
        builder: (controller) {
          return DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SalesOrderSheetHeader(
                  title: filteredItem.itemName ?? "Item Details",
                  subtitle: "Update quantity, price and tax",
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Gap(10),
                      CommonTextField(
                        borderRadius: 12,
                        controller: controller.itemUnitController,
                        title: "Unit",
                        isTitle: true,
                      ),
                      Gap(10),
                      CommonTextField(
                        borderRadius: 12,
                        controller: controller.itemQtyController,
                        title: "Qty",
                        isTitle: true,
                        onChanged: (p0) {
                          controller.calculateGstAndDiscount();
                        },
                      ),
                      Gap(10),
                      CommonTextField(
                        borderRadius: 12,
                        controller: controller.itemPriceController,
                        title: "Price",
                        isTitle: true,
                        onChanged: (p0) {
                          controller.calculateGstAndDiscount();
                        },
                      ),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        Gap(10),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        Text(
                          "Gst Tax",
                          style: TextStyle(
                            fontFamily: FontFamily.poppinsMedium,
                            fontSize: 16,
                            color: Colors.black38,
                          ),
                        ),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        Gap(8),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: controller.isOpen.value
                                    ? Colors.blue
                                    : Colors.black38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Theme(
                            data: ThemeData(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              childrenPadding: EdgeInsets.zero,
                              dense: true,
                              key: Key(controller.key.toString()),
                              onExpansionChanged: (value) {
                                print("value -- $value");
                                controller.isOpen.value = value;
                                controller.update();
                              },
                              title: Text(
                                controller.addGstController.text,
                              ),
                              children: List.generate(
                                ApiConstant.gstList.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.addGstController.text =
                                          ApiConstant.gstList[index].gstTaxName ??
                                              "";
                                      controller.gstId =
                                          ApiConstant.gstList[index].gstCodeId ??
                                              0;
                                      controller.calculateGstAndDiscount();
                                      controller.collapse();
                                      controller.isOpen.value = false;
                                      controller.update();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.gstList[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller: controller.itemDiscountPerController,
                              title: "Discount Per",
                              isTitle: true,
                              onChanged: (p0) {
                                controller.calculateGstAndDiscount();
                              },
                            ),
                          ),
                          Gap(12),
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller: controller.itemDiscountController,
                              title: "Discount",
                              isTitle: true,
                              readOnly: true,
                              showCursor: false,
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller:
                                  controller.itemTotalDiscountController,
                              title: "TotalDiscount",
                              isTitle: true,
                              readOnly: true,
                              showCursor: false,
                            ),
                          ),
                          Gap(12),
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller: controller.itemNetPriceController,
                              title: "NetPrice",
                              isTitle: true,
                              readOnly: true,
                              showCursor: false,
                            ),
                          ),
                        ],
                      ),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text != 'IGST')
                          Gap(10),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text != 'IGST')
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemCGstPerController,
                                  title: "CGST Per",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                              Gap(12),
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemCGstAmtController,
                                  title: "CGST Amt",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                            ],
                          ),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text != 'IGST')
                          Gap(10),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text != 'IGST')
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemSGstPerController,
                                  title: "SGST Per",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                              Gap(12),
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemSGstAmtController,
                                  title: "SGSTAmt",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                            ],
                          ),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text == 'IGST')
                          Gap(10),
                      if (controller.addGstTypeController.text.isNotEmpty)
                        if (controller.addGstTypeController.text == 'IGST')
                          Row(
                            children: [
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemIGstPerController,
                                  title: "IGSTPer",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                              Gap(12),
                              Expanded(
                                child: CommonTextField(
                                  borderRadius: 12,
                                  controller: controller.itemIGstAmtController,
                                  title: "IGSTAmt",
                                  isTitle: true,
                                  readOnly: true,
                                  showCursor: false,
                                ),
                              ),
                            ],
                          ),
                      Gap(10),
                      CommonTextField(
                        borderRadius: 12,
                        controller: controller.itemTaxablePriceController,
                        title: "Taxable Amount",
                        isTitle: true,
                        readOnly: true,
                        showCursor: false,
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller: controller.itemNetAmountController,
                              title: "Net Amount",
                              isTitle: true,
                              readOnly: true,
                              showCursor: false,
                            ),
                          ),
                          Gap(12),
                          Expanded(
                            child: CommonTextField(
                              borderRadius: 12,
                              controller: controller.itemGrossAmountController,
                              title: "Gross Amount",
                              isTitle: true,
                              readOnly: true,
                              showCursor: false,
                            ),
                          ),
                        ],
                      ),
                      Gap(25),
                      CommonButton(
                        btnName: "Save",
                        onTap: () {
                          controller.total =
                              (int.parse(controller.itemQtyController.text) *
                                      double.parse(
                                          controller.itemPriceController.text))
                                  .toStringAsFixed(2)
                                  .toString();
                          controller.discountTotal =
                              controller.itemTotalDiscountController.text;
                          controller.sGstTotal =
                              controller.itemSGstAmtController.text;
                          controller.cGstTotal =
                              controller.itemCGstAmtController.text;
                          controller.iGstTotal =
                              controller.itemIGstAmtController.text;
                          controller.iGstTotal =
                              controller.itemIGstAmtController.text;
                          controller.totalItem =
                              controller.itemList.length.toString();
                          controller.netTotal =
                              controller.itemNetAmountController.text;
                          controller.itemList.add(SaleOrderDetails(
                            itemId: filteredItem.itemid,
                            itemName: filteredItem.itemName,
                            unit: controller.itemUnitController.text,
                            qty:
                                double.parse(controller.itemQtyController.text),
                            price: double.parse(
                                controller.itemPriceController.text),
                            discountPer: double.parse(
                                controller.itemDiscountPerController.text),
                            discount: double.parse(
                                controller.itemDiscountController.text),
                            totalDiscount: double.parse(
                                controller.itemTotalDiscountController.text),
                            gstcodeId: controller.gstId,
                            netPriceINCTax: double.parse(
                                controller.itemNetPriceController.text),
                            cgstPer: double.parse(
                                controller.itemCGstPerController.text),
                            cgstAmount: double.parse(
                                controller.itemCGstAmtController.text),
                            sgstPer: double.parse(
                                controller.itemSGstPerController.text),
                            sgstAmount: double.parse(
                                controller.itemSGstAmtController.text),
                            igstPer: double.parse(
                                controller.itemIGstPerController.text),
                            igstAmount: double.parse(
                                controller.itemIGstAmtController.text),
                            taxableAmount: double.parse(
                                controller.itemTaxablePriceController.text),
                            netAmount: double.parse(
                                controller.itemNetAmountController.text),
                            grossAmount: double.parse(
                                controller.itemGrossAmountController.text),
                          ));
                          controller.update();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                Gap(30),
              ],
            ),
          );
        },
      ),
    );
  }
}
