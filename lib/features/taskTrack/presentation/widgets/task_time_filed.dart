import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:task_track_app/core/theme/app_pallet.dart'; // Import intl for DateFormat

class TimePickerWidget extends StatelessWidget {
  final String label;
  final Time? time;
  final Function(Time) onTimeChanged;
  final DateFormat format;
  final String defaultText;
  final bool isReadOnly;
  final bool is12Hour; // New parameter to control time format

  const TimePickerWidget({
    Key? key,
    required this.label,
    required this.time,
    required this.onTimeChanged,
    required this.format,
    required this.defaultText,
    this.isReadOnly = false,
    this.is12Hour = false, // Default to 24-hour mode (false)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isReadOnly
              ? null
              : () {
                  Navigator.of(context).push(
                    showPicker(
                      backgroundColor: AdaptiveTheme.of(context).mode.isDark
                          ? AppPallete.darkBackgroundColor
                          : null,
                      context: context,
                      value: time ?? Time(hour: 7, minute: 0),
                      is24HrFormat:false, // Control 12/24-hour format
                      onChange: (newTime) {
                     onTimeChanged(newTime);
                      },
                      maxHour: is12Hour ? 23 : 19, // Adjust max hour
                      minHour: is12Hour ? 0 : 7, // Adjust min hour
                    ),
                  );
                },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    IconlyBroken.time_circle,
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? AppPallete.primaryDarkColor
                        : AppPallete.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  time != null
                      ? format
                          .format(
                            DateTime(0, 0, 0, time!.hour, time!.minute),
                          )
                          .toUpperCase()
                      : defaultText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (time != null)
          Padding(
            padding: const EdgeInsets.only(left: 29),
            child: FractionalTranslation(
              translation: const Offset(0, -3.4),
              child: Container(
                height: 20,
                color: AdaptiveTheme.of(context).mode.isDark
                    ? AppPallete.darkBackgroundColor
                    : AppPallete.lightBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
