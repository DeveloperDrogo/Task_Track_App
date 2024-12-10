// ignore_for_file: deprecated_member_use

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';

class TaskDateTimeLine extends StatelessWidget {
  final Function(DateTime) onDateChange;
  const TaskDateTimeLine({super.key, required this.onDateChange});

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      activeColor: AdaptiveTheme.of(context).mode.isDark
          ? AppPallete.primaryDarkColor
          : null,
      headerProps: EasyHeaderProps(
          selectedDateStyle: TextStyle(
              color:
                  AdaptiveTheme.of(context).mode.isDark ? Colors.white : null)),
      dayProps: EasyDayProps(
          borderColor: AdaptiveTheme.of(context).mode.isDark
              ? const Color.fromARGB(255, 109, 109, 109)
              : const Color.fromARGB(255, 228, 228, 228),
          height: 80,
          // inactiveDayDecoration: BoxDecoration(
          //   border: Border.all(width: 0.4,color: Colors.grey),
          //   borderRadius: BorderRadius.circular(10),
          // ),
          inactiveDayStyle: DayStyle(
              dayStrStyle: TextStyle(
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? Colors.white
                      : null)),
          inactiveDayNumStyle: TextStyle(
              color:
                  AdaptiveTheme.of(context).mode.isDark ? Colors.white : null),
          inactiveMothStrStyle: TextStyle(
              color:
                  AdaptiveTheme.of(context).mode.isDark ? Colors.white : null),
          todayStyle: DayStyle(
              dayStrStyle: TextStyle(
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? Colors.white
                      : null)),
          todayNumStyle: TextStyle(
              color:
                  AdaptiveTheme.of(context).mode.isDark ? Colors.white : null),
          todayMonthStrStyle: TextStyle(
              color:
                  AdaptiveTheme.of(context).mode.isDark ? Colors.white : null)),
      onDateChange: onDateChange,
      initialDate: DateTime.now(),
    );
  }
}
