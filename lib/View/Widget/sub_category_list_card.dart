import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class SubCategoryListCard extends StatelessWidget {
  final String subCategoryName;
  final VoidCallback? onTap;
  final bool showChevron;

  const SubCategoryListCard({
    super.key,
    required this.subCategoryName,
    this.onTap,
    this.showChevron = true,
  });

  factory SubCategoryListCard.fromData({
    required SubCategoryListData item,
    VoidCallback? onTap,
    bool showChevron = true,
  }) {
    return SubCategoryListCard(
      subCategoryName: item.subCategoryName ?? "--",
      onTap: onTap,
      showChevron: showChevron,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: "Sub Category",
                  fontFamily: FontFamily.poppinsRegular,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 4),
                CommonText(
                  text: subCategoryName,
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 16,
                  color: AppColors.black,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showChevron)
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade500,
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: content,
      ),
    );
  }
}
