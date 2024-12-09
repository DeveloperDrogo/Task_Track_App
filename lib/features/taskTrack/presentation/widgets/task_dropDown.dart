import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';


class TaskDropDownField extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String label;
  final List dropdownValues;
  final int? iconSize;
  final Icon? icon; // Make the icon optional and nullable

  const TaskDropDownField({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.label,
    required this.dropdownValues,
    this.icon,
    this.iconSize, // Optional iconSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.all(18),
          hintText: 'Select $label',
          label: Text(label),
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          
          prefixIcon: icon != null
              ? Icon(
                  icon!.icon, // Use the provided icon's iconData
                  size: iconSize?.toDouble() ??
                      25.0, // Cast int to double and provide default value
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? AppPallete.primaryDarkColor
                      : AppPallete
                          .primaryColor, // Use icon color or default to primaryDarkColor
                )
              : const Icon(
                  IconlyBroken.document,
                  color:
                      AppPallete.primaryDarkColor, // Default color for the icon
                ),
        ),
        isExpanded: true,  // Ensure the dropdown takes up the full width
        value: selectedValue,
        onChanged: onChanged,
        items: dropdownValues
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select $label';
          }
          return null;
        },
        
      ),
    );
  }
}
