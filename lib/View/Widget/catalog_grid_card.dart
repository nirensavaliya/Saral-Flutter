import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/catalog_image_placeholder.dart';

class CatalogGridCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? priceText;
  final String? brand;
  final String? category;
  final String? subCategory;
  final bool showDetails;
  final VoidCallback onTap;

  const CatalogGridCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.priceText,
    this.brand,
    this.category,
    this.subCategory,
    this.showDetails = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xffF3F4F6),
                child: buildCatalogNetworkImage(imageUrl: imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: title,
                    fontFamily: FontFamily.poppinsSemiBold,
                    fontSize: 13,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black87,
                  ),
                  if (showDetails) ...[
                    if (priceText != null) ...[
                      const SizedBox(height: 4),
                      CommonText(
                        text: priceText ?? '',
                        fontFamily: FontFamily.poppinsBold,
                        fontSize: 14,
                        color: AppColors.brandRed,
                      ),
                    ],
                    const SizedBox(height: 4),
                    CommonLabelValueText(
                      label: "Brand",
                      value: brand,
                      fontSize: 12,
                      valueColor: AppColors.brandRed,
                    ),
                    const SizedBox(height: 2),
                    CommonLabelValueText(
                      label: "Category",
                      value: category,
                      fontSize: 12,
                      valueColor: AppColors.brandRed,
                    ),
                    const SizedBox(height: 2),
                    CommonLabelValueText(
                      label: "Sub Category",
                      value: subCategory,
                      fontSize: 12,
                      valueColor: AppColors.brandRed,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
