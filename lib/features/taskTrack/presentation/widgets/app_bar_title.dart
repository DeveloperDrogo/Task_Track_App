import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 35),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "Welcome to,",
                style: GoogleFonts.aBeeZee(
                  textStyle:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                ),
                children: [
                  TextSpan(
                    text: ' TaskVision',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }
}
