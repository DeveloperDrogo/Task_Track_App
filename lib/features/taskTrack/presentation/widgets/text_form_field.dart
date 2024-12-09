import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';

class TaskTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Color borderColor;
  final int? iconSize;
  final Icon? icon; // Optional icon
  final TextInputType? keyboardType; // Optional keyboard type
  final int? maxLength; // Optional max length
  final bool readOnly; // New parameter for read-only
  final int minLines;
  final int maxLines;

  const TaskTextFormField(
      {Key? key,
      required this.label,
      required this.hintText,
      this.borderColor = Colors.grey,
      this.icon,
      this.iconSize,
      required this.controller,
      this.keyboardType,
      this.maxLength,
      this.readOnly = false,
      required this.minLines,
      required this.maxLines // Default is false (editable)
      })
      : super(key: key);

  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  @override
  Widget build(BuildContext context) {
    if (hintText.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType:
              keyboardType ?? TextInputType.text, // Default to any text input
          maxLength: maxLength, // Apply max length if provided
          readOnly:
              readOnly, // Make the field read-only based on the passed parameter
          decoration: InputDecoration(
            //floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.all(18),
            prefixIcon: icon != null
                ? Icon(
                    icon!.icon,
                    size: iconSize?.toDouble() ?? 25.0,
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? AppPallete.primaryDarkColor
                        : AppPallete.primaryDarkColor,
                  )
                : const Icon(
                    IconlyBroken.profile,
                    color: AppPallete.primaryDarkColor,
                  ),
            label: Text(label),
            hintText: hintText,
            counterText: maxLength != null
                ? ''
                : null, // Hides the character count if maxLength is not provided
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label is missing";
            }
            if (maxLength != null && value.length < maxLength!) {
              return "Please enter at least $maxLength characters";
            }
            return null;
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
