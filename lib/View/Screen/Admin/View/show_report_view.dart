import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Admin/Controller/show_report_controller.dart';
import 'package:saral/View/Screen/Admin/Model/monthly_total_purchase_model.dart';
import 'package:saral/View/Screen/Admin/Model/monthly_total_sale_model.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class ShowReportView extends GetView<ShowReportController> {
  const ShowReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowReportController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: controller.reportTitle,
            showDrawer: false,
            showBackButton: true,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            clipBehavior: Clip.antiAlias,
            child: RefreshIndicator(
            color: AppColors.brandRed,
            onRefresh: controller.refresh,
            child: Obx(() {
              // While CommonLoader is showing, keep a full-height scroll body
              // so RefreshIndicator does not re-trigger load in a loop.
              if (controller.isLoading.value &&
                  controller.monthlySaleList.isEmpty &&
                  controller.monthlyPurchaseList.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: constraints.maxHeight),
                      ],
                    );
                  },
                );
              }

              if (controller.isPurchaseReport) {
                return _PurchaseList(controller: controller);
              }
              return _SaleList(controller: controller);
            }),
          ),
          ),
        );
      },
    );
  }
}

class _SaleList extends StatelessWidget {
  const _SaleList({required this.controller});

  final ShowReportController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.monthlySaleList.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    CommonText(
                      text: 'No sales found',
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: controller.monthlySaleList.length,
      itemBuilder: (context, index) {
        final model = controller.monthlySaleList[index];
        return _SaleCard(model: model);
      },
    );
  }
}

class _PurchaseList extends StatelessWidget {
  const _PurchaseList({required this.controller});

  final ShowReportController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.monthlyPurchaseList.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    CommonText(
                      text: 'No purchases found',
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: controller.monthlyPurchaseList.length,
      itemBuilder: (context, index) {
        final model = controller.monthlyPurchaseList[index];
        return _PurchaseCard(model: model);
      },
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.model});

  final MonthlySaleData model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: model.custName ?? '-',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: 'Serial No. ${model.billSrNo ?? '-'}',
                  fontFamily: FontFamily.poppinsRegular,
                  fontSize: 12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: '₹ ${_fmt(model.netAmount)}',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ],
            ),
            children: [
              _detail('Customer Name', model.custName),
              _detail('DT', model.date),
              _detail('Bill Sr No.', model.billSrNo),
              _detail('Gross Amount', _fmt(model.grossAmount)),
              _detail('Sale Type', model.saleType),
              _detail('Discount', _fmt(model.discount)),
              _detail('Ship To', model.shipTo),
              _detail('Contact No.', model.contactNo),
              _detail('Credit Days', model.creditDays?.toString()),
              _detail('Invoice Type', model.invoiceType),
              _detail('Paid', _fmt(model.paid)),
              _detail('Total Outstanding', _fmt(model.totalOutstanding)),
              _detail('Net Payable Amount', _fmt(model.netPayableAmount)),
              _detail(
                  'Sale Amount Ex. Discount', _fmt(model.saleAmountExDiscount)),
              _detail(
                  'Total Item Discount', _fmt(model.totalItemDiscount)),
              _detail('Net Amount', _fmt(model.netAmount)),
              _detail('Sale Amount Inc. Discount',
                  _fmt(model.saleAmountIncDiscount)),
              _detail('IGST Per', _fmt(model.igstPer)),
              _detail('IGST Amt', _fmt(model.igstAmt)),
              _detail('CGST Per', _fmt(model.cgstPer)),
              _detail('CGST Amt', _fmt(model.cgstAmt)),
              _detail('SGST Per', _fmt(model.sgstPer)),
              _detail('SGST Amt', _fmt(model.sgstAmt)),
              _detail('Tax Mode', model.taxMode),
              _detail('GST Type', model.gstType),
              _detail('GSTIN Number', model.gstinNumber),
              _detail('Customer GST Type', model.customerGSTType),
              _detail('Sale Taxable AMT', _fmt(model.saleTaxableAmt)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({required this.model});

  final MonhtlyPurchaseData model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: model.partyname ?? '-',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: 'Voucher No. ${model.voucherNo ?? '-'}',
                  fontFamily: FontFamily.poppinsRegular,
                  fontSize: 12,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: '₹ ${_fmt(model.purchaseAmount)}',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 14,
                  color: Colors.green.shade700,
                ),
              ],
            ),
            children: [
              _detail('Party Name', model.partyname),
              _detail('Voucher No.', model.voucherNo?.toString()),
              _detail('DT', model.date),
              _detail('Paid', _fmt(model.paid)),
              _detail('Discount', _fmt(model.discount)),
              _detail('Invoice Type', model.invoiceType),
              _detail('Total Outstanding', _fmt(model.totalOutstanding)),
              _detail('Purchase Amount', _fmt(model.purchaseAmount)),
              _detail('Payable Amount', _fmt(model.payableAmount)),
              _detail('Net Payable', _fmt(model.netPayable)),
              _detail('IGST Per', _fmt(model.igstPer)),
              _detail('IGST Amt', _fmt(model.igstAmt)),
              _detail('CGST Per', _fmt(model.cgstPer)),
              _detail('CGST Amt', _fmt(model.cgstAmt)),
              _detail('SGST Per', _fmt(model.sgstPer)),
              _detail('SGST Amt', _fmt(model.sgstAmt)),
              _detail('Tax Mode', model.taxMode),
              _detail('GST Type', model.gstType),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _detail(String title, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$title:',
            style: TextStyle(
              fontFamily: FontFamily.poppinsSemiBold,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            (value == null || value.isEmpty) ? '-' : value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    ),
  );
}

String _fmt(dynamic value) {
  if (value == null) return '-';
  if (value is num) return value.toStringAsFixed(2);
  return value.toString();
}
