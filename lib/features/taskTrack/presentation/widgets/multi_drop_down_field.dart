import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';
import 'package:task_track_app/features/taskTrack/domain/entities/label_data.dart';

class TaskMultiDropDownField extends StatelessWidget {
  final MultiSelectController<LabelsData> controller;
  final List<DropdownItem<LabelsData>> items;
  final Function(List<LabelsData>) onChanged;
  final List ?initialSelectedLabels;

  const TaskMultiDropDownField({
    super.key,
    required this.controller,
    required this.items,
    required this.onChanged,  this.initialSelectedLabels,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownItem<LabelsData>> selectedItems = initialSelectedLabels!
      .map((labelName) => DropdownItem<LabelsData>(
            value: LabelsData(
                labelName: labelName,
                labelId: '',
            ),
            label: labelName,
          ))
      .toList();
    controller.selectWhere((item) => selectedItems.contains(item),);
    return MultiDropdown(
      items: items,
      controller: controller,
      enabled: true,
      searchEnabled: true,
      chipDecoration: ChipDecoration(
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        deleteIcon: const Icon(
          Icons.close,
          size: 17,
          color: Colors.white,
        ),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? AppPallete.primaryDarkColor
            : AppPallete.primaryColor,
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Label',
        hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
        prefixIcon: Icon(
          Icons.label_important_outline_rounded,
          color: AdaptiveTheme.of(context).mode.isDark
              ? AppPallete.primaryDarkColor
              : AppPallete.primaryColor,
        ),
        padding: const EdgeInsets.all(20),
        showClearIcon: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPallete.lightborderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppPallete.primaryDarkColor
                : AppPallete.primaryColor,
          ),
        ),
      ),
      dropdownDecoration: DropdownDecoration(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? AppPallete.cardDarkBackgroundColor
            : AppPallete.lightBackgroundColor,
        marginTop: 2,
        maxHeight: 500,
        header: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Select labels from the list',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedBackgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? AppPallete.borderColor
            : AppPallete.lightCircleAvatarColor,
        selectedIcon: Icon(
          Icons.check_box,
          color: AdaptiveTheme.of(context).mode.isDark
              ? const Color.fromARGB(255, 152, 141, 222)
              : AppPallete.primaryColor,
        ),
        disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
      ),
      
      onSelectionChange: (selectedItems) {

        onChanged(selectedItems.map((item) => item).toList());
      },
    );
  }
}
