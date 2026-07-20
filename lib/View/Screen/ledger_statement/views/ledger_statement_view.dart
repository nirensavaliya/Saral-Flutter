import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import '../../../../Common/Global.dart';
import '../../../Widget/Common_AppBar.dart';
import '../../../Widget/common_button.dart';
import '../../../Widget/common_textfild.dart';
import '../controllers/ledger_statement_controller.dart';
import '../model/ledger_statement_model.dart';

class LedgerStatementView extends GetView<LedgerStatementController> {
  const LedgerStatementView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LedgerStatementController>(
      init: LedgerStatementController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.brandRed,
          appBar: CommonAppBar(
            title: "Ledger Statement",
            showDrawer: !Navigator.canPop(context),
            showBackButton: Navigator.canPop(context),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              CommonTextField(
                borderRadius: 12,
                controller: controller.fromDateController,
                title: "From Date",
                isTitle: true,
                maxLength: 10,
                showCursor: false,
                readOnly: true,
                inputFormatters: [
                  DateInputFormatter(),
                ],
                onTap: () {
                  controller.selectDate(context, "from");
                },
                suffix: GestureDetector(
                  onTap: () {
                    controller.selectDate(context, "from");
                  },
                  child: const Icon(Icons.calendar_month),
                ),
              ),
              const Gap(15),
              CommonTextField(
                borderRadius: 12,
                controller: controller.toDateController,
                title: "To Date",
                isTitle: true,
                maxLength: 10,
                showCursor: false,
                readOnly: true,
                inputFormatters: [
                  DateInputFormatter(),
                ],
                onTap: () {
                  controller.selectDate(context, "to");
                },
                suffix: GestureDetector(
                  onTap: () {
                    controller.selectDate(context, "to");
                  },
                  child: const Icon(Icons.calendar_month),
                ),
              ),
              const Gap(15),
              CommonTextField(
                borderRadius: 12,
                controller: controller.ledgerController,
                title: "Ledger",
                isTitle: true,
                maxLength: 10,
                hintText: "Please Select...",
                showCursor: false,
                readOnly: true,
                onTap: () {
                  if (!isLoggedIn) {
                    Global.showLoginRequiredDialog();
                    return;
                  }
                  controller.selectLedger();
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
              if (controller.ledgerList.isNotEmpty)
                CommonButton(
                  btnName: "Download PDF",
                  onTap: () {
                    controller.genaratePDFApi();
                  },
                ),
              if (controller.ledgerList.isNotEmpty) ...[
                const Gap(20),
                Row(
                  children: [
                    CommonText(
                      text: "Transactions",
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    const Spacer(),
                    CommonText(
                      text: "${controller.ledgerList.length} entries",
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const Gap(12),
              ],
              _ledgerListView(controller),
            ],
          ),
          ),
        );
      },
    );
  }

  Widget _ledgerListView(LedgerStatementController controller) {
    if (controller.ledgerList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const Gap(10),
            CommonText(
              text: "No ledger entries",
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 14,
              color: Colors.grey,
            ),
            const Gap(4),
            CommonText(
              text: "Select ledger to view statement",
              fontFamily: FontFamily.poppinsRegular,
              fontSize: 12,
              color: Colors.grey,
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(controller.ledgerList.length, (index) {
        final ledger = controller.ledgerList[index];
        final isSelected = controller.selectedLedger == ledger;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _LedgerEntryCard(
            ledger: ledger,
            isSelected: isSelected,
            onTap: () {
              controller.selectLedgerRow(ledger);
            },
          ),
        );
      }),
    );
  }
}

class _LedgerEntryCard extends StatelessWidget {
  const _LedgerEntryCard({
    required this.ledger,
    required this.isSelected,
    required this.onTap,
  });

  final ledgerData ledger;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.brandRed.withOpacity(0.45)
                  : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("GLDATE", ledger.glDate),
              _detailRow("DESCRIPTION", ledger.description),
              _detailRow("ACCOUNT", ledger.account),
              _detailRow("TRANSACTION", ledger.transaction),
              _detailRow("TRANSCHANNEL", ledger.transChannel),
              _detailRow("SRNO", ledger.serialNumber),
              _detailRow("CR", ledger.cr?.toString()),
              _detailRow("DR", ledger.dr?.toString()),
              _detailRow("REMARK", ledger.remarks),
              _detailRow("BALANCE", ledger.balance, isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String? value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: CommonText(
              text: "$title:",
              fontFamily: FontFamily.poppinsSemiBold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const Gap(8),
          Expanded(
            child: CommonText(
              text: (value == null || value.isEmpty) ? "-" : value,
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
