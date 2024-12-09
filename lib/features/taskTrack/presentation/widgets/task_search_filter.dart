// ignore_for_file: file_names

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class TaskSearchFilter extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onclear;
  final Function(String) onChanged;
  const TaskSearchFilter(
      {super.key, required this.searchController, required this.onclear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              
              contentPadding: const EdgeInsets.all(13),
              hintText: "Search task here ",
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  
              prefixIcon: Icon(
                IconlyBroken.search,
                color: AdaptiveTheme.of(context).mode.isDark
                    ? Colors.white
                    : Colors.black,
                size: 28,
              ),
              // suffixIcon: GestureDetector(
              //   onTap: onclear,
              //   child: const Icon(
              //     Icons.cancel,
              //     color: AppPallete.errorColor,
              //     size: 28,
              //   ),
              // ),
            ),
            onChanged: (value) {
             onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}
