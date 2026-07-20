import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Screen/Sale Order/Model/quoation_list_model.dart';
import 'package:saral/View/Screen/Sale Order/controllers/sales_order_controller.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_add_view.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_form_ui.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';

class SalesOrderView extends GetView<SalesOrderController> {
  const SalesOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesOrderController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xffF8F8F8),
          appBar: CommonAppBar(
            title: "Sale Order",
            showBackButton: true,
            actions: controller.isAdd.value
                ? []
                : [
                    GestureDetector(
                      onTap: () => controller.filterSheet(context),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
          ),
          floatingActionButton: controller.isAdd.value
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  backgroundColor: AppColors.brandRed,
                  onPressed: () {
                    controller.addDateController.text =
                        DateFormat("dd/MM/yyyy").format(DateTime.now());
                    controller.isAdd.value = true;
                    controller.isUpdate = false;
                    controller.nextSerialNoApi();
                    controller.update();
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
          body: Obx(() {
            if (controller.isAdd.value) {
              return const SalesOrderAddView();
            }

            if (controller.isLoading.value) {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.brandRed,
                  size: 50,
                ),
              );
            }

            if (controller.quotationList.isEmpty) {
              return Utils().noDataFound(context, controller.isData);
            }

            return ListView.builder(
              itemCount: controller.quotationList.length,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              itemBuilder: (context, index) {
                final QuotationData model = controller.quotationList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SalesOrderListCard(
                    salesOrderId: model.salesOrderID.toString(),
                    customerName: model.customerName,
                    netAmount: model.netAmount?.toString(),
                    orderNumber: model.orderNumber,
                    date: model.date,
                    salesPerson: model.salesPerson,
                    contactNumber: model.contactNumber,
                    invoiceType: model.invoiceType,
                    allowEditEntry: model.allowEditEntry,
                    allowDeleteEntry: model.allowDeleteEntry,
                    onExpansionChanged: (_) => controller.update(),
                    onEdit: () {
                      controller.isAdd.value = true;
                      controller.isUpdate = true;
                      controller.quotationDataApi(model.salesOrderID ?? 0);
                      controller.saleId =
                          (model.salesOrderID ?? 0).toString();
                    },
                    onPdf: () =>
                        controller.quotationPDFApi(model.salesOrderID ?? 0),
                    onDelete: () {
                      Get.dialog(
                        SalesOrderDeleteDialog(
                          onConfirm: () {
                            controller
                                .deleteQuotationApi(model.salesOrderID ?? 0);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
