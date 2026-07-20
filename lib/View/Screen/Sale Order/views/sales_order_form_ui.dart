import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';

class SalesOrderFormSection extends StatelessWidget {
  const SalesOrderFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.brandRed, size: 18),
              ),
              const Gap(10),
              CommonText(
                text: title,
                fontFamily: FontFamily.poppinsSemiBold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ],
          ),
          const Gap(14),
          ...children,
        ],
      ),
    );
  }
}

class SalesOrderSheetHeader extends StatelessWidget {
  const SalesOrderSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.brandRed,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(12),
          CommonText(
            text: title,
            fontFamily: FontFamily.poppinsSemiBold,
            fontSize: 18,
            color: Colors.white,
          ),
          if (subtitle != null) ...[
            const Gap(4),
            CommonText(
              text: subtitle!,
              fontFamily: FontFamily.poppinsRegular,
              fontSize: 12,
              color: Colors.white70,
            ),
          ],
        ],
      ),
    );
  }
}

class SalesOrderDetailRow extends StatelessWidget {
  const SalesOrderDetailRow({
    super.key,
    required this.label,
    this.value,
    this.highlight = false,
  });

  final String label;
  final String? value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CommonText(
              text: label,
              fontFamily: FontFamily.poppinsMedium,
              fontSize: 12,
              color: const Color(0xFF78829A),
            ),
          ),
          Expanded(
            flex: 3,
            child: CommonText(
              text: value ?? '',
              textAlign: TextAlign.end,
              fontFamily: highlight
                  ? FontFamily.poppinsBold
                  : FontFamily.poppinsSemiBold,
              fontSize: highlight ? 15 : 13,
              color: highlight ? AppColors.brandRed : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SalesOrderSheetOptionTile extends StatelessWidget {
  const SalesOrderSheetOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isSelected = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandRed.withOpacity(0.08)
                : const Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.brandRed
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: title,
                fontFamily: FontFamily.poppinsSemiBold,
                fontSize: 14,
                color: Colors.black87,
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const Gap(4),
                CommonText(
                  text: subtitle!,
                  fontFamily: FontFamily.poppinsRegular,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration salesOrderSearchDecoration({String hint = 'Enter here to search'}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    prefixIcon: const Padding(
      padding: EdgeInsets.only(left: 10, right: 6),
      child: Icon(Icons.search, size: 24, color: AppColors.brandRed),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 30),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brandRed, width: 1.5),
    ),
  );
}

class SalesOrderDeleteDialog extends StatelessWidget {
  const SalesOrderDeleteDialog({super.key, required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.brandRed,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: CommonText(
                  text: 'Delete Order',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CommonText(
                    text: 'Are you sure you want to delete this?',
                    fontFamily: FontFamily.poppinsMedium,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          btnName: 'No',
                          btnColor: Colors.transparent,
                          textColor: Colors.black87,
                          borderColor: AppColors.brandRed,
                          onTap: () => Get.back(),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: CommonButton(
                          btnName: 'Yes',
                          onTap: onConfirm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesOrderListCard extends StatelessWidget {
  const SalesOrderListCard({
    super.key,
    required this.salesOrderId,
    this.customerName,
    this.netAmount,
    this.orderNumber,
    this.date,
    this.salesPerson,
    this.contactNumber,
    this.invoiceType,
    this.allowEditEntry,
    this.allowDeleteEntry,
    this.onExpansionChanged,
    this.onEdit,
    required this.onPdf,
    this.onDelete,
  });

  final String salesOrderId;
  final String? customerName;
  final String? netAmount;
  final String? orderNumber;
  final String? date;
  final String? salesPerson;
  final String? contactNumber;
  final String? invoiceType;
  final bool? allowEditEntry;
  final bool? allowDeleteEntry;
  final ValueChanged<bool>? onExpansionChanged;
  final VoidCallback? onEdit;
  final VoidCallback onPdf;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: Key(salesOrderId),
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: onExpansionChanged,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: customerName ?? 'N/A',
                fontFamily: FontFamily.poppinsSemiBold,
                fontSize: 15,
                color: Colors.black87,
              ),
              const Gap(4),
              Row(
                children: [
                  CommonText(
                    text: '₹${netAmount ?? '0'}',
                    fontFamily: FontFamily.poppinsBold,
                    fontSize: 14,
                    color: AppColors.brandRed,
                  ),
                  if ((orderNumber ?? '').isNotEmpty) ...[
                    const Gap(8),
                    CommonText(
                      text: '• #$orderNumber',
                      fontFamily: FontFamily.poppinsMedium,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ],
                ],
              ),
            ],
          ),
          children: [
            const Divider(height: 1),
            const Gap(6),
            SalesOrderDetailRow(label: 'Customer Name', value: customerName),
            SalesOrderDetailRow(label: 'Sales Person', value: salesPerson),
            SalesOrderDetailRow(label: 'Contact Number', value: contactNumber),
            SalesOrderDetailRow(label: 'Order No.', value: orderNumber),
            SalesOrderDetailRow(label: 'Date', value: date),
            SalesOrderDetailRow(label: 'Invoice Type', value: invoiceType),
            SalesOrderDetailRow(
              label: 'Net Amount',
              value: netAmount,
              highlight: true,
            ),
            const Gap(8),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   decoration: const BoxDecoration(
            //     color: Color(0xffF8F8F8),
            //     borderRadius:
            //         BorderRadius.vertical(bottom: Radius.circular(14)),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       if (allowEditEntry == true && onEdit != null)
            //         _ActionChip(
            //           icon: Icons.edit_outlined,
            //           label: 'Edit',
            //           color: const Color(0xFF3B82F6),
            //           onTap: onEdit!,
            //         ),
            //       _ActionChip(
            //         icon: Icons.picture_as_pdf_outlined,
            //         label: 'PDF',
            //         color: const Color(0xFF22C55E),
            //         onTap: onPdf,
            //       ),
            //       if (allowDeleteEntry == true && onDelete != null)
            //         _ActionChip(
            //           icon: Icons.delete_outline,
            //           label: 'Delete',
            //           color: const Color(0xFFEF4444),
            //           onTap: onDelete!,
            //         ),
            //     ],
            //   ),
            // ),
          ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const Gap(4),
          CommonText(
            text: label,
            fontFamily: FontFamily.poppinsMedium,
            fontSize: 11,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}

class SalesOrderFilterField extends StatelessWidget {
  const SalesOrderFilterField({
    super.key,
    required this.label,
    required this.hasValue,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final bool hasValue;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasValue ? AppColors.brandRed : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: CommonText(
                text: label,
                fontFamily: FontFamily.poppinsMedium,
                fontSize: 14,
                color: hasValue ? Colors.black87 : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: hasValue ? onClear : onTap,
              child: Icon(
                hasValue ? Icons.cancel : Icons.keyboard_arrow_down_rounded,
                color: hasValue ? AppColors.brandRed : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesOrderItemTile extends StatelessWidget {
  const SalesOrderItemTile({
    super.key,
    required this.imageUrl,
    required this.itemName,
    required this.price,
    required this.isSelected,
    required this.quantity,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  final String? imageUrl;
  final String itemName;
  final String price;
  final bool isSelected;
  final String quantity;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandRed.withOpacity(0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.brandRed : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl ?? '',
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/logo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: itemName,
                      fontFamily: FontFamily.poppinsSemiBold,
                      fontSize: 14,
                      color: Colors.black87,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        CommonText(
                          text: 'Price: ₹$price',
                          fontFamily: FontFamily.poppinsMedium,
                          fontSize: 13,
                          color: const Color(0xFF16A34A),
                        ),
                        if (isSelected && quantity.isNotEmpty) ...[
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CommonText(
                              text: 'Qty: $quantity',
                              fontFamily: FontFamily.poppinsSemiBold,
                              fontSize: 12,
                              color: AppColors.brandRed,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                activeColor: AppColors.brandRed,
                onChanged: onCheckboxChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesOrderQtyDialog extends StatelessWidget {
  const SalesOrderQtyDialog({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.rate,
    required this.qtyController,
    required this.onConfirm,
  });

  final String itemName;
  final String? imageUrl;
  final String rate;
  final TextEditingController qtyController;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.brandRed,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: CommonText(
                  text: 'Add Quantity',
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl ?? '',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const Gap(14),
                  CommonText(
                    text: itemName,
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 15,
                    color: Colors.black87,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: 'Quantity',
                              fontFamily: FontFamily.poppinsMedium,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            const Gap(6),
                            TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FontFamily.poppinsBold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Qty',
                                filled: true,
                                fillColor: const Color(0xffF8F8F8),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.brandRed,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: 'Rate',
                              fontFamily: FontFamily.poppinsMedium,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            const Gap(6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CommonText(
                                text: rate,
                                fontFamily: FontFamily.poppinsBold,
                                fontSize: 16,
                                color: AppColors.brandRed,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.brandRed),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: CommonText(
                            text: 'Cancel',
                            fontFamily: FontFamily.poppinsSemiBold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: CommonButton(
                          btnName: 'OK',
                          onTap: onConfirm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
