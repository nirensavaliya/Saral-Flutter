import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_font.dart';

class CommonButton extends StatelessWidget {
  final String? btnName;
  final Color? btnColor;
  final Color? textColor;
  final Color? borderColor;
  final void Function()? onTap;
  final bool isLoading;
  final IconData? icon;
  final IconData? surfixIcon;
  final IconData? prefixIcon;
  final double? fontSize;

  const CommonButton({
    super.key,
    this.btnName,
    this.onTap,
    this.btnColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.icon,
    this.surfixIcon,
    this.prefixIcon,
    this.fontSize,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: 2,
          ),
          color: borderColor != null
              ? Color(0xffC8102E)
              : (btnColor ?? Color(0xffC8102E)),
        ),
        child: Center(
            child: isLoading
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xff2563EB),
              ),
            )
                : FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: borderColor != null
                          ? Colors.black
                          : (textColor ?? Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (prefixIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      prefixIcon,
                      size: 20,
                      color: borderColor != null
                          ? Colors.black
                          : (textColor ?? Colors.white),
                    ),
                    const SizedBox(width: 8),

                  ],
                  Flexible(
                    child: Text(
                      btnName ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontFamily.poppinsMedium,
                        fontSize: fontSize ?? 15,
                        color: textColor ?? Colors.white,
                      ),
                    ),
                  ),
                  if (surfixIcon != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      surfixIcon,
                      size: 20,
                      color: borderColor != null
                          ? Colors.black
                          : (textColor ?? Colors.white),
                    ),
                  ],

                ],
              ),
            )
        ),
      ),
    );
  }
}