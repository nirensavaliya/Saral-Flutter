import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Pending Sale Order/Controller/pedning_sale_order_controller.dart';
import 'package:saral/View/Screen/Pending Sale Order/Model/pending_sale_order_model.dart';
import 'package:saral/View/Screen/Sale Order/views/sales_order_form_ui.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

import '../../Sale Order/Model/quoation_list_model.dart';

class PendingSaleOrderView extends GetView<PendingSaleOrderController> {
  const PendingSaleOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PendingSaleOrderController>()) {
      Get.put(PendingSaleOrderController());
    }
    return GetBuilder<PendingSaleOrderController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: "Today Sale Orders",
            showBackButton: Navigator.canPop(context),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: AppColors.btnColors,
          //   onPressed: () {
          //     // controller.genaratePDFApi();
          //   },
          //   child: const Icon(
          //     Icons.picture_as_pdf_outlined,
          //     color: Colors.white,
          //     size: 28,
          //   ),
          // ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Obx(() {
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
                        // controller.isAdd.value = true;
                        // controller.isUpdate = true;
                        // controller.quotationDataApi(model.salesOrderID ?? 0);
                        // controller.saleId =
                        //     (model.salesOrderID ?? 0).toString();
                      },
                      onPdf: () {
                        // controller.quotationPDFApi(model.salesOrderID ?? 0),
                      },
                      onDelete: () {
                        // Get.dialog(
                        //   SalesOrderDeleteDialog(
                        //     onConfirm: () {
                        //       controller
                        //           .deleteQuotationApi(model.salesOrderID ?? 0);
                        //     },
                        //   ),
                        // );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}

class _PendingSaleOrderCard extends StatelessWidget {
  const _PendingSaleOrderCard({required this.order});

  final PendingSaleOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.pending_actions_outlined,
                    color: AppColors.brandRed,
                    size: 22,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CommonText(
                    text: 'Order No: ${order.orderNo ?? ''}',
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          SalesOrderDetailRow(
            label: 'Customer',
            value: order.customerName,
          ),
          SalesOrderDetailRow(
            label: 'Item',
            value: order.itemName,
          ),
          SalesOrderDetailRow(
            label: 'Ordered',
            value: order.ordered?.toString(),
          ),
          SalesOrderDetailRow(
            label: 'Delivered',
            value: order.delivered?.toString(),
          ),
          SalesOrderDetailRow(
            label: 'Pending',
            value: order.pending?.toString(),
            highlight: true,
          ),
          SalesOrderDetailRow(
            label: 'Remarks',
            value: (order.remarks == null || order.remarks!.isEmpty)
                ? 'None'
                : order.remarks,
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
