import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class RichTextField extends StatelessWidget {
  final String keyText;
  final String valueText;
  const RichTextField(
      {super.key, required this.keyText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: RichText(
        text: TextSpan(
          text: keyText,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: AdaptiveTheme.of(context).mode.isDark
                    ? const Color.fromARGB(255, 178, 178, 178)
                    : const Color.fromARGB(255, 140, 140, 140),
                fontWeight: FontWeight.w400,
              ),
          children: [
            TextSpan(
              text: valueText,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
