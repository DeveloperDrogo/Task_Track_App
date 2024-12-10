import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_pallet.dart';


class TaskDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime?firstDate;
  final DateTime? lastDate;
  final String label;
  final String hintText;
  final bool validatorRequired;
  final Function(DateTime) onDateSelected;
  final String? Function(DateTime?)? validator;

  const TaskDatePicker({
    Key? key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    this.validatorRequired=false, required this.label, required this.hintText, this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: DateTimeFormField(
        dateFormat: DateFormat("dd-MM-yyyy"),
        initialValue: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        dateTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18),
          hintText: hintText,
          label:  Text(label),
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            IconlyBroken.calendar,
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppPallete.primaryDarkColor
                : AppPallete.primaryColor,
            size: 28,
          ),
        ),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.disabled,
        onDateSelected: onDateSelected,
        validator: (DateTime? value) {
          if (!validatorRequired) return null; // Skip validation if not required
          if (value == null) {
            return 'Date is required';
          }
          return validator?.call(value);
        },
      ),
    );
  }
}
