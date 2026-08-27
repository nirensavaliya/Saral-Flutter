import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class CatalogImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool showLabel;

  const CatalogImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.showLabel = true,
  });

  double _logoSize(BoxConstraints constraints) {
    final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 80.0;
    final maxH = constraints.maxHeight.isFinite ? constraints.maxHeight : 80.0;
    final resolvedW = (width != null && width!.isFinite) ? width! : maxW;
    final resolvedH = (height != null && height!.isFinite) ? height! : maxH;
    return (resolvedH < resolvedW ? resolvedH : resolvedW) * 0.35;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final logo = _logoSize(constraints).clamp(28.0, 56.0);

        return Container(
          width: width,
          height: height,
          color: const Color(0xFFF4F4F4),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.logoImg,
                width: logo,
                height: logo,
                fit: BoxFit.contain,
              ),
              if (showLabel) ...[
                const SizedBox(height: 8),
                 CommonText(
                  text: "NO IMAGE AVAILABLE",
                  fontFamily: FontFamily.poppinsMedium,
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

Widget buildCatalogNetworkImage({
  required String? imageUrl,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  final url = imageUrl?.trim();
  final hasBoundedSize = width != null &&
      height != null &&
      width.isFinite &&
      height.isFinite;

  Widget placeholder({bool showLabel = true}) {
    return CatalogImagePlaceholder(
      width: hasBoundedSize ? width : null,
      height: hasBoundedSize ? height : null,
      fit: fit,
      showLabel: showLabel,
    );
  }

  if (url == null || url.isEmpty) {
    if (hasBoundedSize) {
      return placeholder();
    }
    return SizedBox.expand(child: placeholder());
  }

  if (hasBoundedSize) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder(showLabel: false);
      },
      errorBuilder: (_, __, ___) => placeholder(),
    );
  }

  return SizedBox.expand(
    child: Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder(showLabel: false);
      },
      errorBuilder: (_, __, ___) => placeholder(),
    ),
  );
}
