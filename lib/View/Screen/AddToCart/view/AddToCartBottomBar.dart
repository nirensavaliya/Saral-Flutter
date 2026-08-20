import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';

class AddToCartBottomBar extends StatelessWidget {
  const AddToCartBottomBar({
    super.key,
    required this.totals,
    this.gstType = '',
    this.onPlaceOrder,
    this.isPlacingOrder = false,
    this.buttonName = "Place Order",
  });

  final Map<String, String> totals;
  final String gstType;
  final VoidCallback? onPlaceOrder;
  final bool isPlacingOrder;
  final String buttonName;

  bool get _isIgst => gstType.trim().toUpperCase() == 'IGST';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: "Final Total",
              fontFamily: FontFamily.poppinsSemiBold,
              fontSize: 16,
              color: Colors.black87,
            ),
            const SizedBox(height: 5),
            _summaryRow("Total", totals['total'] ?? '0.00'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _summaryRow(
                        "Dis. Total",
                        totals['discountTotal'] ?? '0.00',
                        muted: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                if (_isIgst)
                  Expanded(
                    child: Column(
                      children: [
                        _summaryRow(
                          "IGST",
                          totals['iGstTotal'] ?? '0.00',
                          muted: true,
                        ),
                      ],
                    ),
                  )
                else ...[
                  Expanded(
                    child: Column(
                      children: [
                        _summaryRow(
                          "CGST",
                          totals['cGstTotal'] ?? '0.00',
                          muted: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _summaryRow(
                          "SGST",
                          totals['sGstTotal'] ?? '0.00',
                          muted: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            _summaryRow(
              "TotalItem",
              totals['totalItem'] ?? '0',
              muted: true,
            ),
            Divider(color: Colors.grey.shade300, height: 16),
            _summaryRow(
              "NetTotal",
              totals['netTotal'] ?? '0.00',
              bold: true,
              highlight: true,
            ),
            const SizedBox(height: 10),
            CommonButton(
              btnName: buttonName,
              isLoading: isPlacingOrder,
              onTap: onPlaceOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool muted = false,
    bool bold = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: CommonText(
              text: label,
              fontFamily: bold
                  ? FontFamily.poppinsBold
                  : FontFamily.poppinsMedium,
              fontSize: 13,
              color: muted ? Colors.black54 : Colors.black87,
            ),
          ),
          CommonText(
            text: value,
            fontFamily: bold
                ? FontFamily.poppinsBold
                : FontFamily.poppinsSemiBold,
            fontSize: bold ? 15 : 13,
            color: highlight ? AppColors.brandRed : Colors.black87,
          ),
        ],
      ),
    );
  }
}
