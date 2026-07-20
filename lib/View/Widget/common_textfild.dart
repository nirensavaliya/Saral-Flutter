import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';



class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLine;
  final String? hintText;
  final TextAlign? textAlign;
  final double? fontSize;
  final int? maxLength;
  final double? borderRadius;
  final bool isTitle;
  final bool obscureText;
  final bool showCursor;
  final bool readOnly;
  final String? title;
  final TextInputType? textInputType;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final BoxConstraints? prefixIconConstraints;
  final TextCapitalization textCapitalization;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const CommonTextField({
    super.key,
    required this.controller,
    this.prefix,
    this.suffix,
    this.maxLine,
    this.hintText,
    this.textAlign,
    this.fontSize,
    this.maxLength,
    this.borderRadius,
    this.isTitle = false,
    this.title,
    this.onTap,
    this.obscureText = false,
    this.showCursor = true,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.focusNode,
    this.onChanged, this.textInputType,this.validator,this.textInputAction,this.prefixIconConstraints,this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isTitle)
          Text(
            title ?? "",
            style: TextStyle(
              fontFamily: FontFamily.poppinsBold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        if(isTitle)
          Gap(5),
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(borderRadius ?? 16)
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            maxLines: maxLine ?? 1,
            textAlign: textAlign ?? TextAlign.start,
            cursorColor: Colors.black,
            onFieldSubmitted: onFieldSubmitted,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize ?? 16,
              fontFamily: FontFamily.poppinsRegular,
              fontWeight: FontWeight.w400,
            ),
            maxLength: maxLength,
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardType: textInputType ?? TextInputType.text,
            obscureText: obscureText,
            inputFormatters: inputFormatters ??
                ((textInputType == TextInputType.number ||
                    textInputType == const TextInputType.numberWithOptions())
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : (textInputType ==
                    const TextInputType.numberWithOptions(decimal: true))
                    ? [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*'),
                  ),
                ]
                    : null),
            readOnly: readOnly,
            showCursor: showCursor,
            onTap: onTap,
            onChanged: onChanged,
            validator: validator,
            textAlignVertical: suffix != null ? TextAlignVertical.center : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              counter: SizedBox(),
              counterText: '',
              disabledBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.2,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.2,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.2,
                ),
              ),
              // border: InputBorder.none,
              // enabledBorder: InputBorder.none,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.brandRed, width: 1.5),
              ),
              // focusedBorder: InputBorder.none,

              focusedErrorBorder: InputBorder.none,
              suffixIcon: suffix,
              prefixIcon: prefix,
              prefixIconConstraints: prefixIconConstraints,
              hintText: hintText ?? "",
              hintStyle: TextStyle(
                color: Color(0xFF8F8F8F),
                fontSize: 16,
                fontFamily: FontFamily.poppinsRegular,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset < oldValue.selection.baseOffset) {
      return newValue;
    }
    if (text.length == 2 || text.length == 5) {
      if (!text.endsWith('/')) {
        text += '/';
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
