import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final double? width;
  final double height;
  final double elevation;
  final BorderRadiusGeometry? borderRadius;
  final LinearGradient? gradient;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.elevation = 5,
    this.borderRadius,
    this.gradient,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.amber[800];
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(12);
    final textStyleValue = textStyle ?? GoogleFonts.openSans(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final paddingValue = padding ?? EdgeInsets.zero;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient != null ? null : buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusValue,
          ),
          elevation: elevation,
          padding: paddingValue,
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey[400];
              }
              return gradient != null ? null : buttonColor;
            },
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Container(
          decoration: gradient != null
              ? BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadiusValue,
          )
              : null,
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: icon != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: textStyleValue,
                ),
              ],
            )
                : Text(
              text,
              style: textStyleValue,
            ),
          ),
        ),
      ),
    );
  }
}