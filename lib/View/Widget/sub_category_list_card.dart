import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Model/subCategoryListModel.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class SubCategoryListCard extends StatelessWidget {
  final String subCategoryName;
  final String? imageUrl;
  final String? brandName;
  final String? categoryName;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool catalogVertical;

  const SubCategoryListCard({
    super.key,
    required this.subCategoryName,
    this.imageUrl,
    this.brandName,
    this.categoryName,
    this.onTap,
    this.showChevron = true,
    this.catalogVertical = false,
  });

  factory SubCategoryListCard.fromData({
    required SubCategoryListData item,
    String? brandName,
    String? categoryName,
    VoidCallback? onTap,
    bool showChevron = true,
    bool catalogVertical = false,
  }) {
    return SubCategoryListCard(
      subCategoryName: item.subCategoryName ?? "--",
      imageUrl: item.imageUrl,
      brandName: brandName,
      categoryName: categoryName,
      onTap: onTap,
      showChevron: showChevron,
      catalogVertical: catalogVertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = catalogVertical
        ? _buildCatalogVerticalCard()
        : _buildCompactHorizontalCard();

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

  Widget _buildCatalogVerticalCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
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
          SizedBox(
            width: double.infinity,
            height: 160,
            child: Container(
              color: const Color(0xffF3F4F6),
              child: buildCatalogNetworkImage(imageUrl: imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: subCategoryName,
                  fontFamily: FontFamily.poppinsSemiBold,
                  fontSize: 16,
                  color: AppColors.black,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                CommonLabelValueText(
                  label: "Brand",
                  value: brandName,
                  fontSize: 12,
                  valueColor: AppColors.brandRed,
                ),
                const SizedBox(height: 4),
                CommonLabelValueText(
                  label: "Category",
                  value: categoryName,
                  fontSize: 12,
                  valueColor: AppColors.brandRed,
                ),
                const SizedBox(height: 4),
                CommonLabelValueText(
                  label: "Sub Category",
                  value: subCategoryName,
                  fontSize: 12,
                  valueColor: AppColors.brandRed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHorizontalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: buildCatalogNetworkImage(
                imageUrl: imageUrl,
                width: 52,
                height: 52,
              ),
            ),
          ),
          const SizedBox(width: 14),
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
  }
}
