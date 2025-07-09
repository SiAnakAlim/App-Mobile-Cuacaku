import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final bool expands;
  final Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.suffixIcon,
    this.textInputAction,
    this.onChanged,
    this.autofocus = false,
    this.contentPadding,
    this.maxLength,
    this.expands = false,
    this.buildCounter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        readOnly: readOnly,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        textInputAction: textInputAction,
        onChanged: onChanged,
        autofocus: autofocus,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon, color: Colors.amber[700]) : null,
          suffixIcon: suffixIcon,
          counter: maxLength != null
              ? buildCounter != null
              ? buildCounter!(
            context,
            currentLength: controller.text.length,
            isFocused: FocusScope.of(context).hasFocus,
            maxLength: maxLength,
          )
              : null
              : null,
          contentPadding: contentPadding ?? const EdgeInsets.all(16),
          labelStyle: GoogleFonts.openSans(),
          hintStyle: GoogleFonts.openSans(color: Colors.grey[500]),
          floatingLabelStyle: GoogleFonts.openSans(
            color: Colors.amber[900],
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[900]!, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[700]!, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red[900]!, width: 3),
          ),
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
        ),
        style: GoogleFonts.openSans(),
      ),
    );
  }
}