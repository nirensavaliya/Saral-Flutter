import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? height;
  final double? letterSpacing;

  const CommonText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.color = Colors.black,
    required this.fontFamily,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.fontWeight,
    this.height,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

/// Label + value in one RichText line, e.g. Brand: Samsung
class CommonLabelValueText extends StatelessWidget {
  final String label;
  final String? value;
  final double fontSize;
  final Color labelColor;
  final Color valueColor;
  final String? labelFontFamily;
  final String? valueFontFamily;
  final int maxLines;
  final String emptyText;

  const CommonLabelValueText({
    super.key,
    required this.label,
    this.value,
    this.fontSize = 12,
    this.labelColor = const Color(0xFF6B7280),
    this.valueColor = AppColors.black,
    this.labelFontFamily,
    this.valueFontFamily,
    this.maxLines = 1,
    this.emptyText = "--",
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
        (value ?? "").trim().isEmpty ? emptyText : value!.trim();
    final labelText =
        label.endsWith(":") || label.endsWith(": ") ? label : "$label: ";
    final labelFamily = labelFontFamily ?? FontFamily.poppinsMedium;
    final valueFamily = valueFontFamily ?? FontFamily.poppinsSemiBold;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: fontSize,
              color: labelColor,
              fontFamily: labelFamily,
              height: 1.25,
            ),
          ),
          TextSpan(
            text: displayValue,
            style: TextStyle(
              fontSize: fontSize,
              color: valueColor,
              fontFamily: valueFamily,
              height: 1.25,
            ),
          ),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
